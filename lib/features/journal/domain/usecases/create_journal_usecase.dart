part of '_usecases.dart';

@injectable
class CreateJournalUsecase
    implements UseCase<Parsed<Map<String, dynamic>>, Journal> {
  final JournalRepository _repository;

  CreateJournalUsecase(this._repository);

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

    return await _repository.create(args);
  }
}
