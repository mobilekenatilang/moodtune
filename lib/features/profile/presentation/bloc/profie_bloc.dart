import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:moodtune/features/profile/domain/entities/profile.dart';
import 'package:moodtune/features/profile/domain/usecases/get_profile.dart';
import 'package:moodtune/features/profile/domain/usecases/update_profile.dart';
import 'package:injectable/injectable.dart';

part 'profile_event.dart';
part 'profile_state.dart';

@injectable
class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final GetProfile getProfile;
  final UpdateProfile updateProfile;

  ProfileBloc({required this.getProfile, required this.updateProfile})
    : super(ProfileInitial()) {
    on<FetchProfile>(_onFetchProfile);
    on<UpdateProfileData>(_onUpdateProfileData);
  }

  void _onFetchProfile(FetchProfile event, Emitter<ProfileState> emit) async {
    emit(ProfileLoading());
    try {
      final failureOrProfile = await getProfile.execute();
      failureOrProfile.fold(
        (failure) => emit(const ProfileError('Failed to fetch profile')),
        (profile) => emit(ProfileLoaded(profile)),
      );
    } catch (e) {
      emit(ProfileError('Unexpected error: ${e.toString()}'));
    }
  }

  void _onUpdateProfileData(
    UpdateProfileData event,
    Emitter<ProfileState> emit,
  ) async {
    emit(ProfileLoading());
    final failureOrSuccess = await updateProfile.execute(
      UpdateProfileParams(profile: event.profile),
    );
    failureOrSuccess.fold(
      (failure) => emit(const ProfileError('Failed to update profile')),
      (_) {
        emit(ProfileUpdateSuccess());
        add(FetchProfile()); // Refresh profile data
      },
    );
  }
}
