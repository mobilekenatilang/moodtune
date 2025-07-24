part of '_pages.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  late CalendarCubit _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = get<CalendarCubit>();
    _cubit.fetchMonth();
  }

  @override
  void dispose() {
    _cubit.close();
    super.dispose();
  }

  void _changeMonth(int delta, CalendarState state) {
    final newDate = DateTime(
      state.currentMonth.year,
      state.currentMonth.month + delta,
    );
    _cubit.emit(state.copyWith(currentMonth: newDate));
    _cubit.fetchMonth();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // 1) Background gradient
          Container(
            height: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: BaseColors.homepageGradientColors,
              ),
            ),
          ),

          // 2) Konten utama
          SafeArea(
            child: BlocBuilder<CalendarCubit, CalendarState>(
              bloc: _cubit,
              builder: (context, state) {
                return ListView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 12,
                  ).copyWith(bottom: 100),
                  children: [
                    // — Header
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        MonthDropdown(
                          currentMonth: state.currentMonth,
                          onChanged: (newDate) {
                            _cubit.emit(state.copyWith(currentMonth: newDate));
                            _cubit.fetchMonth();
                          },
                        ),
                        Row(
                          children: [
                            IconButton(
                              onPressed: () => _changeMonth(-1, state),
                              icon: const Icon(
                                Icons.chevron_left,
                                color: BaseColors.neutral100,
                              ),
                            ),
                            IconButton(
                              onPressed: () => _changeMonth(1, state),
                              icon: const Icon(
                                Icons.chevron_right,
                                color: BaseColors.neutral100,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // — Grid atau skeleton
                    if (state.isLoading) ...[
                      _buildGridSkeleton(),
                    ] else ...[
                      MoodCalendarGrid(
                        currentMonth: state.currentMonth,
                        summary: state.summary,
                      ),
                    ],
                    const SizedBox(height: 32),

                    // — Average mood harian & bulanan
                    if (state.isLoading) ...[
                      _buildAverageSkeleton(),
                    ] else ...[
                      MoodPercentageList(summary: state.summary),
                    ],
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }


    Widget _buildGridSkeleton() {
    return GridView.count(
      crossAxisCount: 7,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: List.generate(42, (i) {
        return Shimmer.fromColors(
          baseColor: BaseColors.gray4,
          highlightColor: BaseColors.gray4.withOpacity(0.5),
          child: Container(
            margin: const EdgeInsets.all(4),
            decoration: const BoxDecoration(
              color: BaseColors.gray4,
              shape: BoxShape.circle,
            ),
          ),
        );
      }),
    );
  }

  /// Average‑mood skeleton: 3 bar, shimmer horizontal
  Widget _buildAverageSkeleton() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(3, (i) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: Shimmer.fromColors(
            baseColor: BaseColors.gray4,
            highlightColor: BaseColors.gray4.withOpacity(0.5),
            child: Row(
              children: [
                // label placeholder
                Container(
                  width: 60,
                  height: 14,
                  decoration: BoxDecoration(
                    color: BaseColors.gray4,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                const SizedBox(width: 8),
                // bar placeholder
                Expanded(
                  child: Container(
                    height: 14,
                    decoration: BoxDecoration(
                      color: BaseColors.gray4,
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                // persen placeholder
                Container(
                  width: 30,
                  height: 14,
                  decoration: BoxDecoration(
                    color: BaseColors.gray4,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                const SizedBox(width: 8),
                // emoji placeholder
                Container(
                  width: 20,
                  height: 20,
                  decoration: const BoxDecoration(
                    color: BaseColors.gray4,
                    shape: BoxShape.circle,
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }

}
