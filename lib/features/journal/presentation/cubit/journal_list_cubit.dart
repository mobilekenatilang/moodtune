part of '_cubit.dart';

@singleton
class JournalListCubit extends Cubit<JournalListState> {
  final GetJournalByMonthUsecase _getJournalByMonthUsecase;
  final SearchJournalUsecase _searchJournalUsecase;

  JournalListCubit(this._getJournalByMonthUsecase, this._searchJournalUsecase)
    : super(JournalListState(selectedMonth: DateTime.now()));

  Timer? _searchDebouncer;

  Future<void> init() async {
    await fetchJournalsForMonth(DateTime.now());
  }

  Future<void> refreshAll() async {
    emit(state.copyWith(isLoading: true, clearError: true));

    final params = GetJournalByMonthParams(
      year: state.selectedMonth.year,
      month: state.selectedMonth.month,
    );
    final result = await _getJournalByMonthUsecase.execute(params);

    result.fold(
      (failure) {
        LoggerService.e('Failed to fetch all journals: ${failure.message}');
        emit(state.copyWith(isLoading: false, errorMessage: failure.message));
      },
      (success) {
        if (success.data['result'] == null) {
          emit(
            state.copyWith(
              isLoading: false,
              journals: [],
              hasMoreData: false,
              currentPage: 1,
            ),
          );
          return;
        }

        final journals = success.data['result'] as List<Journal>;

        // Sort by timestamp (newest first)
        journals.sort(
          (a, b) => int.parse(b.timestamp).compareTo(int.parse(a.timestamp)),
        );

        LoggerService.i('Refreshed all ${journals.length} journals');

        emit(
          state.copyWith(
            isLoading: false,
            journals: journals,
            hasMoreData: false,
            currentPage: 1,
          ),
        );
      },
    );
  }

  Future<void> fetchJournalsForMonth(DateTime month) async {
    emit(
      state.copyWith(isLoading: true, selectedMonth: month, clearError: true),
    );

    // Use the dedicated month usecase for better performance
    final params = GetJournalByMonthParams(
      year: month.year,
      month: month.month,
    );
    final result = await _getJournalByMonthUsecase.execute(params);

    result.fold(
      (failure) {
        LoggerService.e(
          'Failed to fetch journals for month: ${failure.message}',
        );
        emit(state.copyWith(isLoading: false, errorMessage: failure.message));
      },
      (success) {
        if (success.data['result'] == null) {
          emit(
            state.copyWith(
              isLoading: false,
              journals: [],
              hasMoreData: false,
              currentPage: 1,
            ),
          );
          return;
        }

        final journals = success.data['result'] as List<Journal>;

        // Sort by timestamp (newest first)
        journals.sort(
          (a, b) => int.parse(b.timestamp).compareTo(int.parse(a.timestamp)),
        );

        LoggerService.i(
          'Fetched ${journals.length} journals for ${month.year}-${month.month}',
        );

        emit(
          state.copyWith(
            isLoading: false,
            journals: journals,
            hasMoreData: false, // Since we're getting monthly data
            currentPage: 1,
          ),
        );
      },
    );
  }

  void searchJournals(String query) {
    _searchDebouncer?.cancel();

    if (query.isEmpty) {
      emit(
        state.copyWith(searchQuery: '', searchResults: [], isSearching: false),
      );
      return;
    }

    emit(state.copyWith(searchQuery: query, isSearching: true));

    _searchDebouncer = Timer(const Duration(milliseconds: 500), () async {
      final result = await _searchJournalUsecase.execute(query);
      result.fold(
        (failure) {
          LoggerService.e('Failed to search journals: ${failure.message}');
          emit(
            state.copyWith(isSearching: false, errorMessage: failure.message),
          );
        },
        (success) {
          if (success.data['result'] == null) {
            emit(state.copyWith(isSearching: false, searchResults: []));
            return;
          }

          final searchResults = success.data['result'] as List<Journal>;

          // Sort by timestamp (newest first)
          searchResults.sort(
            (a, b) => int.parse(b.timestamp).compareTo(int.parse(a.timestamp)),
          );

          LoggerService.i(
            'Found ${searchResults.length} journals matching "$query"',
          );

          emit(
            state.copyWith(isSearching: false, searchResults: searchResults),
          );
        },
      );
    });
  }

  void clearSearch() {
    _searchDebouncer?.cancel();
    emit(
      state.copyWith(searchQuery: '', searchResults: [], isSearching: false),
    );
  }

  void clearError() {
    emit(state.copyWith(clearError: true));
  }

  @override
  Future<void> close() {
    _searchDebouncer?.cancel();
    return super.close();
  }
}
