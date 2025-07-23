import 'package:either_dart/either.dart';
import 'package:equatable/equatable.dart';
import 'package:moodtune/core/errors/failure.dart';
import 'package:moodtune/core/bases/use_case/use_case.dart';
import 'package:moodtune/features/profile/domain/entities/profile.dart';
import 'package:moodtune/features/profile/domain/repositories/profile_repository.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class UpdateProfile implements UseCase<void, UpdateProfileParams> {
  final ProfileRepository repository;

  UpdateProfile(this.repository);

  @override
  Future<Either<Failure, void>> execute([UpdateProfileParams? params]) async {
    if (params == null) {
      return Left(ArgumentFailure(message: 'UpdateProfileParams cannot be null'));
    }
    
    final result = await repository.updateProfile(params.profile);
    return result.fold(
      (failure) => Left(failure),
      (_) => const Right(null),
    );
  }
}

class UpdateProfileParams extends Equatable {
  final Profile profile;

  const UpdateProfileParams({required this.profile});

  @override
  List<Object?> get props => [profile];
}
