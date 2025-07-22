part of '_usecases.dart';

@injectable
class GetJournalByMonthUsecase
    implements UseCase<Parsed<Map<String, dynamic>>, GetJournalByMonthParams> {
  final JournalRepository _repository;

  GetJournalByMonthUsecase(this._repository);

  @override
  Future<Either<Failure, Parsed<Map<String, dynamic>>>> execute([
    GetJournalByMonthParams? args,
  ]) async {
    if (args == null) {
      return Left(
        ArgumentFailure(message: 'Year and month parameters are required'),
      );
    }
    return await _repository.getByMonth(args.year, args.month);
  }
}
