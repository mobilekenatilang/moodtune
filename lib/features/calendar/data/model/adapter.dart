import 'package:hive/hive.dart';
import 'daily_mood_entry.dart';
import 'day_summary_model.dart';
import 'month_mood_summary_model.dart';

/// 1) Adapter untuk DailyMoodEntry
class DailyMoodEntryAdapter extends TypeAdapter<DailyMoodEntry> {
  @override
  final int typeId = 1;

  @override
  DailyMoodEntry read(BinaryReader reader) {
    final ts = DateTime.parse(reader.readString());
    final label = reader.readString();
    final emoji = reader.readString();
    return DailyMoodEntry(
      timestamp: ts,
      label: label,
      emoji: emoji,
    );
  }

  @override
  void write(BinaryWriter writer, DailyMoodEntry obj) {
    writer.writeString(obj.timestamp.toIso8601String());
    writer.writeString(obj.label);
    writer.writeString(obj.emoji);
  }
}

/// 2) Adapter untuk DaySummaryModel
class DaySummaryModelAdapter extends TypeAdapter<DaySummaryModel> {
  @override
  final int typeId = 2;

  @override
  DaySummaryModel read(BinaryReader reader) {
    final date = DateTime.parse(reader.readString());
    final count = reader.readInt();
    final entries = <DailyMoodEntry>[];
    for (var i = 0; i < count; i++) {
      entries.add(reader.read() as DailyMoodEntry);
    }
    return DaySummaryModel(date: date, entries: entries);
  }

  @override
  void write(BinaryWriter writer, DaySummaryModel obj) {
    writer.writeString(obj.date.toIso8601String());
    writer.writeInt(obj.entries.length);
    for (var e in obj.entries) {
      writer.write(e);
    }
  }
}

/// 3) Adapter untuk MonthMoodSummaryModel
class MonthMoodSummaryModelAdapter
    extends TypeAdapter<MonthMoodSummaryModel> {
  @override
  final int typeId = 3;

  @override
  MonthMoodSummaryModel read(BinaryReader reader) {
    final year = reader.readInt();
    final month = reader.readInt();

    final dayCount = reader.readInt();
    final days = <DaySummaryModel>[];
    for (var i = 0; i < dayCount; i++) {
      days.add(reader.read() as DaySummaryModel);
    }

    // labelCount map
    final mapLen = reader.readInt();
    final labelCount = <String,int>{};
    for (var i = 0; i < mapLen; i++) {
      final key = reader.readString();
      final val = reader.readInt();
      labelCount[key] = val;
    }

    final lastSync = DateTime.parse(reader.readString());
    return MonthMoodSummaryModel(
      year: year,
      month: month,
      days: days,
      labelCount: labelCount,
      lastSync: lastSync,
    );
  }

  @override
  void write(BinaryWriter writer, MonthMoodSummaryModel obj) {
    writer.writeInt(obj.year);
    writer.writeInt(obj.month);

    writer.writeInt(obj.days.length);
    for (var d in obj.days) {
      writer.write(d);
    }

    writer.writeInt(obj.labelCount.length);
    obj.labelCount.forEach((k,v) {
      writer.writeString(k);
      writer.writeInt(v);
    });

    writer.writeString(obj.lastSync.toIso8601String());
  }
}
