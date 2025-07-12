import 'package:moodtune/core/errors/failure.dart';
import 'package:either_dart/either.dart';
import 'package:logger/logger.dart';

T? cast<T>(dynamic x) => x is T ? x : null;

/// Function for mapping api call into either success or failure.
Future<Either<Failure, T>> apiCall<T>(Future<T> t) async {
  try {
    final futureCall = await t;
    return Right(futureCall);
  } catch (e) {
    // Nanti kalo gw udah ngerti cara ngambil datanya maybe ini bisa
    // diubah jadi lebih spesifik per errornya
    Logger().f(e.runtimeType);
    Logger().f(e.toString());
    Logger().e(e);
    return Left(GeneralFailure(message: e.toString()));
  }
}
