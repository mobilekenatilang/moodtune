part of '_usecases.dart';

@injectable
class QuoteUsecases implements UseCase<Parsed<Map<String, dynamic>>, String> {
  final QuoteRepository _repository;

  QuoteUsecases(this._repository);

  @override
  Future<Either<Failure, Parsed<Map<String, dynamic>>>> execute([
    String? args,
  ]) {
    if (args == null || args.isEmpty) {
      return _repository.get();
    } else {
      return _repository.getCachedQuote();
    }
  }
}
