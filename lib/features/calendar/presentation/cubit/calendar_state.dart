part of '_cubit.dart';

class CalendarState extends Equatable {
  final MonthMoodSummaryModel? summary;
  final bool isLoading;
  final String? error;
  final DateTime currentMonth;

  const CalendarState({
    required this.currentMonth,
    this.summary,
    this.isLoading = false,
    this.error,
  });

  CalendarState copyWith({
    MonthMoodSummaryModel? summary,
    bool? isLoading,
    String? error,
    DateTime? currentMonth,
  }) {
    return CalendarState(
      currentMonth: currentMonth ?? this.currentMonth,
      summary: summary ?? this.summary,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }

  @override
  List<Object?> get props => [summary, isLoading, error, currentMonth];
}
