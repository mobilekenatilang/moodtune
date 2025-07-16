part of '_repositories.dart';

abstract class QuoteRepository {
  Future<Either<Failure, Parsed<Map<String, dynamic>>>> get();
  Future<Either<Failure, Parsed<Map<String, dynamic>>>> getCachedQuote();
}
