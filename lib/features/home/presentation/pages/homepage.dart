import 'package:flutter/material.dart';
import 'package:moodtune/core/themes/_themes.dart';

// NOTE: cuma placeholder blom ril

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BaseColors.alabaster,
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // Header Section
          _buildHeader(),
          const SizedBox(height: 24),

          // Mood Check Section
          _buildMoodSection(),
          const SizedBox(height: 24),

          // Quick Actions
          _buildQuickActions(),
          const SizedBox(height: 24),

          // Recent Playlists
          _buildRecentPlaylists(),
          const SizedBox(height: 24),

          // Recommended Music
          _buildRecommendedMusic(),
          const SizedBox(height: 24),

          // Stats Section
          _buildStatsSection(),
          const SizedBox(height: 90), // Extra space for floating navbar
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Good Morning!',
              style: FontTheme.poppins16w400black().copyWith(
                color: BaseColors.gray3,
              ),
            ),
            Text(
              'How are you feeling today?',
              style: FontTheme.poppins18w700black(),
            ),
          ],
        ),
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: BaseColors.gold3,
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(Icons.person, color: BaseColors.white, size: 24),
        ),
      ],
    );
  }

  Widget _buildMoodSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: BaseColors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: BaseColors.gray2.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Today\'s Mood', style: FontTheme.poppins18w500black()),
          const SizedBox(height: 16),
          Wrap(
            children: [
              _buildMoodButton('😊', 'Happy', true),
              _buildMoodButton('😢', 'Sad', false),
              _buildMoodButton('😴', 'Calm', false),
              _buildMoodButton('🔥', 'Energetic', false),
              _buildMoodButton('😌', 'Relaxed', false),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMoodButton(String emoji, String label, bool isSelected) {
    return GestureDetector(
      onTap: () {
        // TODO: Handle mood selection
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? BaseColors.gold3.withOpacity(0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? BaseColors.gold3 : BaseColors.gray2,
            width: 1,
          ),
        ),
        child: Column(
          children: [
            Text(emoji, style: const TextStyle(fontSize: 24)),
            const SizedBox(height: 4),
            Text(
              label,
              style: FontTheme.poppins12w400black().copyWith(
                color: isSelected ? BaseColors.gold3 : BaseColors.gray3,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Quick Actions', style: FontTheme.poppins18w500black()),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildActionCard(
                'Create Playlist',
                Icons.playlist_add,
                BaseColors.malibu,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildActionCard(
                'Journal Entry',
                Icons.edit_note,
                BaseColors.success,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActionCard(String title, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: BaseColors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: BaseColors.gray2.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: FontTheme.poppins14w500black(),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildRecentPlaylists() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Recent Playlists', style: FontTheme.poppins18w500black()),
            Text(
              'See All',
              style: FontTheme.poppins14w400black().copyWith(
                color: BaseColors.gold3,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 120,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: 5,
            itemBuilder: (context, index) {
              return _buildPlaylistCard(index);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildPlaylistCard(int index) {
    final playlists = [
      {'name': 'Happy Vibes', 'songs': '24 songs', 'color': BaseColors.malibu},
      {'name': 'Chill Out', 'songs': '18 songs', 'color': BaseColors.success},
      {'name': 'Workout Mix', 'songs': '32 songs', 'color': BaseColors.error},
      {
        'name': 'Study Focus',
        'songs': '15 songs',
        'color': BaseColors.purpleHearth,
      },
      {'name': 'Sleep Sounds', 'songs': '12 songs', 'color': BaseColors.cerise},
    ];

    final playlist = playlists[index];

    return Container(
      width: 100,
      margin: const EdgeInsets.only(right: 12),
      child: Column(
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: (playlist['color'] as Color).withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              Icons.music_note,
              color: playlist['color'] as Color,
              size: 32,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            playlist['name'] as String,
            style: FontTheme.poppins12w500black(),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          Text(
            playlist['songs'] as String,
            style: FontTheme.poppins10w400black().copyWith(
              color: BaseColors.gray3,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildRecommendedMusic() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Recommended for You', style: FontTheme.poppins18w500black()),
        const SizedBox(height: 12),
        ...List.generate(3, (index) => _buildMusicItem(index)),
      ],
    );
  }

  Widget _buildMusicItem(int index) {
    final songs = [
      {'title': 'Peaceful Mind', 'artist': 'Calm Sounds', 'duration': '3:24'},
      {'title': 'Happy Days', 'artist': 'Sunshine Music', 'duration': '4:12'},
      {'title': 'Focus Flow', 'artist': 'Study Beats', 'duration': '5:07'},
    ];

    final song = songs[index];

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: BaseColors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: BaseColors.gray2.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: BaseColors.gold3.withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.music_note, color: BaseColors.gold3),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  song['title'] as String,
                  style: FontTheme.poppins14w500black(),
                ),
                Text(
                  song['artist'] as String,
                  style: FontTheme.poppins12w400black().copyWith(
                    color: BaseColors.gray3,
                  ),
                ),
              ],
            ),
          ),
          Column(
            children: [
              Text(
                song['duration'] as String,
                style: FontTheme.poppins12w400black().copyWith(
                  color: BaseColors.gray3,
                ),
              ),
              const SizedBox(height: 4),
              const Icon(Icons.play_arrow, color: BaseColors.gold3),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatsSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: BaseColors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: BaseColors.gray2.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Your Progress', style: FontTheme.poppins18w500black()),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildStatItem(
                  '7',
                  'Day Streak',
                  Icons.local_fire_department,
                ),
              ),
              Expanded(
                child: _buildStatItem('142', 'Songs Played', Icons.headset),
              ),
              Expanded(
                child: _buildStatItem('23', 'Journal Entries', Icons.book),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String number, String label, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: BaseColors.gold3, size: 24),
        const SizedBox(height: 8),
        Text(
          number,
          style: FontTheme.poppins20w700black().copyWith(
            color: BaseColors.gold3,
          ),
        ),
        Text(
          label,
          style: FontTheme.poppins12w400black().copyWith(
            color: BaseColors.gray3,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
