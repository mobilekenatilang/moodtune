import 'package:flutter/material.dart';
import 'package:moodtune/core/themes/_themes.dart';
import 'package:moodtune/features/playlist/presentation/pages/_pages.dart';

class PlaylistDemo extends StatelessWidget {
  const PlaylistDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BaseColors.alabaster,
      appBar: AppBar(
        title: const Text('Playlist Demo'),
        backgroundColor: BaseColors.gold3,
        foregroundColor: BaseColors.white,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.playlist_play,
                size: 80,
                color: BaseColors.gold3,
              ),
              const SizedBox(height: 24),
              Text(
                'MoodTune Playlist',
                style: FontTheme.poppins24w700black(),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                'Experience personalized music playlists generated from your daily emotions and favorite artists',
                style: FontTheme.poppins16w400black().copyWith(
                  color: BaseColors.gray3,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const PlaylistPage(
                        playlistId: 'demo_playlist',
                      ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: BaseColors.gold3,
                  foregroundColor: BaseColors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 16,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.play_arrow),
                    const SizedBox(width: 8),
                    Text(
                      'View Sample Playlist',
                      style: FontTheme.poppins16w500black().copyWith(
                        color: BaseColors.white,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Coming Soon'),
                      content: const Text(
                        'Backend API integration is in progress. This demo shows the UI design with mock data.',
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('OK'),
                        ),
                      ],
                    ),
                  );
                },
                child: Text(
                  'Learn More',
                  style: FontTheme.poppins14w400black().copyWith(
                    color: BaseColors.gold3,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
