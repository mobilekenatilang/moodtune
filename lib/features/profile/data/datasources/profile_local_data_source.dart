import 'dart:convert';
import 'package:moodtune/features/profile/data/model/profile_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:injectable/injectable.dart';

const cachedProfile = 'CACHED_PROFILE';

abstract class ProfileLocalDataSource {
  Future<ProfileModel> getProfile();
  Future<void> cacheProfile(ProfileModel profileToCache);
}

@LazySingleton(as: ProfileLocalDataSource)
class ProfileLocalDataSourceImpl implements ProfileLocalDataSource {
  final SharedPreferences sharedPreferences;

  ProfileLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<ProfileModel> getProfile() {
    final jsonString = sharedPreferences.getString(cachedProfile);
    if (jsonString != null) {
      return Future.value(ProfileModel.fromJson(json.decode(jsonString)));
    } else {
      // Return empty profile if none is cached
      return Future.value(ProfileModel.empty());
    }
  }

  @override
  Future<void> cacheProfile(ProfileModel profileToCache) {
    return sharedPreferences.setString(
      cachedProfile,
      json.encode(profileToCache.toJson()),
    );
  }
}
