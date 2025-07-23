import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'di.config.dart';

final GetIt get = GetIt.I;

@InjectableInit(
  initializerName: 'init',
  preferRelativeImports: true,
  asExtension: true,
)
Future<void> configureDependencies() async {
  await get.init();
  get.registerSingleton<Dio>(
    Dio(BaseOptions(connectTimeout: Duration(seconds: 300))),
  );
}
