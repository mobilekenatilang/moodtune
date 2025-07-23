part of '_widgets.dart';

class SongTile extends StatelessWidget {
  final Song song;
  final bool isCurrentSong;
  final bool isPlaying;
  final VoidCallback onTap;
  final int trackNumber;

  const SongTile({
    super.key,
    required this.song,
    required this.isCurrentSong,
    required this.isPlaying,
    required this.onTap,
    required this.trackNumber,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          color: isCurrentSong ? BaseColors.gold3.withOpacity(0.1) : Colors.transparent,
        ),
        child: Row(
          children: [
            // Track Number or Playing Indicator
            SizedBox(
              width: 24,
              child: isCurrentSong && isPlaying
                  ? Icon(
                      Icons.bar_chart,
                      color: BaseColors.gold3,
                      size: 16,
                    )
                  : Text(
                      trackNumber.toString(),
                      style: FontTheme.poppins14w400black().copyWith(
                        color: isCurrentSong ? BaseColors.gold3 : BaseColors.gray3,
                      ),
                      textAlign: TextAlign.center,
                    ),
            ),
            const SizedBox(width: 16),
            
            // Song Cover
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: song.imageUrl.isNotEmpty
                    ? Image.network(
                        song.imageUrl,
                        width: 48,
                        height: 48,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            width: 48,
                            height: 48,
                            decoration: BoxDecoration(
                              color: BaseColors.gray1.withOpacity(0.5),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Icon(
                              Icons.music_note,
                              color: BaseColors.gray3,
                              size: 20,
                            ),
                          );
                        },
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Container(
                            width: 48,
                            height: 48,
                            decoration: BoxDecoration(
                              color: BaseColors.gray1.withOpacity(0.5),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Center(
                              child: SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  color: BaseColors.gray3,
                                  strokeWidth: 2,
                                ),
                              ),
                            ),
                          );
                        },
                      )
                    : Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: BaseColors.gray1.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Icon(
                          Icons.music_note,
                          color: BaseColors.gray3,
                          size: 20,
                        ),
                      ),
              ),
            ),
            const SizedBox(width: 16),
            
            // Song Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    song.title,
                    style: FontTheme.poppins14w500black().copyWith(
                      color: isCurrentSong ? BaseColors.gold3 : BaseColors.gray4,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          song.artist,
                          style: FontTheme.poppins12w400black().copyWith(
                            color: BaseColors.gray3,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (song.album.isNotEmpty) ...[
                        Text(
                          ' • ',
                          style: FontTheme.poppins12w400black().copyWith(
                            color: BaseColors.gray3,
                          ),
                        ),
                        Flexible(
                          child: Text(
                            song.album,
                            style: FontTheme.poppins12w400black().copyWith(
                              color: BaseColors.gray3,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
            
            // More Options
            IconButton(
              onPressed: () {
                _showSongOptions(context, song);
              },
              icon: Icon(
                Icons.more_vert,
                color: BaseColors.gray3,
                size: 20,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showSongOptions(BuildContext context, Song song) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: BaseColors.white,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(top: 12, bottom: 20),
              decoration: BoxDecoration(
                color: BaseColors.gray2,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            
            // Song Info Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: BaseColors.gray1.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Icon(
                      Icons.music_note,
                      color: BaseColors.gray3,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          song.title,
                          style: FontTheme.poppins14w500black(),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          song.artist,
                          style: FontTheme.poppins12w400black().copyWith(
                            color: BaseColors.gray3,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            
            // Options
            _buildOption(Icons.favorite_border, 'Add to Liked Songs', () {}),
            _buildOption(Icons.playlist_add, 'Add to Playlist', () {}),
            _buildOption(Icons.album_outlined, 'View Album', () {}),
            _buildOption(Icons.person_outline, 'View Artist', () {}),
            _buildOption(Icons.share_outlined, 'Share Song', () {}),
            
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildOption(IconData icon, String title, VoidCallback onTap) {
    return Builder(
      builder: (context) => ListTile(
        leading: Icon(
          icon,
          color: BaseColors.gray3,
        ),
        title: Text(
          title,
          style: FontTheme.poppins14w400black(),
        ),
        onTap: () {
          Navigator.pop(context);
          onTap();
        },
      ),
    );
  }
}
