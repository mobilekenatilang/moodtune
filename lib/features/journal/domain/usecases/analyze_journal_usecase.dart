part of '_usecases.dart';

@injectable
class AnalyzeJournalUsecase
    implements UseCase<Parsed<Map<String, dynamic>>, Journal> {
  final JournalRepository _repository;

  AnalyzeJournalUsecase(this._repository);

  @override
  Future<Either<Failure, Parsed<Map<String, dynamic>>>> execute([
    Journal? args,
    bool onlyLLM = false,
  ]) async {
    if (args == null) {
      return Left(ArgumentFailure(message: 'Journal data is required'));
    }
    return await _repository.analyze(args, onlyLLM);
  }
}
