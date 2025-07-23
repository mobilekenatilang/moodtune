import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:moodtune/features/playlist/domain/entities/song.dart';
import 'package:moodtune/features/playlist/domain/entities/playlist.dart';

@injectable
class MusicApiService {
  final Dio _dio;
  
  MusicApiService(this._dio);
  
  // TODO: Replace with your actual backend endpoint
  static const String baseUrl = 'https://your-backend-api.com/api/v1';
  
  /// Generate playlist based on user mood and preferences
  Future<Playlist> generateMoodPlaylist({
    required String userId,
    required String mood, // happy, sad, energetic, calm, etc.
    required List<String> favoriteGenres,
    required List<String> favoriteSingers,
    int limit = 20,
  }) async {
    try {
      final response = await _dio.post(
        '$baseUrl/playlists/generate',
        data: {
          'user_id': userId,
          'mood': mood,
          'favorite_genres': favoriteGenres,
          'favorite_singers': favoriteSingers,
          'limit': limit,
        },
      );
      
      return PlaylistJson.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to generate playlist: $e');
    }
  }
  
  /// Search songs with mood and genre filters
  Future<List<Song>> searchSongs({
    required String query,
    String? mood,
    List<String>? genres,
    int limit = 50,
  }) async {
    try {
      final response = await _dio.get(
        '$baseUrl/songs/search',
        queryParameters: {
          'q': query,
          if (mood != null) 'mood': mood,
          if (genres != null) 'genres': genres.join(','),
          'limit': limit,
        },
      );
      
      return (response.data['songs'] as List)
          .map((json) => SongJson.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception('Failed to search songs: $e');
    }
  }
  
  /// Get song recommendations based on seed data
  Future<List<Song>> getRecommendations({
    required String mood,
    List<String>? seedArtists,
    List<String>? seedGenres,
    List<String>? seedTracks,
    int limit = 20,
  }) async {
    try {
      final response = await _dio.post(
        '$baseUrl/recommendations',
        data: {
          'mood': mood,
          if (seedArtists != null) 'seed_artists': seedArtists,
          if (seedGenres != null) 'seed_genres': seedGenres,
          if (seedTracks != null) 'seed_tracks': seedTracks,
          'limit': limit,
        },
      );
      
      return (response.data['tracks'] as List)
          .map((json) => SongJson.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception('Failed to get recommendations: $e');
    }
  }
  
  /// Get user's mood-based playlists
  Future<List<Playlist>> getUserPlaylists(String userId) async {
    try {
      final response = await _dio.get('$baseUrl/users/$userId/playlists');
      
      return (response.data['playlists'] as List)
          .map((json) => PlaylistJson.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception('Failed to get user playlists: $e');
    }
  }
}

// Extension methods for JSON serialization
extension SongJson on Song {
  static Song fromJson(Map<String, dynamic> json) {
    return Song(
      id: json['id'],
      title: json['title'],
      artist: json['artist'],
      album: json['album'] ?? '',
      imageUrl: json['image_url'] ?? '',
      genre: json['genre'] ?? '',
      mood: json['mood'] ?? '',
      spotifyUrl: json['spotify_url'],
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'artist': artist,
      'album': album,
      'image_url': imageUrl,
      'genre': genre,
      'mood': mood,
      'spotify_url': spotifyUrl,
    };
  }
}

extension PlaylistJson on Playlist {
  static Playlist fromJson(Map<String, dynamic> json) {
    return Playlist(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      imageUrl: json['image_url'] ?? '',
      moodTag: json['mood_tag'],
      songs: (json['songs'] as List)
          .map((songJson) => SongJson.fromJson(songJson))
          .toList(),
      generatedFromMood: json['generated_from_mood'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'image_url': imageUrl,
      'mood_tag': moodTag,
      'songs': songs.map((song) => song.toJson()).toList(),
      'generated_from_mood': generatedFromMood,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}
