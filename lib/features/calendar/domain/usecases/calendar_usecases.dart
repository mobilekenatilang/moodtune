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
      // Default (bulan ini)
      final now = DateTime.now();
      return _repository.getMonth(now.year, now.month);

    } else if (args is Map<String, dynamic>) {
      // Mood di bulan tertentu
      if (args.containsKey('year') && args.containsKey('month')) {
        // Ambil mood bulan tertentu
        return _repository.getMonth(
          args['year'] as int,
          args['month'] as int,
        );
      }

    } else if (args.containsKey('save')){
      // Simpan mood
      return _repository.saveDayMood(args['save'] as DayMoodModel);
    }

    throw Exception('Invalid arguments for CalendarUsecases');
  }
}
