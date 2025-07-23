import 'package:moodtune/features/playlist/domain/entities/song.dart';

class Playlist {
  final String id;
  final String name;
  final String description;
  final String imageUrl;
  final String? moodTag; // Tag mood untuk playlist (contoh: "🌟 HAPPY")
  final List<Song> songs;
  final String generatedFromMood;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Playlist({
    required this.id,
    required this.name,
    required this.description,
    required this.imageUrl,
    this.moodTag,
    required this.songs,
    required this.generatedFromMood,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Playlist.empty() {
    final now = DateTime.now();
    return Playlist(
      id: '',
      name: '',
      description: '',
      imageUrl: '',
      moodTag: null,
      songs: const [],
      generatedFromMood: '',
      createdAt: now,
      updatedAt: now,
    );
  }

  int get songCount => songs.length;
}
