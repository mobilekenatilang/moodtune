part of '_constants.dart';

class Assets {
  static final svg = _SvgAssets();
  static final image = _ImageAssets();
}

class _SvgAssets {
  final String _basePath = 'assets/svgs';

  String get example => '$_basePath/example.svg';
  String get xCircle => '$_basePath/x-fill.svg';
  String get checkCircle => '$_basePath/check-fill.svg';
}

class _ImageAssets {
  final String _basePath = 'assets/images';

  String get example => '$_basePath/example.png';
  String get sunnyIcon => '$_basePath/sunny-icon.png';
  String get sunriseIcon => '$_basePath/sunrise-icon.png';
  String get moonIcon => '$_basePath/moon-icon.png';
}
