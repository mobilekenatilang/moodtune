part of '_usecases.dart';

@injectable
class UpdateJournalUsecase
    implements UseCase<Parsed<Map<String, dynamic>>, Journal> {
  final JournalRepository _repository;

  UpdateJournalUsecase(this._repository);

  @override
  Future<Either<Failure, Parsed<Map<String, dynamic>>>> execute([
    Journal? args,
  ]) async {
    if (args == null) {
      return Left(ArgumentFailure(message: 'Journal data is required'));
    }

    if (args.title.trim().isEmpty) {
      return Left(ArgumentFailure(message: 'Journal title cannot be empty'));
    }

    if (args.content.trim().isEmpty) {
      return Left(ArgumentFailure(message: 'Journal content cannot be empty'));
    }

    if (args.timestamp.isEmpty) {
      return Left(
        ArgumentFailure(message: 'Journal timestamp is required for update'),
      );
    }

    return await _repository.update(args);
  }
}
