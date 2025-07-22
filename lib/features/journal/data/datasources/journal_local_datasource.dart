part of '_datasources.dart';

abstract class JournalLocalDataSource {
  Future<Parsed<Map<String, dynamic>>> getAll();
  Future<Parsed<Map<String, dynamic>>> getByMonth(int year, int month);
  Future<Parsed<Map<String, dynamic>>> getByWeek(DateTime now);
  Future<Parsed<Map<String, dynamic>>> search(String input);
  Future<Parsed<Map<String, dynamic>>> getByTimestamp(String timestamp);
  Future<Parsed<Map<String, dynamic>>> create(Journal data);
  Future<Parsed<Map<String, dynamic>>> update(Journal data);
  Future<Parsed<Map<String, dynamic>>> delete(String timestamp);
}

@Injectable(as: JournalLocalDataSource)
class JournalLocalDataSourceImpl implements JournalLocalDataSource {
  @override
  Future<Parsed<Map<String, dynamic>>> getAll() async {
    List<Journal> journals = [];

    await SqfliteService.getAll('journal').then((data) {
      journals = data.map((e) => Journal.fromMap(e)).toList();
    });

    LoggerService.i(
      'Fetched all journals from local storage: ${journals.length} entries',
    );

    return Parsed.fromDynamicData(200, {'result': journals});
  }

  @override
  Future<Parsed<Map<String, dynamic>>> getByMonth(int year, int month) async {
    final startOfMonth = DateTime(year, month, 1).millisecondsSinceEpoch;
    final endOfMonth = DateTime(year, month + 1, 1).millisecondsSinceEpoch - 1;

    List<Journal> journals = [];

    await SqfliteService.query(
      'journal',
      "CAST(timestamp AS INTEGER) >= $startOfMonth "
          "AND CAST(timestamp AS INTEGER) <= $endOfMonth",
    ).then((data) {
      journals = data.map((e) => Journal.fromMap(e)).toList();
    });

    LoggerService.i(
      'Fetched journals for $year-$month: ${journals.length} entries',
    );

    return Parsed.fromDynamicData(200, {'result': journals});
  }

  @override
  Future<Parsed<Map<String, dynamic>>> getByWeek(DateTime now) async {
    final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
    final endOfWeek = startOfWeek.add(Duration(days: 6));

    List<Journal> journals = [];

    await SqfliteService.query(
      'journal',
      "CAST(timestamp AS INTEGER) >= ${startOfWeek.millisecondsSinceEpoch} "
          "AND CAST(timestamp AS INTEGER) <= ${endOfWeek.millisecondsSinceEpoch} "
          "ORDER BY CAST(timestamp AS INTEGER) DESC",
    ).then((data) {
      journals = data.map((e) => Journal.fromMap(e)).toList();
    });

    LoggerService.i(
      'Fetched journals for week of ${startOfWeek.toIso8601String()}: '
      '${journals.length} entries',
    );

    return Parsed.fromDynamicData(200, {'result': journals});
  }

  @override
  Future<Parsed<Map<String, dynamic>>> search(String input) async {
    if (input.trim().isEmpty) {
      return Parsed.fromDynamicData(200, {'result': []});
    }

    List<Journal> journals = [];

    await SqfliteService.query(
      'journal',
      "title LIKE '%$input%' "
          "OR content LIKE '%$input%' "
          "OR advice LIKE '%$input%'",
    ).then((data) {
      journals = data.map((e) => Journal.fromMap(e)).toList();
    });

    LoggerService.i(
      'Searched journals for "$input": ${journals.length} entries',
    );

    return Parsed.fromDynamicData(200, {'result': journals});
  }

  @override
  Future<Parsed<Map<String, dynamic>>> getByTimestamp(String timestamp) async {
    if (timestamp.isEmpty) {
      return Parsed.fromDynamicData(200, {'result': []});
    }

    List<Journal> journals = [];

    await SqfliteService.query('journal', "timestamp = '$timestamp'").then((
      data,
    ) {
      journals = data.map((e) => Journal.fromMap(e)).toList();
    });

    if (journals.isEmpty) {
      return Parsed.fromDynamicData(404, {'error': 'Journal not found'});
    }

    LoggerService.i('Fetched journal for timestamp $timestamp: $journals');

    return Parsed.fromDynamicData(200, {'result': journals});
  }

  @override
  Future<Parsed<Map<String, dynamic>>> create(Journal data) async {
    if (data.timestamp.isEmpty) {
      data = data.copyWith(
        timestamp: DateTime.now().millisecondsSinceEpoch.toString(),
      );
    }
    if (data.title.isEmpty) {
      data = data.copyWith(title: "Untitled");
    }
    if (data.content.isEmpty) {
      data = data.copyWith(content: "");
    }

    await SqfliteService.insert('journal', data.toMap());

    LoggerService.i('Created journal: ${data.toMap()}');

    return Parsed.fromDynamicData(201, {'result': data.toMap()});
  }

  @override
  Future<Parsed<Map<String, dynamic>>> update(Journal data) async {
    if (data.timestamp.isEmpty) {
      return Parsed.fromDynamicData(400, {
        'error': 'Journal timestamp is required for update',
      });
    }

    await SqfliteService.update(
      'journal',
      data.toMap(),
      "timestamp = '${data.timestamp}'",
    );

    LoggerService.i('Updated journal: ${data.toMap()}');

    return Parsed.fromDynamicData(200, {'result': data.toMap()});
  }

  @override
  Future<Parsed<Map<String, dynamic>>> delete(String timestamp) async {
    if (timestamp.isEmpty) {
      return Parsed.fromDynamicData(400, {'error': 'Timestamp is required'});
    }

    await SqfliteService.delete('journal', "timestamp = '$timestamp'");

    LoggerService.i('Deleted journal with timestamp: $timestamp');

    return Parsed.fromDynamicData(200, {
      'result': 'Journal deleted successfully',
    });
  }
}
