part of '_datasources.dart';

abstract class QuoteLocalDataSource {
  Future<Parsed<Map<String, dynamic>>> get();
}

@Injectable(as: QuoteLocalDataSource)
class QuoteLocalDataSourceImpl implements QuoteLocalDataSource {
  @override
  Future<Parsed<Map<String, dynamic>>> get() async {
    final saved = PrefService.getString(PreferencesKeys.quote);

    if (saved == '{}' || saved == null) {
      throw Exception('No quote found in local storage');
    } else {
      final quoteJson = Map<String, dynamic>.from(
        jsonDecode(saved) as Map<String, dynamic>,
      );

      final quote = QuoteModel.fromJson(quoteJson);

      LoggerService.i(
        'Fetched quote from local storage: \n${quote.q} \n- ${quote.a}',
      );

      return Parsed.fromDynamicData(
        200, // 200 buat tanda success
        {'result': quote},
      );
    }
  }
}
