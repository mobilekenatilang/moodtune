part of '_cubit.dart';

class HomepageState extends Equatable {
  final QuoteModel quote;
  final TimeOfDay timeOfDay;
  final DateTime currentTime;
  final String greeting;

  final bool isLoadingQuote;

  const HomepageState({
    required this.quote,
    required this.timeOfDay,
    required this.currentTime,
    required this.greeting,
    this.isLoadingQuote = false,
  });

  HomepageState copyWith({
    QuoteModel? quote,
    TimeOfDay? timeOfDay,
    DateTime? currentTime,
    String? greeting,
    bool? isLoadingQuote,
  }) {
    return HomepageState(
      quote: quote ?? this.quote,
      timeOfDay: timeOfDay ?? this.timeOfDay,
      currentTime: currentTime ?? this.currentTime,
      greeting: greeting ?? this.greeting,
      isLoadingQuote: isLoadingQuote ?? this.isLoadingQuote,
    );
  }

  @override
  List<Object> get props => [quote, timeOfDay, currentTime, greeting];
}