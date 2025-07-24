class Song {
  final String id;
  final String title;
  final String artist;
  final String album;
  final String imageUrl;
  final String genre;
  final String mood; // happy, sad, energetic, calm, etc.
  final String? spotifyUrl; // Spotify external link

  const Song({
    required this.id,
    required this.title,
    required this.artist,
    required this.album,
    required this.imageUrl,
    required this.genre,
    required this.mood,
    this.spotifyUrl,
  });

  factory Song.empty() {
    return const Song(
      id: '',
      title: '',
      artist: '',
      album: '',
      imageUrl: '',
      genre: '',
      mood: '',
      spotifyUrl: null,
    );
  }

  /// Create Song from JSON response from backend API
  factory Song.fromJson(Map<String, dynamic> json, {String? mood}) {
    return Song(
      id: json['id']?.toString() ?? '',
      title: json['title']?.toString() ?? 'Unknown Title',
      artist: json['artist']?.toString() ?? 'Unknown Artist',
      album: json['album']?.toString() ?? 'Single',
      imageUrl: json['cover']?.toString() ?? '',
      genre: json['genre']?.toString() ?? 'Unknown',
      mood: mood ?? 'neutral',
      spotifyUrl: json['link']?.toString(), // Spotify URL from backend (using 'link' key)
    );
  }

  /// Get emoji that represents the song's mood
  String get moodEmoji {
    switch (mood.toLowerCase()) {
      case 'happy':
      case 'joyful':
        return '😊';
      case 'sad':
      case 'melancholy':
        return '😢';
      case 'energetic':
      case 'excited':
        return '⚡';
      case 'calm':
      case 'peaceful':
      case 'relaxed':
        return '😌';
      case 'romantic':
      case 'love':
        return '💕';
      case 'nostalgic':
        return '🎭';
      case 'angry':
        return '😡';
      case 'mysterious':
        return '🌙';
      default:
        return '🎵';
    }
  }
}
