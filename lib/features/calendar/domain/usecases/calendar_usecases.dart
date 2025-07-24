part of '_usecases.dart';

@injectable
class CalendarUsecases
    implements UseCase<Parsed<Map<String, dynamic>>, dynamic> {
  final CalendarRepository _repository;

  CalendarUsecases(this._repository);

  @override
  Future<Either<Failure, Parsed<Map<String, dynamic>>>> execute([
    dynamic args,
  ]) {
    if (args == null) {
      final now = DateTime.now();
      return _repository.getMonth(now.year, now.month);
    }

    if (args is Map<String, dynamic>) {
      // 1) Simpan mood
      if (args.containsKey('save')) {
        return _repository.saveDayMood(args['save'] as DailyMoodEntry);
      }
      
      // 2) Load bulan tertentu
      if (args.containsKey('year') && args.containsKey('month')) {
        return _repository.getMonth(args['year'] as int, args['month'] as int);
      }
    }

    throw Exception('Invalid arguments for CalendarUsecases');
  }

}
