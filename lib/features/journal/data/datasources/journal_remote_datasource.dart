part of '_datasources.dart';

abstract class JournalRemoteDataSource {
  Future<Parsed<Map<String, dynamic>>> analyzeJournal(
    Journal journal,
    bool onlyLLM,
  );
}

@Injectable(as: JournalRemoteDataSource)
class JournalRemoteDataSourceImpl implements JournalRemoteDataSource {
  @override
  Future<Parsed<Map<String, dynamic>>> analyzeJournal(
    Journal journal,
    bool onlyLLM,
  ) async {
    if (journal.title.isEmpty || journal.content.isEmpty) {
      return Parsed.fromDynamicData(400, {'error': 'Journal text is required'});
    }

    final text =
        'Perasaanku kali ini bisa digambarkan dengan kalimat '
        '"${journal.title}". "${journal.content}"';

    Map<String, dynamic> data = {'text': text};

    if (!onlyLLM) {
      // TODO: Add favorite music, genre and singer here
    }

    final response = await postIt(
      onlyLLM ? EndPoints.llm : EndPoints.analyze,
      model: data,
    );

    if (response.statusCode != 201) {
      return Parsed.fromDynamicData(response.statusCode ?? 500, {
        'error': 'Failed to analyze journal',
      });
    }

    final result = Analyzed.fromMap(response.data);
    LoggerService.i('Analyzed journal: \n$result');

    return response.parse({'result': result});
  }
}
