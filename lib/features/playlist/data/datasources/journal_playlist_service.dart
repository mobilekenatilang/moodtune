import 'package:injectable/injectable.dart';
import 'package:moodtune/features/journal/data/model/journal.dart';
import 'package:moodtune/features/journal/data/datasources/_datasources.dart';
import 'package:moodtune/features/playlist/domain/entities/playlist.dart';
import 'package:moodtune/features/playlist/domain/entities/song.dart';
import 'package:moodtune/features/playlist/data/constants/playlist_constants.dart';
import 'package:moodtune/services/logger_service.dart';
import 'dart:convert';

@injectable
class JournalPlaylistService {
  final JournalLocalDataSource _journalLocalDataSource;
  
  JournalPlaylistService(this._journalLocalDataSource);
  
  /// Get the last journal entry from today and extract playlist if available
  Future<Playlist?> getTodayPlaylistFromJournal() async {
    try {
      print('🎵 Checking today\'s journal for existing playlist...');
      
      // Get today's timestamp range
      final now = DateTime.now();
      final startOfDay = DateTime(now.year, now.month, now.day).millisecondsSinceEpoch;
      final endOfDay = DateTime(now.year, now.month, now.day, 23, 59, 59).millisecondsSinceEpoch;
      
      // Get all journals to filter today's entries
      final result = await _journalLocalDataSource.getAll();
      
      if (result.statusCode != 200) {
        print('❌ Error getting journals: ${result.message}');
        return null;
      }
      
      final allJournals = (result.data['result'] as List<Journal>?) ?? [];
      
      // Filter journals from today
      final todayJournals = allJournals.where((journal) {
        final journalTimestamp = int.tryParse(journal.timestamp) ?? 0;
        LoggerService.i('📝 Journal timestamp: ${journal.timestamp} (parsed: $journalTimestamp)');
        LoggerService.i('📝 Start of day: $startOfDay, End of day: $endOfDay');
        LoggerService.i('📝 Is in today range: ${journalTimestamp >= startOfDay && journalTimestamp <= endOfDay}');
        return journalTimestamp >= startOfDay && journalTimestamp <= endOfDay;
      }).toList();
      
      LoggerService.i('📝 Total journals: ${allJournals.length}, Today\'s journals: ${todayJournals.length}');
      
      if (todayJournals.isEmpty) {
        print('📝 No journals found for today');
        return null;
      }
      
      // Get the latest journal from today
      todayJournals.sort((a, b) => b.timestamp.compareTo(a.timestamp));
      final latestJournal = todayJournals.first;
      
      print('🎵 Found latest journal from today');
      
      // Check if journal has playlist data
      final playlistData = _extractPlaylistFromJournal(latestJournal);
      final songs = playlistData['songs'] as List<Song>;
      final advice = playlistData['advice'] as String?;
      
      if (songs.isNotEmpty) {
        return Playlist(
          id: 'today',
          name: PlaylistConstants.getPlaylistTitle(latestJournal.mood),
          description: PlaylistConstants.getPlaylistDescription(
            latestJournal.mood,
            advice: advice,
          ),
          imageUrl: '',
          moodTag: PlaylistConstants.getPlaylistTag(latestJournal.mood),
          songs: songs,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
          generatedFromMood: latestJournal.mood.value,
        );
      }
      
      return null;
      
    } catch (e) {
      print('❌ Error getting today\'s playlist: $e');
      return null;
    }
  }
  
  /// Extract playlist from journal's playlist field (if exists)
  Map<String, dynamic> _extractPlaylistFromJournal(Journal journal) {
    try {
      final playlist = journal.playlist;
      LoggerService.i('📝 Raw playlist data from journal: $playlist');
      LoggerService.i('📝 Playlist data type: ${playlist.runtimeType}');
      
      if (playlist == null || playlist.isEmpty) {
        LoggerService.i('📝 No playlist data found in journal');
        return {'songs': <Song>[], 'advice': null};
      }

      dynamic playlistData;
      try {
        playlistData = jsonDecode(playlist);
        LoggerService.i('📝 Parsed playlist data type: ${playlistData.runtimeType}');
        LoggerService.i('📝 Parsed playlist data: $playlistData');
      } catch (e) {
        LoggerService.e('❌ Failed to parse playlist JSON: $e');
        return {'songs': <Song>[], 'advice': null};
      }

      // Extract advice from emotion data if available
      String? advice;
      if (playlistData is Map<String, dynamic> && 
          playlistData.containsKey('emotion') && 
          playlistData['emotion'] is Map<String, dynamic>) {
        final emotionData = playlistData['emotion'] as Map<String, dynamic>;
        advice = emotionData['advice']?.toString();
        LoggerService.i('📝 Found advice from emotion data: $advice');
      }

      List<dynamic> musicList;
      
      // Check if the data is directly a List or if it's an object with 'music' key
      if (playlistData is List) {
        LoggerService.i('📝 Playlist data is directly a List');
        musicList = playlistData;
      } else if (playlistData is Map<String, dynamic> && playlistData.containsKey('music')) {
        LoggerService.i('📝 Playlist data is an object with music key');
        musicList = playlistData['music'] as List<dynamic>;
      } else {
        LoggerService.i('📝 Playlist data format not recognized: ${playlistData.runtimeType}');
        return {'songs': <Song>[], 'advice': advice};
      }

      LoggerService.i('📝 Found music list with ${musicList.length} items');
      
      final songs = <Song>[];
      for (int i = 0; i < musicList.length; i++) {
        final music = musicList[i];
        LoggerService.i('📝 Processing music item $i: $music');
        LoggerService.i('📝 Music item type: ${music.runtimeType}');
        
        // Ensure music is a Map
        Map<String, dynamic> musicMap;
        if (music is Map<String, dynamic>) {
          musicMap = music;
        } else if (music is Map) {
          // Convert Map to Map<String, dynamic>
          try {
            musicMap = Map<String, dynamic>.from(music);
          } catch (e) {
            LoggerService.e('❌ Failed to convert music map at index $i: $e');
            continue;
          }
        } else {
          LoggerService.w('⚠️ Music item at index $i is not a Map, type: ${music.runtimeType}, value: $music');
          continue;
        }
        
        try {
          final song = Song.fromJson(musicMap);
          songs.add(song);
          LoggerService.i('✅ Successfully parsed song: ${song.title} by ${song.artist}');
        } catch (e) {
          LoggerService.e('❌ Failed to parse song at index $i: $e');
          LoggerService.e('❌ Music map was: $musicMap');
        }
      }

      LoggerService.i('📝 Successfully extracted ${songs.length} songs from playlist');
      return {'songs': songs, 'advice': advice};
    } catch (e) {
      LoggerService.e('❌ Error extracting playlist from journal: $e');
      LoggerService.e('❌ Stack trace: ${StackTrace.current}');
      return {'songs': <Song>[], 'advice': null};
    }
  }
}
