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
      // **Tambahkan background di luar ListView**
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
          SafeArea(
            child: BlocBuilder<CalendarCubit, CalendarState>(
              bloc: _cubit,
              builder: (context, state) {
                return ListView(
                  padding:
                      const EdgeInsets.symmetric(
                        horizontal: 18,
                        vertical: 12,
                      ).copyWith(
                        bottom: 100,
                        // ✅ extra space agar tidak ketutup navbar (atur sesuai tinggi navbar Anda, misal 80–120)
                      ),
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
            ),
          ),
        ],
      ),
    );
  }
}
