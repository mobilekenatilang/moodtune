part of 'playlist_cubit.dart';

abstract class PlaylistState {}

class PlaylistInitial extends PlaylistState {}

class PlaylistLoading extends PlaylistState {}

class PlaylistLoaded extends PlaylistState {
  final Playlist playlist;
  final bool isPlaying;
  final int currentSongIndex;
  final bool isShuffled;

  PlaylistLoaded(
    this.playlist, {
    this.isPlaying = false,
    this.currentSongIndex = 0,
    this.isShuffled = false,
  });

  PlaylistLoaded copyWith({
    Playlist? playlist,
    bool? isPlaying,
    int? currentSongIndex,
    bool? isShuffled,
  }) {
    return PlaylistLoaded(
      playlist ?? this.playlist,
      isPlaying: isPlaying ?? this.isPlaying,
      currentSongIndex: currentSongIndex ?? this.currentSongIndex,
      isShuffled: isShuffled ?? this.isShuffled,
    );
  }

  Song get currentSong => playlist.songs[currentSongIndex];
}

class PlaylistError extends PlaylistState {
  final String message;

  PlaylistError(this.message);
}
