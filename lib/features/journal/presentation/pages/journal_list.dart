part of '_pages.dart';

class JournalListPage extends StatefulWidget {
  const JournalListPage({super.key});

  @override
  State<JournalListPage> createState() => _JournalListPageState();
}

class _JournalListPageState extends State<JournalListPage> {
  late JournalListCubit _cubit;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _cubit = get.get<JournalListCubit>();
    _cubit.init();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BaseColors.alabaster,
      appBar: AppBar(
        backgroundColor: BaseColors.alabaster,
        elevation: 0,
        title: Text(
          'Journal Entries',
          style: FontTheme.poppins14w600black().copyWith(fontSize: 16),
        ),
        centerTitle: true,
        actionsPadding: const EdgeInsets.only(right: 8),
        actions: [
          IconButton(
            onPressed: () => _cubit.refreshAll(),
            icon: Icon(
              LucideIcons.refreshCw,
              color: BaseColors.gray1,
              size: 20,
            ),
          ),
        ],
      ),
      body: BlocProvider(
        create: (_) => _cubit,
        child: BlocBuilder<JournalListCubit, JournalListState>(
          builder: (context, state) {
            return RefreshIndicator(
              onRefresh: () async {
                await _cubit.fetchJournalsForMonth(state.selectedMonth);
              },
              backgroundColor: BaseColors.white,
              color: BaseColors.neutral100,
              child: Column(
                children: [
                  _buildSearchSection(state),
                  _buildMonthSelector(state),
                  Expanded(child: _buildJournalList(state)),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildSearchSection(JournalListState state) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 4, 16, 16),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: BaseColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: BaseColors.gray4),
      ),
      child: Row(
        children: [
          Icon(LucideIcons.search, color: BaseColors.gray2, size: 18),
          const SizedBox(width: 12),
          Expanded(
            child: TextField(
              controller: _searchController,
              onChanged: (value) => _cubit.searchJournals(value),
              decoration: InputDecoration(
                hintText: 'Search journals...',
                hintStyle: FontTheme.poppins12w400black().copyWith(
                  color: BaseColors.gray2,
                ),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(vertical: 12),
              ),
              style: FontTheme.poppins12w400black(),
            ),
          ),
          if (state.searchQuery.isNotEmpty)
            GestureDetector(
              onTap: () {
                _searchController.clear();
                _cubit.clearSearch();
              },
              child: Icon(LucideIcons.x, color: BaseColors.gray2, size: 20),
            ),
          if (state.isSearching)
            Container(
              width: 20,
              height: 20,
              margin: const EdgeInsets.only(left: 8),
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(BaseColors.gold3),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildMonthSelector(JournalListState state) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 10),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: BaseColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: BaseColors.gray5.withValues(alpha: 0.3)),
      ),
      child: GestureDetector(
        onTap: () => _showMonthPicker(state),
        child: Row(
          children: [
            Icon(LucideIcons.calendar, color: BaseColors.gray2, size: 20),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                _getMonthYearText(state.selectedMonth),
                style: FontTheme.poppins12w500black(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildJournalList(JournalListState state) {
    if (state.isLoading) {
      return Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(BaseColors.gold3),
        ),
      );
    }

    if (state.errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(LucideIcons.alertCircle, size: 48, color: BaseColors.gray2),
            const SizedBox(height: 16),
            Text(
              'Error loading journals',
              style: FontTheme.poppins14w500black(),
            ),
            const SizedBox(height: 8),
            Text(
              state.errorMessage!,
              style: FontTheme.poppins12w400black().copyWith(
                color: BaseColors.gray2,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                _cubit.clearError();
                _cubit.fetchJournalsForMonth(state.selectedMonth);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: BaseColors.gold3,
                foregroundColor: BaseColors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                'Retry',
                style: FontTheme.poppins12w500black().copyWith(
                  color: BaseColors.white,
                ),
              ),
            ),
          ],
        ),
      );
    }

    final journals = state.displayedJournals;

    if (journals.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              state.searchQuery.isNotEmpty
                  ? LucideIcons.searchX
                  : LucideIcons.bookOpen,
              size: 48,
              color: BaseColors.gray2,
            ),
            const SizedBox(height: 16),
            Text(
              state.searchQuery.isNotEmpty
                  ? 'No journals found'
                  : 'No journal entries',
              style: FontTheme.poppins14w500black(),
            ),
            const SizedBox(height: 8),
            Text(
              state.searchQuery.isNotEmpty
                  ? 'Try a different search term'
                  : 'Start writing your first journal entry',
              style: FontTheme.poppins12w400black().copyWith(
                color: BaseColors.gray2,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      itemCount: journals.length,
      itemBuilder: (context, index) {
        final journal = journals[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: JournalCard(
            journal: journal,
            isPreview: false,
            onTap: () => _navigateToJournalDetail(journal),
          ),
        );
      },
    );
  }

  String _getMonthYearText(DateTime date) {
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];
    return '${months[date.month - 1]} ${date.year}';
  }

  String _getMonthText(DateTime date) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return months[date.month - 1];
  }

  void _showMonthPicker(JournalListState state) {
    DateTime selectedDate = state.selectedMonth;

    showModalBottomSheet(
      context: context,
      backgroundColor: BaseColors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Container(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: BaseColors.gray4,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Select Month & Year',
                    style: FontTheme.poppins16w500black(),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    height: 180,
                    child: _buildMonthYearPicker(selectedDate, (newDate) {
                      setModalState(() {
                        selectedDate = newDate;
                      });
                    }),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: TextButton(
                          onPressed: () => Navigator.pop(context),
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text(
                            'Cancel',
                            style: FontTheme.poppins14w600black().copyWith(
                              color: BaseColors.gray2,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                            _cubit.fetchJournalsForMonth(selectedDate);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: BaseColors.gold3,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text(
                            'Done',
                            style: FontTheme.poppins14w600black().copyWith(
                              color: BaseColors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildMonthYearPicker(
    DateTime selectedMonth,
    Function(DateTime) onDateChanged,
  ) {
    final currentDate = DateTime.now();
    final months = <DateTime>[];

    // Generate months from January 1970 to current month (chronological order)
    for (int year = 1970; year <= currentDate.year; year++) {
      final endMonth = (year == currentDate.year) ? currentDate.month : 12;
      for (int month = 1; month <= endMonth; month++) {
        months.add(DateTime(year, month));
      }
    }

    // Find the index of the currently selected month
    int selectedIndex = months.indexWhere(
      (month) =>
          month.year == selectedMonth.year &&
          month.month == selectedMonth.month,
    );

    if (selectedIndex == -1)
      selectedIndex = months.length - 1; // Default to latest month

    // Generate years from 1970 to current year
    final years = List.generate(
      currentDate.year - 1969,
      (index) => 1970 + index,
    );
    int selectedYearIndex = years.indexOf(selectedMonth.year);
    if (selectedYearIndex == -1) selectedYearIndex = years.length - 1;

    return Column(
      children: [
        // Year slider
        SizedBox(
          height: 80,
          child: Column(
            children: [
              Text(
                'Year',
                style: FontTheme.poppins12w500black().copyWith(
                  color: BaseColors.gray2,
                ),
              ),
              const SizedBox(height: 8),
              SizedBox(
                height: 50,
                child: PageView.builder(
                  controller: PageController(
                    initialPage: selectedYearIndex,
                    viewportFraction: 0.3,
                  ),
                  onPageChanged: (index) {
                    if (index < years.length) {
                      final year = years[index];
                      final newDate = DateTime(year, selectedMonth.month);
                      onDateChanged(newDate);
                    }
                  },
                  itemCount: years.length,
                  itemBuilder: (context, index) {
                    final year = years[index];
                    final isSelected = year == selectedMonth.year;

                    return Center(
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? BaseColors.gold3
                              : BaseColors.transparent,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          year.toString(),
                          style: FontTheme.poppins14w600black().copyWith(
                            color: isSelected
                                ? BaseColors.white
                                : BaseColors.mineShaft,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 20),

        // Month slider
        SizedBox(
          height: 80,
          child: Column(
            children: [
              Text(
                'Month',
                style: FontTheme.poppins12w500black().copyWith(
                  color: BaseColors.gray2,
                ),
              ),
              const SizedBox(height: 8),
              SizedBox(
                height: 50,
                child: PageView.builder(
                  controller: PageController(
                    initialPage: selectedIndex,
                    viewportFraction: 0.4,
                  ),
                  onPageChanged: (index) {
                    if (index < months.length) {
                      onDateChanged(months[index]);
                    }
                  },
                  itemCount: months.length,
                  itemBuilder: (context, index) {
                    final month = months[index];
                    final isSelected =
                        month.year == selectedMonth.year &&
                        month.month == selectedMonth.month;

                    return Center(
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? BaseColors.gold3
                              : BaseColors.transparent,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Text(
                          _getMonthText(month),
                          style: FontTheme.poppins12w500black().copyWith(
                            color: isSelected
                                ? BaseColors.white
                                : BaseColors.mineShaft,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _navigateToJournalDetail(Journal journal) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => JournalPage(journal: journal)),
    );
  }
}
