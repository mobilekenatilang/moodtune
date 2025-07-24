part of '_cubit.dart';

@injectable
class CalendarCubit extends Cubit<CalendarState> {
  final CalendarUsecases _calendarUsecases;

  CalendarCubit(this._calendarUsecases)
    : super(
        CalendarState(
          currentMonth: DateTime(DateTime.now().year, DateTime.now().month),
        ),
      );

  Future<void> fetchMonth({bool forceRemote = false}) async {
    emit(state.copyWith(isLoading: true, error: null));

    final year = state.currentMonth.year;
    final month = state.currentMonth.month;

    final result = await _calendarUsecases.execute({
      'year': year,
      'month': month,
      'forceRemote': forceRemote,
    });

    result.fold(
      (fail) {
        LoggerService.e("Failed to fetch calendar: ${fail.message}");
        emit(
          state.copyWith(
            summary: MonthMoodSummaryModel(
              year: year,
              month: month,
              days: [],
              labelCount: {},
              lastSync: DateTime.now(),
            ),
            isLoading: false,
            error: fail.message,
          ),
        );
      },
      (success) {
        final data = success.data['result'] as MonthMoodSummaryModel?;
        if (data == null || data.days.isEmpty) {
          LoggerService.w("No mood data for $month/$year. Showing empty.");
          emit(
            state.copyWith(
              summary: MonthMoodSummaryModel(
                year: year,
                month: month,
                days: [],
                labelCount: {},
                lastSync: DateTime.now(),
              ),
              isLoading: false,
              error: null,
            ),
          );
        } else {
          LoggerService.i("Fetched ${data.days.length} days for $month/$year");
          emit(state.copyWith(summary: data, isLoading: false, error: null));
        }
      },
    );
  }

  Future<void> saveDayMonth(DailyMoodEntry entry) async {
    emit(state.copyWith(isLoading: true, error: null));

    final result = await _calendarUsecases.execute({'save': entry});

    result.fold(
      (fail) {
        LoggerService.e("Failed to save mood: ${fail.message}");
        emit(
          state.copyWith(summary: null, isLoading: false, error: fail.message),
        );
      },
      (success) {
        final updated = success.data['result'] as MonthMoodSummaryModel;
        LoggerService.i(
          "Saved mood for ${entry.timestamp.day}/${entry.timestamp.month}: "
          "${entry.emoji} (${entry.label})",
        );
        emit(state.copyWith(summary: updated, isLoading: false, error: null));
      },
    );
  }

  void nextMonth() {
    final next = DateTime(
      state.currentMonth.year,
      state.currentMonth.month + 1,
    );
    emit(state.copyWith(currentMonth: next));
    fetchMonth();
  }

  void prevMonth() {
    final prev = DateTime(
      state.currentMonth.year,
      state.currentMonth.month - 1,
    );
    emit(state.copyWith(currentMonth: prev));
    fetchMonth();
  }
}
