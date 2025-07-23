import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:moodtune/features/playlist/domain/entities/playlist.dart';
import 'package:moodtune/features/playlist/domain/entities/song.dart';
import 'package:moodtune/features/playlist/domain/usecases/generate_daily_playlist_usecase.dart';
import 'package:moodtune/features/profile/domain/entities/profile.dart';
import 'package:moodtune/features/profile/presentation/bloc/profie_bloc.dart';
import 'package:moodtune/services/dependencies/di.dart';

part 'playlist_state.dart';

@injectable
class PlaylistCubit extends Cubit<PlaylistState> {
  final GenerateDailyPlaylistUseCase _generateDailyPlaylistUseCase;
  
  PlaylistCubit(this._generateDailyPlaylistUseCase) : super(PlaylistInitial());

  /// Load daily playlist (checks local storage first, then generates if needed)
  void loadDailyPlaylist() async {
    print('🎵 PlaylistCubit - loadDailyPlaylist() called');
    emit(PlaylistLoading());
    
    try {
      // Get user profile for playlist generation
      final profileBloc = get<ProfileBloc>();
      Profile userProfile = const Profile(
        name: 'User',
        email: 'user@example.com',
        username: 'user',
        favoriteSingers: [],
        favoriteGenres: [],
        isProfileComplete: false,
      ); // Default profile
      
      // Try to get current profile from ProfileBloc
      if (profileBloc.state is ProfileLoaded) {
        userProfile = (profileBloc.state as ProfileLoaded).profile;
        print('🎵 PlaylistCubit - Using loaded profile: ${userProfile.name}');
      } else {
        print('🎵 PlaylistCubit - Using default profile (ProfileBloc state: ${profileBloc.state.runtimeType})');
      }
      
      print('🎵 Loading daily playlist...');
      
      final playlist = await _generateDailyPlaylistUseCase.call(
        profileBloc.state,
      );
      
      if (playlist != null) {
        print('🎵 PlaylistCubit - Playlist loaded: ${playlist.name} with ${playlist.songs.length} songs');
        emit(PlaylistLoaded(playlist));
      } else {
        print('🎵 PlaylistCubit - No playlist found, falling back to mock data');
        final mockPlaylist = _generateMockPlaylist();
        emit(PlaylistLoaded(mockPlaylist));
      }
      
    } catch (e) {
      print('❌ Error loading daily playlist: $e');
      
      // Fallback to mock data if everything fails
      try {
        print('🎵 PlaylistCubit - Falling back to mock data');
        final mockPlaylist = _generateMockPlaylist();
        emit(PlaylistLoaded(mockPlaylist));
      } catch (mockError) {
        print('❌ Error generating mock playlist: $mockError');
        emit(PlaylistError('Failed to load playlist: $e'));
      }
    }
  }
  
  /// Regenerate playlist from new journal entry
  void regenerateFromJournal(String journalContent) async {
    emit(PlaylistLoading());
    
    try {
      // Get user profile
      final profileBloc = get<ProfileBloc>();
      
      print('🔄 Regenerating playlist from new journal entry');
      
      final playlist = await _generateDailyPlaylistUseCase.call(
        profileBloc.state,
      );
      
      if (playlist != null) {
        emit(PlaylistLoaded(playlist));
      } else {
        // Fallback to mock data
        final mockPlaylist = _generateMockPlaylist();
        emit(PlaylistLoaded(mockPlaylist));
      }
      
    } catch (e) {
      print('❌ Error regenerating playlist: $e');
      emit(PlaylistError('Failed to regenerate playlist: $e'));
    }
  }

  /// Load playlist with mock data (fallback for demo)
  void loadPlaylist(String playlistId) async {
    // For backward compatibility, redirect to daily playlist
    loadDailyPlaylist();
  }

  /// Play/Pause toggle for UI interactions
  void playPause() {
    if (state is PlaylistLoaded) {
      final currentState = state as PlaylistLoaded;
      // For demo purposes, just emit same state
      // In real app, this would control audio playback
      emit(PlaylistLoaded(currentState.playlist));
    }
  }

  /// Select a specific song by index
  void selectSong(int index) {
    if (state is PlaylistLoaded) {
      final currentState = state as PlaylistLoaded;
      
      // Update current song index to the selected song
      emit(currentState.copyWith(
        currentSongIndex: index,
        isPlaying: false, // Stop current playback when changing songs
      ));
      
      print('🎵 Selected song at index $index: ${currentState.playlist.songs[index].title}');
    }
  }

  /// Toggle shuffle mode
  void shufflePlaylist() {
    if (state is PlaylistLoaded) {
      final currentState = state as PlaylistLoaded;
      // For demo purposes, just emit same state
      // In real app, this would shuffle the playlist order
      emit(PlaylistLoaded(currentState.playlist));
    }
  }

  /// Generate mock playlist for fallback/demo purposes
  Playlist _generateMockPlaylist() {
    final mockSongs = [
      Song(
        id: '1',
        title: 'Sunny Day Vibes',
        artist: 'Good Mood Band',
        album: 'Happy Times',
        imageUrl: 'https://via.placeholder.com/300x300/FFD700/000000?text=Sunny',
        genre: 'Pop',
        mood: 'happy',
        spotifyUrl: 'https://open.spotify.com/track/example1',
      ),
      Song(
        id: '2',
        title: 'Chill Evening',
        artist: 'Relaxed Artists',
        album: 'Evening Moods',
        imageUrl: 'https://via.placeholder.com/300x300/87CEEB/000000?text=Chill',
        genre: 'Indie',
        mood: 'calm',
        spotifyUrl: 'https://open.spotify.com/track/example2',
      ),
      Song(
        id: '3',
        title: 'Energy Boost',
        artist: 'Motivational Music',
        album: 'Power Up',
        imageUrl: 'https://via.placeholder.com/300x300/FF6347/FFFFFF?text=Energy',
        genre: 'Electronic',
        mood: 'energetic',
        spotifyUrl: 'https://open.spotify.com/track/example3',
      ),
      Song(
        id: '4',
        title: 'Peaceful Mind',
        artist: 'Calm Collective',
        album: 'Serenity',
        imageUrl: 'https://via.placeholder.com/300x300/98FB98/000000?text=Peace',
        genre: 'Ambient',
        mood: 'peaceful',
        spotifyUrl: 'https://open.spotify.com/track/example4',
      ),
      Song(
        id: '5',
        title: 'Nostalgic Memories',
        artist: 'Memory Lane',
        album: 'Yesterday',
        imageUrl: 'https://via.placeholder.com/300x300/DDA0DD/000000?text=Memory',
        genre: 'Folk',
        mood: 'nostalgic',
        spotifyUrl: 'https://open.spotify.com/track/example5',
      ),
    ];

    final now = DateTime.now();
    return Playlist(
      id: 'daily-${now.millisecondsSinceEpoch}',
      name: '🎵 Today\'s Mood Mix',
      description: 'Your personalized daily playlist based on your current mood',
      imageUrl: 'https://via.placeholder.com/400x400/FFD700/000000?text=Daily+Mix',
      moodTag: '🎭 MIXED',
      songs: mockSongs,
      generatedFromMood: 'mixed',
      createdAt: now,
      updatedAt: now,
    );
  }
}
