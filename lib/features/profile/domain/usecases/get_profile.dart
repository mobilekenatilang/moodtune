import 'package:either_dart/either.dart';
import 'package:moodtune/core/errors/failure.dart';
import 'package:moodtune/core/bases/use_case/use_case.dart';
import 'package:moodtune/features/profile/domain/entities/profile.dart';
import 'package:moodtune/features/profile/domain/repositories/profile_repository.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class GetProfile implements UseCase<Profile, void> {
  final ProfileRepository repository;

  GetProfile(this.repository);

  @override
  Future<Either<Failure, Profile>> execute([void args]) async {
    final result = await repository.getProfile();
    return result.fold(
      (failure) => Left(failure),
      (profile) => Right(profile),
    );
  }
}
