part of 'profie_bloc.dart';

abstract class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object> get props => [];
}

class FetchProfile extends ProfileEvent {}

class UpdateProfileData extends ProfileEvent {
  final Profile profile;

  const UpdateProfileData(this.profile);

  @override
  List<Object> get props => [profile];
}
