import 'package:freezed_annotation/freezed_annotation.dart';
import 'daily_mood_entry.dart';
part 'day_summary_model.freezed.dart';
part 'day_summary_model.g.dart';

@freezed
abstract class DaySummaryModel with _$DaySummaryModel {
  const factory DaySummaryModel({
    required DateTime date,
    required List<DailyMoodEntry> entries,
  }) = _DaySummaryModel;

  factory DaySummaryModel.fromJson(Map<String, dynamic> json) =>
      _$DaySummaryModelFromJson(json);
}
