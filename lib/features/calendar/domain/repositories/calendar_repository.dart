part of '_repositories.dart';

abstract class CalendarRepository {
  Future<Either<Failure, Parsed<Map<String, dynamic>>>> getMonth(int year, int month, {bool forceRefresh = false});
  Future<Either<Failure, Parsed<Map<String, dynamic>>>> saveDayMood(DailyMoodEntry mood);
}