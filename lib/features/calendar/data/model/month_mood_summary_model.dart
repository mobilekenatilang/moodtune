import 'package:freezed_annotation/freezed_annotation.dart';
import 'day_summary_model.dart';
part 'month_mood_summary_model.freezed.dart';
part 'month_mood_summary_model.g.dart';

@freezed
abstract class MonthMoodSummaryModel with _$MonthMoodSummaryModel {
  const factory MonthMoodSummaryModel({
    required int year,
    required int month,
    required List<DaySummaryModel> days,
    required Map<String, int> labelCount,
    required DateTime lastSync,
  }) = _MonthMoodSummaryModel;

  factory MonthMoodSummaryModel.fromJson(Map<String, dynamic> json) =>
      _$MonthMoodSummaryModelFromJson(json);
}
