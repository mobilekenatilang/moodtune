part of '_themes.dart';

class AppTheme {
  static ThemeData lightTheme() {
    return ThemeData(
      brightness: Brightness.light,
      visualDensity: VisualDensity.compact,
      listTileTheme: const ListTileThemeData(dense: true),
    );
  }
}
