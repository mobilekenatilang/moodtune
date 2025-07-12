part of '_constants.dart';

class Assets {
  static final svg = _SvgAssets();
  static final image = _ImageAssets();
}

class _SvgAssets {
  final String _basePath = 'assets/svgs';

  String get example => '$_basePath/example.svg';
}

class _ImageAssets {
  final String _basePath = 'assets/images';

  String get example => '$_basePath/example.png';
}
