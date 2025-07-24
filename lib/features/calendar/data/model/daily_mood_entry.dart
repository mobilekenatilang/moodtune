import 'package:freezed_annotation/freezed_annotation.dart';
part 'daily_mood_entry.freezed.dart';
part 'daily_mood_entry.g.dart';

@freezed
abstract class DailyMoodEntry with _$DailyMoodEntry {
  const factory DailyMoodEntry({
    required DateTime timestamp,
    required String label,
    required String emoji,
  }) = _DailyMoodEntry;

  factory DailyMoodEntry.fromJson(Map<String, dynamic> json) =>
      _$DailyMoodEntryFromJson(json);
}
