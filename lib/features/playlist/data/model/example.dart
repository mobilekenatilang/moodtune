// User model specified only for Forum feature

import 'package:moodtune/core/environments/_environments.dart';

class UserModel {
  int id;
  String username;
  String firstName;
  String lastName;
  String email;
  String profilePicture;

  UserModel({
    required this.id,
    required this.username,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.profilePicture,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
    id: json["id"],
    username: json["username"],
    firstName: json["first_name"],
    lastName: json["last_name"],
    email: json["email"],
    profilePicture:
        json["userprofile"]?["profile_picture"] ??
        '${EndPoints.baseUrl}/static/images/default_pp.png',
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "username": username,
    "first_name": firstName,
    "last_name": lastName,
    "email": email,
    "userprofile": {"profile_picture": profilePicture},
  };

  @override
  String toString() {
    return 'UserModel $id \n'
        'username: $username \n'
        'first name: $firstName \n'
        'last name: $lastName \n'
        'email: $email \n'
        'profile picture: $profilePicture';
  }
}
