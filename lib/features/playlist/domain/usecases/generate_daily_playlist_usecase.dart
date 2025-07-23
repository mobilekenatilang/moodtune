import 'package:injectable/injectable.dart';
import '../entities/playlist.dart';
import '../../data/datasources/journal_playlist_service.dart';
import '../../../profile/presentation/bloc/profie_bloc.dart';

@injectable
class GenerateDailyPlaylistUseCase {
  final JournalPlaylistService _journalPlaylistService;

  GenerateDailyPlaylistUseCase(this._journalPlaylistService);

  /// Generate daily playlist from today's journal analysis
  Future<Playlist?> call(ProfileState? profileState) async {
    try {
      print('🎵 Generating daily playlist...');
      
      // First, try to get playlist from today's journal analysis
      final journalPlaylist = await _journalPlaylistService.getTodayPlaylistFromJournal();
      
      if (journalPlaylist != null) {
        print('✅ Successfully retrieved playlist from today\'s journal');
        return journalPlaylist;
      }
      
      print('📝 No journal playlist found for today');
      return null;
      
    } catch (e) {
      print('❌ Error generating daily playlist: $e');
      return null;
    }
  }
}
