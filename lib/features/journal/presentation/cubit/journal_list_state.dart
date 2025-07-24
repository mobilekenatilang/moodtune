part of '_cubit.dart';

class JournalListState extends Equatable {
  final List<Journal> journals;
  final List<Journal> searchResults;
  final bool isLoading;
  final bool isSearching;
  final String? errorMessage;
  final DateTime selectedMonth;
  final String searchQuery;
  final bool hasMoreData;
  final int currentPage;

  const JournalListState({
    this.journals = const [],
    this.searchResults = const [],
    this.isLoading = false,
    this.isSearching = false,
    this.errorMessage,
    required this.selectedMonth,
    this.searchQuery = '',
    this.hasMoreData = true,
    this.currentPage = 1,
  });

  JournalListState copyWith({
    List<Journal>? journals,
    List<Journal>? searchResults,
    bool? isLoading,
    bool? isSearching,
    String? errorMessage,
    DateTime? selectedMonth,
    String? searchQuery,
    bool? hasMoreData,
    int? currentPage,
    bool clearError = false,
  }) {
    return JournalListState(
      journals: journals ?? this.journals,
      searchResults: searchResults ?? this.searchResults,
      isLoading: isLoading ?? this.isLoading,
      isSearching: isSearching ?? this.isSearching,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      selectedMonth: selectedMonth ?? this.selectedMonth,
      searchQuery: searchQuery ?? this.searchQuery,
      hasMoreData: hasMoreData ?? this.hasMoreData,
      currentPage: currentPage ?? this.currentPage,
    );
  }

  List<Journal> get displayedJournals =>
      searchQuery.isNotEmpty ? searchResults : journals;

  @override
  List<Object?> get props => [
    journals,
    searchResults,
    isLoading,
    isSearching,
    errorMessage,
    selectedMonth,
    searchQuery,
    hasMoreData,
    currentPage,
  ];
}
