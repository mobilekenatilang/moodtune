import 'package:moodtune/features/profile/domain/entities/profile.dart';

class ProfileModel extends Profile {
  const ProfileModel({
    required super.name,
    required super.email,
    required super.username,
    super.profilePicturePath,
    required super.favoriteSingers,
    required super.favoriteGenres,
    super.isProfileComplete,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      username: json['username'] ?? '',
      profilePicturePath: json['profilePicturePath'],
      favoriteSingers: List<String>.from(json['favoriteSingers'] ?? []),
      favoriteGenres: List<String>.from(json['favoriteGenres'] ?? []),
      isProfileComplete: json['isProfileComplete'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'username': username,
      'profilePicturePath': profilePicturePath,
      'favoriteSingers': favoriteSingers,
      'favoriteGenres': favoriteGenres,
      'isProfileComplete': isProfileComplete,
    };
  }

  factory ProfileModel.empty() {
    return const ProfileModel(
      name: '',
      email: '',
      username: '',
      profilePicturePath: null,
      favoriteSingers: [],
      favoriteGenres: [],
      isProfileComplete: false,
    );
  }
}
