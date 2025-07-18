import 'package:injectable/injectable.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:moodtune/features/calendar/data/model/month_mood_summary_model.dart';

@module
abstract class CalendarModule {
  @preResolve
  Future<Box<MonthMoodSummaryModel>> provideCalendarBox() async {
    return await Hive.openBox<MonthMoodSummaryModel>('calendar_mood');
  }
}
