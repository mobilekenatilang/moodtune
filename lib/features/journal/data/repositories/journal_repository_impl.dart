part of '_repositories.dart';

@Injectable(as: JournalRepository)
class JournalRepositoryImpl implements JournalRepository {
  final JournalLocalDataSource _localDataSource;
  final JournalRemoteDataSource _remoteDataSource;

  JournalRepositoryImpl(this._localDataSource, this._remoteDataSource);

  @override
  Future<Either<Failure, Parsed<Map<String, dynamic>>>> getAll() {
    return apiCall(_localDataSource.getAll());
  }

  @override
  Future<Either<Failure, Parsed<Map<String, dynamic>>>> getByMonth(
    int year,
    int month,
  ) {
    return apiCall(_localDataSource.getByMonth(year, month));
  }

  @override
  Future<Either<Failure, Parsed<Map<String, dynamic>>>> getByWeek(
    DateTime now,
  ) {
    return apiCall(_localDataSource.getByWeek(now));
  }

  @override
  Future<Either<Failure, Parsed<Map<String, dynamic>>>> search(String input) {
    return apiCall(_localDataSource.search(input));
  }

  @override
  Future<Either<Failure, Parsed<Map<String, dynamic>>>> getByTimestamp(
    String timestamp,
  ) {
    return apiCall(_localDataSource.getByTimestamp(timestamp));
  }

  @override
  Future<Either<Failure, Parsed<Map<String, dynamic>>>> create(Journal data) {
    return apiCall(_localDataSource.create(data));
  }

  @override
  Future<Either<Failure, Parsed<Map<String, dynamic>>>> analyze(
    Journal journal,
    bool onlyLLM,
  ) {
    return apiCall(_remoteDataSource.analyzeJournal(journal, onlyLLM));
  }

  @override
  Future<Either<Failure, Parsed<Map<String, dynamic>>>> update(Journal data) {
    return apiCall(_localDataSource.update(data));
  }

  @override
  Future<Either<Failure, Parsed<Map<String, dynamic>>>> delete(
    String timestamp,
  ) {
    return apiCall(_localDataSource.delete(timestamp));
  }
}
