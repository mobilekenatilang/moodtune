part of '_datasources.dart';

abstract class CalendarLocalDataSource {
  Future<Parsed<Map<String, dynamic>>> getMonth(int year, int month);
  Future<Parsed<Map<String, dynamic>>> saveDayMood(DayMoodModel mood);
}

@Injectable(as: CalendarLocalDataSource)
class CalendarLocalDataSourceImpl implements CalendarLocalDataSource {
  final Box<MonthMoodSummaryModel> box;

  CalendarLocalDataSourceImpl(this.box);

  @override
  Future<Parsed<Map<String, dynamic>>> getMonth(int year, int month) async {
    final key = _key(year, month);
    final data = box.get(key);

    if (data == null) {
      throw Exception('No month data found in local storage for $key');
    }

    return Parsed.fromDynamicData(
      200,
      {'result': data}, 
    );
  }

  @override
  Future<Parsed<Map<String, dynamic>>> saveDayMood(DayMoodModel mood) async {
    final key = _key(mood.date.year, mood.date.month);
    final existing = box.get(key);

    if (existing == null) {
      final newSummary = MonthMoodSummaryModel(
        year: mood.date.year,
        month: mood.date.month,
        days: [mood],
        avgMood: 0,
        labelCount: {mood.label: 1},
        lastSync: DateTime.now(),
      );
      await box.put(key, newSummary);

      return Parsed.fromDynamicData(200, {'result': newSummary});
    } else {
      final updated = _updateSummary(existing, mood);
      await box.put(key, updated);

      return Parsed.fromDynamicData(200, {'result': updated});
    }
  }

  // Helper untuk membuat key unik Hive
  String _key(int year, int month) =>
      "$year-${month.toString().padLeft(2, '0')}";

  MonthMoodSummaryModel _updateSummary(
    MonthMoodSummaryModel oldSummary,
    DayMoodModel newMood,
  ) {
    final days = List<DayMoodModel>.from(oldSummary.days);

    final index = days.indexWhere(
      (d) =>
          d.date.year == newMood.date.year &&
          d.date.month == newMood.date.month &&
          d.date.day == newMood.date.day,
    );

    final labelCount = Map<String, int>.from(oldSummary.labelCount);

    if (index == -1) {
      days.add(newMood);
      labelCount[newMood.label] = (labelCount[newMood.label] ?? 0) + 1;
    } else {
      final oldLabel = days[index].label;
      if (oldLabel != newMood.label) {
        labelCount[oldLabel] = (labelCount[oldLabel]! - 1).clamp(0, 9999);
        if (labelCount[oldLabel] == 0) labelCount.remove(oldLabel);
        labelCount[newMood.label] = (labelCount[newMood.label] ?? 0) + 1;
      }
      days[index] = newMood;
    }

    return oldSummary.copyWith(
      days: days,
      avgMood: 0, // di UI hitung persentase
      labelCount: labelCount,
      lastSync: DateTime.now(),
    );
  }
}
