import 'package:freezed_annotation/freezed_annotation.dart';

part 'day_mood_model.freezed.dart';
part 'day_mood_model.g.dart';

@freezed
abstract class DayMoodModel with _$DayMoodModel {
  const factory DayMoodModel({
    required DateTime date,
    required String label, 
    required String emoji, 
  }) = _DayMoodModel;

  factory DayMoodModel.fromJson(Map<String, dynamic> json) =>
      _$DayMoodModelFromJson(json);
}
