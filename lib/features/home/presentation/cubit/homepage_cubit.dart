part of '_cubit.dart';

@injectable
class HomepageCubit extends Cubit<HomepageState> {
  final QuoteUsecases _quoteUsecases;
  Timer? _timer;

  HomepageCubit(this._quoteUsecases) : super(_initialState()) {
    _startTimer();
  }

  void fetchQuote() async {
    emit(state.copyWith(isLoadingQuote: true));

    final result = await _quoteUsecases.execute();
    await result.fold(
      (fail) async {
        LoggerService.w(
          'Failed to fetch quote: $fail\n'
          'Checking local cache...',
        );

        final cached = await _quoteUsecases.execute('local');
        cached.fold(
          (cacheFail) {
            LoggerService.e('Failed to fetch local quote: $cacheFail');
            emit(state.copyWith(isLoadingQuote: false));
          },
          (cacheSuccess) {
            emit(
              state.copyWith(
                quote: cacheSuccess.data['result'],
                isLoadingQuote: false,
              ),
            );
          },
        );
      },
      (success) {
        emit(
          state.copyWith(quote: success.data['result'], isLoadingQuote: false),
        );
      },
    );
  }

  static HomepageState _initialState() {
    final now = DateTime.now();
    return HomepageState(
      quote: QuoteModel(
        q: 'The only way to do great work is to love what you do.', // Dummy
        a: 'Steve Jobs',
      ),
      timeOfDay: getTimeOfDay(now),
      currentTime: now,
      greeting: getGreeting(now),
      isLoadingQuote: true,
    );
  }

  void _startTimer() {
    // NOTE: Update every minute
    _timer = Timer.periodic(Duration(minutes: 10), (timer) {
      _updateTime();
    });
  }

  void _updateTime() {
    final now = DateTime.now();
    final newTimeOfDay = getTimeOfDay(now);

    // Only emit if time period actually changed
    if (newTimeOfDay != state.timeOfDay) {
      emit(
        HomepageState(
          timeOfDay: newTimeOfDay,
          currentTime: now,
          greeting: getGreeting(now),
          quote: state.quote,
          isLoadingQuote: state.isLoadingQuote,
        ),
      );
    }
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }
}
