import 'package:hive/hive.dart';
import 'day_mood_model.dart';
import 'month_mood_summary_model.dart';

class DayMoodModelAdapter extends TypeAdapter<DayMoodModel> {
  @override
  final int typeId = 1;

  @override
  DayMoodModel read(BinaryReader reader) {
    final date = DateTime.parse(reader.readString());
    final label = reader.readString();
    final emoji = reader.readString();
    return DayMoodModel(date: date, label: label, emoji: emoji);
  }

  @override
  void write(BinaryWriter writer, DayMoodModel obj) {
    writer.writeString(obj.date.toIso8601String());
    writer.writeString(obj.label);
    writer.writeString(obj.emoji);
  }
}

class MonthMoodSummaryModelAdapter extends TypeAdapter<MonthMoodSummaryModel> {
  @override
  final int typeId = 2;

  @override
  MonthMoodSummaryModel read(BinaryReader reader) {
    final year = reader.readInt();
    final month = reader.readInt();

    final dayCount = reader.readInt();
    final days = <DayMoodModel>[];
    for (var i = 0; i < dayCount; i++) {
      days.add(reader.read() as DayMoodModel);
    }

    final avgMood = reader.readDouble();

    final labelCountLength = reader.readInt();
    final labelCount = <String, int>{};
    for (var i = 0; i < labelCountLength; i++) {
      final key = reader.readString();
      final value = reader.readInt();
      labelCount[key] = value;
    }

    final lastSync = DateTime.parse(reader.readString());

    return MonthMoodSummaryModel(
      year: year,
      month: month,
      days: days,
      avgMood: avgMood,
      labelCount: labelCount,
      lastSync: lastSync,
    );
  }

  @override
  void write(BinaryWriter writer, MonthMoodSummaryModel obj) {
    writer.writeInt(obj.year);
    writer.writeInt(obj.month);

    writer.writeInt(obj.days.length);
    for (var day in obj.days) {
      writer.write(day);
    }

    writer.writeDouble(obj.avgMood);

    writer.writeInt(obj.labelCount.length);
    obj.labelCount.forEach((key, value) {
      writer.writeString(key);
      writer.writeInt(value);
    });

    writer.writeString(obj.lastSync.toIso8601String());
  }
}
