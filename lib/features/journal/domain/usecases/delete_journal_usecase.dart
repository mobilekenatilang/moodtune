part of '_usecases.dart';

@injectable
class DeleteJournalUsecase
    implements UseCase<Parsed<Map<String, dynamic>>, String> {
  final JournalRepository _repository;

  DeleteJournalUsecase(this._repository);

  @override
  Future<Either<Failure, Parsed<Map<String, dynamic>>>> execute([
    String? args,
  ]) async {
    if (args == null || args.isEmpty) {
      return Left(
        ArgumentFailure(
          message: 'Timestamp parameter is required for deletion',
        ),
      );
    }
    return await _repository.delete(args);
  }
}
