import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:moodtune/features/playlist/domain/entities/playlist.dart';
import 'package:moodtune/features/playlist/domain/entities/song.dart';

@injectable
class MoodAnalysisApiService {
  final Dio _dio;
  
  MoodAnalysisApiService(this._dio);
  
  // TODO: Replace with your actual backend URL
  static const String backendUrl = 'https://your-backend-url.vercel.app';
  
  /// Generate daily playlist based on journal content and user preferences
  Future<Playlist> generateDailyPlaylist({
    required String lastJournalContent,
    String? favoriteSinger,
    String? favoriteGenre,
  }) async {
    try {
      print('🎵 Generating playlist from backend...');
      print('Journal content: ${lastJournalContent.substring(0, lastJournalContent.length > 50 ? 50 : lastJournalContent.length)}...');
      
      final response = await _dio.post(
        '$backendUrl/api/analyze',
        data: {
          'text': lastJournalContent,
          if (favoriteSinger != null) 'favouriteArtist': favoriteSinger,
          if (favoriteGenre != null) 'favouriteGenre': favoriteGenre,
        },
      );

      if (response.statusCode == 201) {
        final data = response.data;
        
        // Extract emotion analysis
        final emotion = data['emotion'];
        final musicTracks = data['music'] as List;
        
        // Create playlist name and description from AI analysis
        final String playlistName = "MoodTune Daily: ${emotion['label']}";
        final String playlistDescription = emotion['advice'] ?? 
            'A personalized playlist based on your recent journal entry and current mood.';
        
        // Convert backend music data to Song entities
        final List<Song> songs = musicTracks.map((track) => Song(
          id: track['id']?.toString() ?? DateTime.now().millisecondsSinceEpoch.toString(),
          title: track['title'] ?? 'Unknown Track',
          artist: track['artist'] ?? 'Unknown Artist',
          album: 'Single',
          imageUrl: track['cover'] ?? '',
          genre: favoriteGenre ?? track['genre'] ?? '',
          mood: emotion['label']?.toLowerCase() ?? 'neutral',
          spotifyUrl: track['link']?.toString(), // Pass Spotify URL (using 'link' key)
        )).toList();
        
        print('✅ Generated playlist with ${songs.length} songs');
        print('Emotion detected: ${emotion['label']}');
        
        return Playlist(
          id: 'daily_${DateTime.now().millisecondsSinceEpoch}',
          name: playlistName,
          description: playlistDescription,
          imageUrl: _generatePlaylistCoverUrl(emotion['label']),
          moodTag: _generateMoodTag(emotion['label']),
          songs: songs,
          generatedFromMood: emotion['label']?.toLowerCase() ?? 'neutral',
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );
        
      } else {
        throw Exception('Backend returned status: ${response.statusCode}');
      }
      
    } catch (e) {
      print('❌ Error generating playlist from backend: $e');
      
      // Fallback to mock data when backend is not available
      print('🔄 Using fallback mock data...');
      return _createFallbackPlaylist(lastJournalContent, favoriteSinger, favoriteGenre);
    }
  }
  
  /// Generate playlist cover URL based on mood
  String _generatePlaylistCoverUrl(String? mood) {
    final moodLower = mood?.toLowerCase() ?? 'neutral';
    
    // You can replace these with actual cover image URLs
    final coverMap = {
      'happy': 'https://i.scdn.co/image/ab67616d0000b273happy_cover',
      'sad': 'https://i.scdn.co/image/ab67616d0000b273sad_cover',
      'energetic': 'https://i.scdn.co/image/ab67616d0000b273energetic_cover',
      'calm': 'https://i.scdn.co/image/ab67616d0000b273calm_cover',
      'angry': 'https://i.scdn.co/image/ab67616d0000b273angry_cover',
      'excited': 'https://i.scdn.co/image/ab67616d0000b273excited_cover',
    };
    
    return coverMap[moodLower] ?? 'https://i.scdn.co/image/ab67616d0000b273default_cover';
  }
  
  /// Create fallback playlist when backend is not available
  Playlist _createFallbackPlaylist(String journalContent, String? favoriteSinger, String? favoriteGenre) {
    // Simple keyword-based mood detection for fallback
    final contentLower = journalContent.toLowerCase();
    String detectedMood = 'neutral';
    
    if (contentLower.contains(RegExp(r'\b(happy|joy|excited|great|awesome|amazing|wonderful)\b'))) {
      detectedMood = 'happy';
    } else if (contentLower.contains(RegExp(r'\b(sad|down|depressed|tired|exhausted|stressed)\b'))) {
      detectedMood = 'sad';
    } else if (contentLower.contains(RegExp(r'\b(energetic|pumped|motivated|active|workout)\b'))) {
      detectedMood = 'energetic';
    } else if (contentLower.contains(RegExp(r'\b(calm|peaceful|relaxed|chill|quiet)\b'))) {
      detectedMood = 'calm';
    }
    
    final mockSongs = [
      Song(
        id: '1',
        title: 'Fallback Song 1',
        artist: favoriteSinger ?? 'Various Artists',
        album: 'MoodTune Fallback',
        imageUrl: '',
        genre: favoriteGenre ?? 'Pop',
        mood: detectedMood,
        spotifyUrl: 'https://open.spotify.com/track/fallback1',
      ),
      Song(
        id: '2',
        title: 'Fallback Song 2',
        artist: favoriteSinger ?? 'Various Artists',
        album: 'MoodTune Fallback',
        imageUrl: '',
        genre: favoriteGenre ?? 'Pop',
        mood: detectedMood,
        spotifyUrl: 'https://open.spotify.com/track/fallback2',
      ),
    ];
    
    return Playlist(
      id: 'fallback_${DateTime.now().millisecondsSinceEpoch}',
      name: 'MoodTune Daily: ${detectedMood.toUpperCase()}',
      description: 'A fallback playlist based on your journal content (backend temporarily unavailable)',
      imageUrl: _generatePlaylistCoverUrl(detectedMood),
      moodTag: _generateMoodTag(detectedMood),
      songs: mockSongs,
      generatedFromMood: detectedMood,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
  }

  /// Generate mood tag for playlist
  String _generateMoodTag(String? emotion) {
    switch (emotion?.toLowerCase()) {
      case 'happy':
        return '🌟 HAPPY';
      case 'sad':
        return '💙 HEALING';
      case 'calm':
        return '🕊️ CALM';
      case 'angry':
        return '🔥 CHILL';
      case 'anxious':
        return '🌸 PEACE';
      case 'tired':
        return '⚡ BOOST';
      default:
        return '🎭 MIXED';
    }
  }
}
