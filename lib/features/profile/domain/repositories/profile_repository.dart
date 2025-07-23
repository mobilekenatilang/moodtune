import 'package:dartz/dartz.dart';
import 'package:moodtune/core/errors/failure.dart';
import 'package:moodtune/features/profile/domain/entities/profile.dart';

abstract class ProfileRepository {
  Future<Either<Failure, Profile>> getProfile();
  Future<Either<Failure, Unit>> updateProfile(Profile profile);
}
