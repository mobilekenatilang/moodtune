part of '_repositories.dart';

@Injectable(as: QuoteRepository)
class QuoteRepositoryImpl implements QuoteRepository {
  final QuoteRemoteDataSource _remoteDataSource;
  final QuoteLocalDataSource _localDataSource;

  QuoteRepositoryImpl(this._remoteDataSource, this._localDataSource);

  @override
  Future<Either<Failure, Parsed<Map<String, dynamic>>>> get() {
    return apiCall(_remoteDataSource.get());
  }

  @override
  Future<Either<Failure, Parsed<Map<String, dynamic>>>> getCachedQuote() {
    return apiCall(_localDataSource.get());
  }
}
