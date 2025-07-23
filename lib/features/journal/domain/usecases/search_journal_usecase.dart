part of '_usecases.dart';

@injectable
class SearchJournalUsecase
    implements UseCase<Parsed<Map<String, dynamic>>, String> {
  final JournalRepository _repository;

  SearchJournalUsecase(this._repository);

  @override
  Future<Either<Failure, Parsed<Map<String, dynamic>>>> execute([
    String? args,
  ]) async {
    if (args == null || args.isEmpty) {
      return Left(
        ArgumentFailure(message: 'Search input parameter is required'),
      );
    }
    return await _repository.search(args);
  }
}
