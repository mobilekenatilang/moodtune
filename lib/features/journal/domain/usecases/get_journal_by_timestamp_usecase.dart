part of '_usecases.dart';

@injectable
class GetJournalByTimestampUsecase
    implements UseCase<Parsed<Map<String, dynamic>>, String> {
  final JournalRepository _repository;

  GetJournalByTimestampUsecase(this._repository);

  @override
  Future<Either<Failure, Parsed<Map<String, dynamic>>>> execute([
    String? args,
  ]) async {
    if (args == null || args.isEmpty) {
      return Left(ArgumentFailure(message: 'Timestamp parameter is required'));
    }
    return await _repository.getByTimestamp(args);
  }
}
