part of '_usecases.dart';

@injectable
class GetAllJournalUsecase
    implements UseCase<Parsed<Map<String, dynamic>>, String> {
  final JournalRepository _repository;

  GetAllJournalUsecase(this._repository);

  @override
  Future<Either<Failure, Parsed<Map<String, dynamic>>>> execute([
    String? args,
  ]) async {
    return await _repository.getAll();
  }
}
