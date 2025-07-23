import 'package:injectable/injectable.dart';
import 'package:moodtune/features/playlist/data/datasources/mood_analysis_api_service.dart';
import 'package:moodtune/features/playlist/data/datasources/daily_playlist_local_service.dart';
import 'package:moodtune/features/playlist/domain/entities/playlist.dart';
import 'package:moodtune/features/profile/domain/entities/profile.dart';

@injectable
class GenerateDailyPlaylistUseCase {
  final MoodAnalysisApiService _moodAnalysisApiService;
  final DailyPlaylistLocalService _localService;
  
  GenerateDailyPlaylistUseCase(
    this._moodAnalysisApiService, 
    this._localService,
  );
  
  /// Get or generate daily playlist based on journal and user profile
  Future<Playlist> execute({
    required Profile userProfile,
    String? forceJournalContent, // For testing or manual regeneration
  }) async {
    try {
      // Check if we need to regenerate playlist (new day)
      final shouldRegenerate = await _localService.shouldRegeneratePlaylist();
      
      if (!shouldRegenerate && forceJournalContent == null) {
        // Use existing playlist from today
        final existingPlaylist = await _localService.getDailyPlaylist();
        if (existingPlaylist != null) {
          print('📱 Using existing daily playlist: ${existingPlaylist.name}');
          return existingPlaylist;
        }
      }
      
      // Get last journal content
      final journalContent = forceJournalContent ?? 
          await _localService.getLastJournalContent() ??
          'Today I feel neutral and calm. Looking forward to good music.'; // Default content
      
      print('📝 Generating playlist from journal content');
      
      // Generate new playlist from backend
      final playlist = await _moodAnalysisApiService.generateDailyPlaylist(
        lastJournalContent: journalContent,
        favoriteSinger: userProfile.favoriteSingers.isNotEmpty 
            ? userProfile.favoriteSingers.first 
            : null,
        favoriteGenre: userProfile.favoriteGenres.isNotEmpty 
            ? userProfile.favoriteGenres.first 
            : null,
      );
      
      // Save to local storage
      await _localService.saveDailyPlaylist(playlist);
      
      return playlist;
      
    } catch (e) {
      throw Exception('Failed to generate daily playlist: $e');
    }
  }
  
  /// Regenerate playlist when new journal is saved
  Future<Playlist> regenerateFromNewJournal({
    required String journalContent,
    required Profile userProfile,
  }) async {
    try {
      print('🔄 Regenerating playlist from new journal entry');
      
      // Save the new journal content
      await _localService.saveLastJournalContent(journalContent);
      
      // Generate new playlist using the new journal content
      return await execute(
        userProfile: userProfile,
        forceJournalContent: journalContent,
      );
      
    } catch (e) {
      throw Exception('Failed to regenerate playlist from journal: $e');
    }
  }
  
  /// Clear playlist data (for testing or reset)
  Future<void> clearPlaylistData() async {
    await _localService.clearPlaylistData();
  }
}
