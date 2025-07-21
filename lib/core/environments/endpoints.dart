part of '_environments.dart';

class EndPoints {
  // NOTE: Update the base URL according to your environment
  static const String baseUrl = Config.baseUrlHp;

  static const String example = '$baseUrl/example';
  static const String analyze = '$baseUrl/api/analyze';
  static const String llm = '$baseUrl/api/llm';
  static const String musicSearch = '$baseUrl/api/music/search';
  static const String dummyData = '$baseUrl/api/dummy';

  // Khusus Quote API
  static const String quote = 'https://zenquotes.io/api/today';
}
