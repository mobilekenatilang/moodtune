import 'package:moodtune/features/journal/data/model/journal.dart';

class PlaylistConstants {
  // Playlist titles based on mood
  static const Map<Mood, List<String>> playlistTitles = {
    Mood.happy: [
      'Playlist Kebahagiaan Hari Ini',
      'Melodi Bahagia untuk Harimu',
      'Musik Keceriaan Mood',
      'Harmoni Kegembiraan',
      'Soundtrack Kebahagiaan',
    ],
    Mood.calm: [
      'Playlist Ketenangan Jiwa',
      'Melodi Menenangkan Hari',
      'Musik Rileks untuk Pikiran',
      'Harmoni Kedamaian',
      'Soundtrack Ketenangan',
    ],
    Mood.sad: [
      'Playlist Penyembuh Hati',
      'Melodi untuk Healing',
      'Musik Pendamping Sedih',
      'Harmoni Pemulihan',
      'Soundtrack Penghiburan',
    ],
    Mood.angry: [
      'Playlist Penenang Amarah',
      'Melodi untuk Meredakan',
      'Musik Pengendalian Emosi',
      'Harmoni Keseimbangan',
      'Soundtrack Penyejuk',
    ],
    Mood.anxious: [
      'Playlist Anti Cemas',
      'Melodi Penenang Pikiran',
      'Musik untuk Meredakan Gelisah',
      'Harmoni Ketenangan Batin',
      'Soundtrack Peneduh Hati',
    ],
    Mood.tired: [
      'Playlist Penguat Semangat',
      'Melodi Penambah Energi',
      'Musik untuk Membangkitkan',
      'Harmoni Kebangkitan',
      'Soundtrack Penyegar',
    ],
    Mood.unknown: [
      'Playlist Campur Aduk',
      'Melodi Beragam Rasa',
      'Musik untuk Eksplorasi',
      'Harmoni Pencarian',
      'Soundtrack Perjalanan',
    ],
  };

  // Playlist image tags/badges based on mood
  static const Map<Mood, String> playlistTags = {
    Mood.happy: '🌟 HAPPY',
    Mood.calm: '🕊️ CALM',
    Mood.sad: '💙 HEALING',
    Mood.angry: '🔥 CHILL',
    Mood.anxious: '🌸 PEACE',
    Mood.tired: '⚡ BOOST',
    Mood.unknown: '🎭 MIXED',
  };

  // Default descriptions when advice is not available
  static const Map<Mood, String> defaultDescriptions = {
    Mood.happy: 'Kumpulan lagu yang akan memperkuat kebahagiaan dan keceriaan harimu',
    Mood.calm: 'Musik yang dipilih khusus untuk menjaga ketenangan dan kedamaian pikiranmu',
    Mood.sad: 'Lagu-lagu yang akan menemani dan membantu proses healing dari kesedihan',
    Mood.angry: 'Playlist untuk meredakan amarah dan mengembalikan keseimbangan emosi',
    Mood.anxious: 'Musik menenangkan untuk mengurangi kecemasan dan memberikan ketenangan',
    Mood.tired: 'Lagu-lagu energik yang akan membangkitkan semangat dan menghilangkan lelah',
    Mood.unknown: 'Beragam genre musik untuk menemani perjalanan eksplorasi perasaanmu',
  };

  /// Get random playlist title based on mood
  static String getPlaylistTitle(Mood mood) {
    final titles = playlistTitles[mood] ?? playlistTitles[Mood.unknown]!;
    return titles[DateTime.now().millisecondsSinceEpoch % titles.length];
  }

  /// Get playlist tag based on mood
  static String getPlaylistTag(Mood mood) {
    return playlistTags[mood] ?? playlistTags[Mood.unknown]!;
  }

  /// Get playlist description, preferring advice over default
  static String getPlaylistDescription(Mood mood, {String? advice}) {
    if (advice != null && advice.isNotEmpty) {
      return 'Berdasarkan analisis mood hari ini: $advice';
    }
    return defaultDescriptions[mood] ?? defaultDescriptions[Mood.unknown]!;
  }
}
