import 'dart:convert';

class Analyzed {
  Emotion emotion;
  String music; // JSON string of music recommendations

  Analyzed({required this.emotion, required this.music});

  factory Analyzed.fromMap(Map<String, dynamic> map) {
    return Analyzed(
      emotion: Emotion.fromMap(map['emotion'] ?? {}),
      music: jsonEncode(map['music'] ?? ''),
    );
  }
}

class Emotion {
  String label;
  String emoji;
  double valence;
  double energy;
  String query;
  String advice;

  Emotion({
    required this.label,
    required this.emoji,
    required this.valence,
    required this.energy,
    required this.query,
    required this.advice,
  });

  factory Emotion.fromMap(Map<String, dynamic> map) {
    return Emotion(
      label: map['label'] ?? '',
      emoji: map['emoji'] ?? '',
      valence: (map['valence'] ?? 0.0).toDouble(),
      energy: (map['energy'] ?? 0.0).toDouble(),
      query: map['query'] ?? '',
      advice: map['advice'] ?? '',
    );
  }
}
