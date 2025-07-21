part of '_usecases.dart';

@injectable
class GetJournalByWeekUsecase
    implements UseCase<Parsed<Map<String, dynamic>>, DateTime> {
  final JournalRepository _repository;

  GetJournalByWeekUsecase(this._repository);

  @override
  Future<Either<Failure, Parsed<Map<String, dynamic>>>> execute([
    DateTime? args,
  ]) async {
    if (args == null) {
      return Left(ArgumentFailure(message: 'Date parameter is required'));
    }
    return await _repository.getByWeek(args);
  }
}
