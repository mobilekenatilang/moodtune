part of '_repositories.dart';

@Injectable(as: CalendarRepository)
class CalendarRepositoryImpl implements CalendarRepository {
  final CalendarLocalDataSource _localDataSource;

  CalendarRepositoryImpl(this._localDataSource);

  @override
  Future<Either<Failure, Parsed<Map<String, dynamic>>>> getMonth(int year, int month, {bool forceRefresh = false}) async {
    return apiCall(_localDataSource.getMonth(year, month));
  }

  @override
  Future<Either<Failure, Parsed<Map<String, dynamic>>>> saveDayMood(DailyMoodEntry mood) async {
    return apiCall(_localDataSource.saveDayMood(mood));
  }
}