import 'package:equatable/equatable.dart';

class Profile extends Equatable {
  final String name;
  final String email;
  final String username;
  final String? profilePicturePath;
  final List<String> favoriteSingers;
  final List<String> favoriteGenres;
  final bool isProfileComplete;

  const Profile({
    required this.name,
    required this.email,
    required this.username,
    this.profilePicturePath,
    required this.favoriteSingers,
    required this.favoriteGenres,
    this.isProfileComplete = false,
  });

  Profile copyWith({
    String? name,
    String? email,
    String? username,
    String? profilePicturePath,
    List<String>? favoriteSingers,
    List<String>? favoriteGenres,
    bool? isProfileComplete,
  }) {
    return Profile(
      name: name ?? this.name,
      email: email ?? this.email,
      username: username ?? this.username,
      profilePicturePath: profilePicturePath ?? this.profilePicturePath,
      favoriteSingers: favoriteSingers ?? this.favoriteSingers,
      favoriteGenres: favoriteGenres ?? this.favoriteGenres,
      isProfileComplete: isProfileComplete ?? this.isProfileComplete,
    );
  }

  @override
  List<Object?> get props => [
        name,
        email,
        username,
        profilePicturePath,
        favoriteSingers,
        favoriteGenres,
        isProfileComplete,
      ];
}
