import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'di.config.dart';

final GetIt get = GetIt.I;

@module
abstract class DioModule {
  @lazySingleton
  Dio get dio => Dio(BaseOptions(connectTimeout: Duration(seconds: 300)));
}

@InjectableInit(
  initializerName: 'init',
  preferRelativeImports: true,
  asExtension: true,
)
Future<void> configureDependencies() async {
  try {
    // Initialize injectable dependencies
  await get.init();
  get.registerSingleton<Dio>(
    Dio(BaseOptions(connectTimeout: Duration(seconds: 300))),
  );
    
    print('✅ Dependencies configured successfully');
  } catch (e) {
    print('❌ Error configuring dependencies: $e');
    rethrow;
  }
}
