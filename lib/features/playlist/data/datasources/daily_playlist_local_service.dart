import 'dart:convert';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:moodtune/features/playlist/domain/entities/playlist.dart';
import 'package:moodtune/features/playlist/domain/entities/song.dart';

@injectable
class DailyPlaylistLocalService {
  static const String _keyDailyPlaylist = 'daily_playlist';
  static const String _keyPlaylistDate = 'daily_playlist_date';
  static const String _keyLastJournalContent = 'last_journal_content';
  
  /// Save daily playlist to local storage
  Future<void> saveDailyPlaylist(Playlist playlist) async {
    final prefs = await SharedPreferences.getInstance();
    
    // Convert playlist to JSON
    final playlistJson = {
      'id': playlist.id,
      'name': playlist.name,
      'description': playlist.description,
      'imageUrl': playlist.imageUrl,
      'moodTag': playlist.moodTag,
      'generatedFromMood': playlist.generatedFromMood,
      'createdAt': playlist.createdAt.toIso8601String(),
      'updatedAt': playlist.updatedAt.toIso8601String(),
      'songs': playlist.songs.map((song) => {
        'id': song.id,
        'title': song.title,
        'artist': song.artist,
        'album': song.album,
        'imageUrl': song.imageUrl,
        'genre': song.genre,
        'mood': song.mood,
        'spotifyUrl': song.spotifyUrl,
      }).toList(),
    };
    
    await prefs.setString(_keyDailyPlaylist, jsonEncode(playlistJson));
    await prefs.setString(_keyPlaylistDate, DateTime.now().toIso8601String().split('T')[0]); // YYYY-MM-DD
    
    print('💾 Daily playlist saved locally');
  }
  
  /// Get daily playlist from local storage
  Future<Playlist?> getDailyPlaylist() async {
    final prefs = await SharedPreferences.getInstance();
    
    final playlistString = prefs.getString(_keyDailyPlaylist);
    if (playlistString == null) return null;
    
    try {
      final playlistJson = jsonDecode(playlistString) as Map<String, dynamic>;
      
      final songs = (playlistJson['songs'] as List).map((songJson) => Song(
        id: songJson['id'],
        title: songJson['title'],
        artist: songJson['artist'],
        album: songJson['album'],
        imageUrl: songJson['imageUrl'],
        genre: songJson['genre'],
        mood: songJson['mood'],
        spotifyUrl: songJson['spotifyUrl'],
      )).toList();
      
      return Playlist(
        id: playlistJson['id'],
        name: playlistJson['name'],
        description: playlistJson['description'],
        imageUrl: playlistJson['imageUrl'],
        moodTag: playlistJson['moodTag'],
        songs: songs,
        generatedFromMood: playlistJson['generatedFromMood'],
        createdAt: DateTime.parse(playlistJson['createdAt']),
        updatedAt: DateTime.parse(playlistJson['updatedAt']),
      );
    } catch (e) {
      print('❌ Error parsing saved playlist: $e');
      return null;
    }
  }
  
  /// Check if daily playlist needs to be regenerated (different day)
  Future<bool> shouldRegeneratePlaylist() async {
    final prefs = await SharedPreferences.getInstance();
    
    final savedDate = prefs.getString(_keyPlaylistDate);
    final today = DateTime.now().toIso8601String().split('T')[0]; // YYYY-MM-DD
    
    if (savedDate == null || savedDate != today) {
      print('🔄 Playlist needs regeneration: saved=$savedDate, today=$today');
      return true;
    }
    
    print('✅ Using today\'s playlist: $savedDate');
    return false;
  }
  
  /// Save last journal content
  Future<void> saveLastJournalContent(String content) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyLastJournalContent, content);
    print('💾 Last journal content saved');
  }
  
  /// Get last journal content
  Future<String?> getLastJournalContent() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyLastJournalContent);
  }
  
  /// Clear all saved playlist data (for testing or reset)
  Future<void> clearPlaylistData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyDailyPlaylist);
    await prefs.remove(_keyPlaylistDate);
    await prefs.remove(_keyLastJournalContent);
    print('🗑️ All playlist data cleared');
  }
}
