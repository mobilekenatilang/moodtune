part of '_datasources.dart';

abstract class QuoteRemoteDataSource {
  Future<Parsed<Map<String, dynamic>>> get();
}

@Injectable(as: QuoteRemoteDataSource)
class QuoteRemoteDataSourceImpl implements QuoteRemoteDataSource {
  @override
  Future<Parsed<Map<String, dynamic>>> get() async {
    final response = await getIt(EndPoints.quote);
    response.data = response.data[0] as Map<String, dynamic>;

    final quote = QuoteModel.fromJson(response.data);

    LoggerService.i('Fetched quote: \n${quote.q} \n- ${quote.a}');

    // if success save to local cache too
    await PrefService.saveString(
      PreferencesKeys.quote,
      jsonEncode(quote.toJson()),
    );

    LoggerService.i(
      jsonDecode(PrefService.getString(PreferencesKeys.quote) ?? '{}'),
    );

    return response.parse({'result': quote});
  }
}
