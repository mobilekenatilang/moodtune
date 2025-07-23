import 'package:dartz/dartz.dart' as dartz;
import 'package:moodtune/core/errors/failure.dart';
import 'package:moodtune/features/profile/data/datasources/profile_local_data_source.dart';
import 'package:moodtune/features/profile/data/model/profile_model.dart';
import 'package:moodtune/features/profile/domain/entities/profile.dart';
import 'package:moodtune/features/profile/domain/repositories/profile_repository.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: ProfileRepository)
class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileLocalDataSource localDataSource;
  // final NetworkInfo networkInfo; // Jika perlu koneksi internet

  ProfileRepositoryImpl({
    required this.localDataSource,
    // required this.networkInfo,
  });

  @override
  Future<dartz.Either<Failure, Profile>> getProfile() async {
    try {
      final localProfile = await localDataSource.getProfile();
      return dartz.Right(localProfile);
    } catch (e) {
      return dartz.Left(CacheFailure(message: 'Failed to get profile: ${e.toString()}'));
    }
  }

  @override
  Future<dartz.Either<Failure, dartz.Unit>> updateProfile(Profile profile) async {
    try {
      final profileModel = ProfileModel(
        name: profile.name,
        email: profile.email,
        username: profile.username,
        profilePicturePath: profile.profilePicturePath,
        favoriteSingers: profile.favoriteSingers,
        favoriteGenres: profile.favoriteGenres,
        isProfileComplete: profile.isProfileComplete,
      );
      await localDataSource.cacheProfile(profileModel);
      return const dartz.Right(dartz.unit);
    } catch (e) {
      return dartz.Left(CacheFailure(message: 'Failed to update profile: ${e.toString()}'));
    }
  }
}
