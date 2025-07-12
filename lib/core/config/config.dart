import 'package:envied/envied.dart';
part 'config.g.dart';

@Envied(name: 'Config', path: '.env')
abstract class Config {
  @EnviedField(varName: 'BASE_URL_LOCAL_WEB')
  static const String baseUrlWeb = _Config.baseUrlWeb;

  @EnviedField(varName: 'BASE_URL_LOCAL_HP')
  static const String baseUrlHp = _Config.baseUrlHp;

  @EnviedField(varName: 'BASE_URL_PROD')
  static const String baseUrlProd = _Config.baseUrlProd;
}
