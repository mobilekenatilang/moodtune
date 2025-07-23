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
          // Background gradient
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

          // Konten utama
          SafeArea(
            child: BlocBuilder<CalendarCubit, CalendarState>(
              bloc: _cubit,
              builder: (context, state) {
                if (state.isLoading) {
                  return _buildSkeleton();
                }

                return ListView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 12,
                  ).copyWith(bottom: 100),
                  children: [
                    // Header: dropdown + panah
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

                    MoodCalendarGrid(
                      currentMonth: state.currentMonth,
                      summary: state.summary,
                    ),
                    const SizedBox(height: 32),

                    MoodPercentageList(summary: state.summary),
                  ],
                );
              },
            )

          ),

          //FAB di tengah atas (sementara)
          // Positioned(
          //   top: 16, // atur jarak dari atas
          //   left: 0,
          //   right: 0,
          //   child: Center(
          //     child: FloatingActionButton(
          //       backgroundColor: BaseColors.gold3,
          //       onPressed: () => Navigator.push(
          //         context,
          //         MaterialPageRoute(builder: (_) => const CalendarTestPage()),
          //       ),
          //       child: const Icon(Icons.add, color: BaseColors.alabaster),
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }

  Widget _buildSkeleton() {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
      children: [
        Container(
          height: 30,
          width: 120,
          margin: const EdgeInsets.only(bottom: 20),
          decoration: BoxDecoration(
            color: BaseColors.gray4,
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        GridView.count(
          crossAxisCount: 7,
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          children: List.generate(
            42,
            (index) => Container(
              margin: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: BaseColors.gray4.withOpacity(0.5),
                shape: BoxShape.circle,
              ),
            ),
          ),
        ),
        const SizedBox(height: 32),
        Column(
          children: List.generate(
            3,
            (index) => Container(
              height: 20,
              margin: const EdgeInsets.symmetric(vertical: 6),
              decoration: BoxDecoration(
                color: BaseColors.gray4.withOpacity(0.5),
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ),
      ],
    );
  }


}
