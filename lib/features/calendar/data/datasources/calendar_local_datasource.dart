part of '_datasources.dart';

abstract class CalendarLocalDataSource {
  Future<Parsed<Map<String, dynamic>>> getMonth(int year, int month);
  Future<Parsed<Map<String, dynamic>>> saveDayMood(DailyMoodEntry entry);
}

@Injectable(as: CalendarLocalDataSource)
class CalendarLocalDataSourceImpl implements CalendarLocalDataSource {
  final Box<MonthMoodSummaryModel> box;

  CalendarLocalDataSourceImpl(this.box);

  @override
  Future<Parsed<Map<String, dynamic>>> getMonth(int year, int month) async {
    final key = _key(year, month);
    final data = box.get(key);
    // Jika belum ada data bulan ini, kembalikan summary kosong
    final summary =
        data ??
        MonthMoodSummaryModel(
          year: year,
          month: month,
          days: [],
          labelCount: {},
          lastSync: DateTime.now(),
        );
    return Parsed.fromDynamicData(200, {'result': summary});
  }

  @override
  Future<Parsed<Map<String, dynamic>>> saveDayMood(DailyMoodEntry entry) async {
    final key = _key(entry.timestamp.year, entry.timestamp.month);
    final raw = box.get(key);

    // Inisialisasi summary bulanan jika belum ada
    final summary =
        raw ??
        MonthMoodSummaryModel(
          year: entry.timestamp.year,
          month: entry.timestamp.month,
          days: [],
          labelCount: {},
          lastSync: DateTime.now(),
        );

    // 1) Append entry ke DaySummaryModel
    final days = List<DaySummaryModel>.from(summary.days);
    final dateOnly = DateTime(
      entry.timestamp.year,
      entry.timestamp.month,
      entry.timestamp.day,
    );
    final idx = days.indexWhere((d) => d.date == dateOnly);
    if (idx == -1) {
      // Hari baru
      days.add(DaySummaryModel(date: dateOnly, entries: [entry]));
    } else {
      // Hari sudah ada → tambahkan ke list entries
      final existing = days[idx];
      days[idx] = existing.copyWith(entries: [...existing.entries, entry]);
    }

    // 2) Update distribusi bulanan
    final labelCount = Map<String, int>.from(summary.labelCount);
    labelCount[entry.label] = (labelCount[entry.label] ?? 0) + 1;

    // 3) Simpan summary yang di‑update
    final updated = summary.copyWith(
      days: days,
      labelCount: labelCount,
      lastSync: DateTime.now(),
    );
    await box.put(key, updated);

    return Parsed.fromDynamicData(200, {'result': updated});
  }

  /// Helper untuk key box: "YYYY-MM"
  String _key(int year, int month) =>
      '$year-${month.toString().padLeft(2, '0')}';
}
