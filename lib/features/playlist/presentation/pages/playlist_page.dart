part of '_pages.dart';

class PlaylistPage extends StatefulWidget {
  final String playlistId;
  
  const PlaylistPage({
    super.key,
    required this.playlistId,
  });

  @override
  State<PlaylistPage> createState() => _PlaylistPageState();
}

class _PlaylistPageState extends State<PlaylistPage> {
  late PlaylistCubit _cubit;
  late ScrollController _scrollController;
  
  @override
  void initState() {
    super.initState();
    _cubit = get<PlaylistCubit>();
    _scrollController = ScrollController();
    _cubit.loadDailyPlaylist();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  /// Get emoji that represents the playlist's mood
  String _getMoodEmoji(String mood) {
    switch (mood.toLowerCase()) {
      case 'happy':
      case 'joyful':
      case 'excited':
        return '😊';
      case 'sad':
      case 'melancholy':
      case 'blue':
        return '😢';
      case 'energetic':
      case 'motivated':
      case 'powerful':
        return '⚡';
      case 'calm':
      case 'peaceful':
      case 'relaxed':
      case 'chill':
        return '😌';
      case 'romantic':
      case 'love':
        return '💕';
      case 'nostalgic':
      case 'memory':
        return '🎭';
      case 'angry':
      case 'frustrated':
        return '😡';
      case 'mysterious':
      case 'dark':
        return '🌙';
      case 'hopeful':
      case 'optimistic':
        return '🌟';
      case 'dreamy':
      case 'ethereal':
        return '☁️';
      default:
        return '🎵';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BaseColors.alabaster,
      body: BlocBuilder<PlaylistCubit, PlaylistState>(
        bloc: _cubit,
        builder: (context, state) {
          if (state is PlaylistLoading) {
            return const Center(
              child: CircularProgressIndicator(
                color: BaseColors.gold3,
              ),
            );
          }
          
          if (state is PlaylistError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 64,
                    color: BaseColors.gray3,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Oops! Something went wrong',
                    style: FontTheme.poppins18w500black(),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    state.message,
                    style: FontTheme.poppins14w400black().copyWith(
                      color: BaseColors.gray3,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () => _cubit.loadDailyPlaylist(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: BaseColors.gold3,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Try Again'),
                  ),
                ],
              ),
            );
          }
          
          if (state is PlaylistLoaded) {
            return _buildPlaylistContent(state);
          }
          
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildPlaylistContent(PlaylistLoaded state) {
    final playlist = state.playlist;
    
    return CustomScrollView(
      controller: _scrollController,
      slivers: [
        // Header Section (Spotify-style)
        SliverAppBar(
          expandedHeight: 320,
          floating: false,
          pinned: true,
          backgroundColor: BaseColors.gold3,
          flexibleSpace: FlexibleSpaceBar(
            background: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    BaseColors.gold3,
                    BaseColors.goldenrod,
                    BaseColors.alabaster,
                  ],
                  stops: const [0.0, 0.7, 1.0],
                ),
              ),
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      const SizedBox(height: 60),
                      // Playlist Cover
                      Container(
                        width: 200,
                        height: 200,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.3),
                              blurRadius: 20,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  BaseColors.gold3.withOpacity(0.8),
                                  BaseColors.goldenrod.withOpacity(0.6),
                                ],
                              ),
                            ),
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                Text(
                                  _getMoodEmoji(playlist.generatedFromMood),
                                  style: const TextStyle(
                                    fontSize: 80,
                                    fontFamily: '.SF UI Text', // iOS system font for emojis
                                  ),
                                ),
                                Positioned(
                                  bottom: 12,
                                  right: 12,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.black.withOpacity(0.6),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Text(
                                      playlist.generatedFromMood.toUpperCase(),
                                      style: FontTheme.poppins12w600black().copyWith(
                                        color: BaseColors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              color: BaseColors.white,
            ),
            onPressed: () => Navigator.of(context).pop(),
          ),
          actions: [
            IconButton(
              icon: Icon(
                Icons.more_vert,
                color: BaseColors.white,
              ),
              onPressed: () {
                // TODO: Show more options
              },
            ),
          ],
        ),
        
        // Playlist Info Section
        SliverToBoxAdapter(
          child: Container(
            color: BaseColors.alabaster,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Playlist Title
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        playlist.name,
                        style: FontTheme.poppins28w700black(),
                      ),
                    ),
                    if (playlist.moodTag != null) ...[
                      const SizedBox(width: 12),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: BaseColors.gold3.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: BaseColors.gold3.withOpacity(0.3),
                            width: 1,
                          ),
                        ),
                        child: Text(
                          playlist.moodTag!,
                          style: FontTheme.poppins12w500black().copyWith(
                            color: BaseColors.gold3,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 8),
                
                // Playlist Description
                Text(
                  playlist.description,
                  style: FontTheme.poppins14w400black().copyWith(
                    color: BaseColors.gray3,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 16),
                
                // Playlist Stats
                Row(
                  children: [
                    Icon(
                      Icons.music_note,
                      size: 16,
                      color: BaseColors.gray3,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${playlist.songCount} songs',
                      style: FontTheme.poppins12w500black().copyWith(
                        color: BaseColors.gray3,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                
                // Control Buttons
                Row(
                  children: [
                    // Play/Pause Button
                    Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        color: BaseColors.gold3,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: BaseColors.gold3.withOpacity(0.3),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: IconButton(
                        onPressed: () => _cubit.playPause(),
                        icon: Icon(
                          state.isPlaying ? Icons.pause : Icons.play_arrow,
                          color: BaseColors.white,
                          size: 28,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    
                    // Shuffle Button
                    IconButton(
                      onPressed: () => _cubit.shufflePlaylist(),
                      icon: Icon(
                        Icons.shuffle,
                        color: state.isShuffled ? BaseColors.gold3 : BaseColors.gray3,
                        size: 24,
                      ),
                    ),
                    
                    const Spacer(),
                    
                    // Download Button
                    IconButton(
                      onPressed: () {
                        // TODO: Download playlist
                      },
                      icon: Icon(
                        Icons.file_download_outlined,
                        color: BaseColors.gray3,
                        size: 24,
                      ),
                    ),
                    
                    // Share Button
                    IconButton(
                      onPressed: () {
                        // TODO: Share playlist
                      },
                      icon: Icon(
                        Icons.share_outlined,
                        color: BaseColors.gray3,
                        size: 24,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        
        // Songs List
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              final song = playlist.songs[index];
              final isCurrentSong = state.currentSongIndex == index;
              
              return SongTile(
                song: song,
                isCurrentSong: isCurrentSong,
                isPlaying: state.isPlaying && isCurrentSong,
                onTap: () {
                  // First, update the current song indicator
                  _cubit.selectSong(index);
                  
                  // Then, launch Spotify URL
                  final spotifyUrl = song.spotifyUrl;
                  if (spotifyUrl != null && spotifyUrl.isNotEmpty) {
                    UrlLauncherUtils.launchSpotifyUrl(spotifyUrl);
                  } else {
                    // Fallback: construct a search URL if no direct Spotify link
                    final searchUrl = 'https://open.spotify.com/search/${Uri.encodeComponent('${song.title} ${song.artist}')}';
                    UrlLauncherUtils.launchSpotifyUrl(searchUrl);
                  }
                },
                trackNumber: index + 1,
              );
            },
            childCount: playlist.songs.length,
          ),
        ),
        
        // Bottom Padding
        const SliverToBoxAdapter(
          child: SizedBox(height: 100),
        ),
      ],
    );
  }
}

class PlaylistDemoPage extends StatelessWidget {
  const PlaylistDemoPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Demo playlist untuk showcase
    return const PlaylistPage(playlistId: 'demo_playlist_1');
  }
}
