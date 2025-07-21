part of '_repositories.dart';

abstract class JournalRepository {
  Future<Either<Failure, Parsed<Map<String, dynamic>>>> getAll();
  Future<Either<Failure, Parsed<Map<String, dynamic>>>> getByMonth(
    int year,
    int month,
  );
  Future<Either<Failure, Parsed<Map<String, dynamic>>>> getByWeek(DateTime now);
  Future<Either<Failure, Parsed<Map<String, dynamic>>>> search(String input);
  Future<Either<Failure, Parsed<Map<String, dynamic>>>> getByTimestamp(
    String timestamp,
  );
  Future<Either<Failure, Parsed<Map<String, dynamic>>>> create(Journal data);
  Future<Either<Failure, Parsed<Map<String, dynamic>>>> analyze(
    Journal data,
    bool onlyLLM,
  );
  Future<Either<Failure, Parsed<Map<String, dynamic>>>> update(Journal data);
  Future<Either<Failure, Parsed<Map<String, dynamic>>>> delete(
    String timestamp,
  );
}
