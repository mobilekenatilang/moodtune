// NOTE: For simplicity, @freezed is not used in this model.

class Journal {
  final String timestamp;
  final String title;
  final String content;
  final Mood mood;
  final String? advice;
  final String? playlist; // JSON string of playlist

  Journal({
    required this.timestamp,
    required this.title,
    required this.content,
    required this.mood,
    this.advice,
    this.playlist,
  });

  factory Journal.fromMap(Map<String, dynamic> map) {
    return Journal(
      timestamp: map['timestamp'] ?? '',
      title: map['title'] ?? '',
      content: map['content'] ?? '',
      mood: Mood.fromString(map['mood']) ?? Mood.unknown,
      advice: map['advice'] ?? '',
      playlist: map['playlist'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'timestamp': timestamp,
      'title': title,
      'content': content,
      'mood': mood.toString(),
      'advice': advice ?? '',
      'playlist': playlist ?? '',
    };
  }

  Journal copyWith({
    String? timestamp,
    String? title,
    String? content,
    Mood? mood,
    String? advice,
    String? playlist,
  }) {
    return Journal(
      timestamp: timestamp ?? this.timestamp,
      title: title ?? this.title,
      content: content ?? this.content,
      mood: mood ?? this.mood,
      advice: advice ?? this.advice,
      playlist: playlist ?? this.playlist,
    );
  }
}

enum Mood {
  happy('happy', '😄'),
  calm('calm', '😌'),
  sad('sad', '😔'),
  angry('angry', '😡'),
  anxious('anxious', '😰'),
  tired('tired', '😴'),
  unknown('unknown', '🤔');

  const Mood(this.value, this.emoji);

  final String value;
  final String emoji;

  static Mood? fromString(String? value) {
    if (value == null || value.isEmpty) return Mood.unknown;
    return Mood.values.firstWhere(
      (mood) => mood.value == value,
      orElse: () => Mood.unknown,
    );
  }

  @override
  String toString() => value;
}
