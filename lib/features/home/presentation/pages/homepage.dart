part of '_pages.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late HomepageCubit _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = get.get<HomepageCubit>();
    _cubit.fetchQuote();
  }

  @override
  void dispose() {
    _cubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BaseColors.alabaster,
      body: Stack(
        children: [
          Container(
            height: 360,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: BaseColors.homepageGradientColors,
              ),
            ),
          ),
          ListView(
            padding: const EdgeInsets.all(18),
            children: [
              _buildHeader(),
              const SizedBox(height: 32),
              _buildStatsSection(),
              const SizedBox(height: 90),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 8),
          BlocBuilder<HomepageCubit, HomepageState>(
            bloc: _cubit,
            buildWhen: (previous, current) =>
                previous.timeOfDay != current.timeOfDay ||
                previous.currentTime != current.currentTime,
            builder: (context, state) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    state.timeOfDay == TimeOfDay.morning
                        ? Assets.image.sunriseIcon
                        : state.timeOfDay == TimeOfDay.afternoon
                        ? Assets.image.sunnyIcon
                        : Assets.image.moonIcon,
                    width: 30,
                    height: 30,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    getFormattedDate(state.currentTime),
                    style: FontTheme.poppins14w600black(),
                  ),
                ],
              );
            },
          ),
          const SizedBox(height: 16),
          BlocBuilder<HomepageCubit, HomepageState>(
            bloc: _cubit,
            buildWhen: (previous, current) =>
                previous.timeOfDay != current.timeOfDay ||
                previous.currentTime != current.currentTime,
            builder: (context, state) {
              return Text(
                '${state.greeting},',
                style: FontTheme.poppins24w500black(),
              );
            },
          ),
          Text(
            'User!', // TODO: Ambil nama user
            style: FontTheme.poppins24w700black(),
          ),
          const SizedBox(height: 32),
          WeeklyStreak(dateNow: DateTime.now()), // TODO: Create cubit for this
        ],
      ),
    );
  }

  Widget _buildStatsSection() {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 400),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
          decoration: BoxDecoration(
            color: BaseColors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: BaseColors.gray2.withValues(alpha: 0.1),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: StatsItem(label: 'Best Streak', number: 21),
                    ),
                    const SizedBox(width: 16),
                    Expanded(child: StatsItem(label: 'Entries', number: 142)),
                    const SizedBox(width: 16),
                    Expanded(child: StatsItem(label: 'Days', number: 1500)),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              _buildQuoteSection(),
              const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.all(20),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                  backgroundColor: BaseColors.gold3,
                ),
                onPressed: () => LoggerService.i("Go to add journal page"),
                child: SizedBox(
                  width: double.infinity,
                  child: Text(
                    'How are you feeling today?',
                    style: FontTheme.poppins14w600black().copyWith(
                      color: BaseColors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuoteSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: BaseColors.gray4.withValues(alpha: 0.75)),
      ),
      child: BlocBuilder<HomepageCubit, HomepageState>(
        bloc: _cubit,
        buildWhen: (previous, current) =>
            previous.quote != current.quote ||
            previous.isLoadingQuote != current.isLoadingQuote,
        builder: (context, state) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Quote of The Day',
                style: FontTheme.poppins14w600black().copyWith(fontSize: 16),
              ),
              const SizedBox(height: 8),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 500),
                switchInCurve: Curves.easeInOut,
                switchOutCurve: Curves.easeInOut,
                layoutBuilder: (currentChild, previousChildren) {
                  return Align(
                    alignment: Alignment.centerLeft,
                    child: currentChild,
                  );
                },
                child: state.isLoadingQuote
                    ? Shimmer.fromColors(
                        key: const ValueKey('shimmer'),
                        baseColor: BaseColors.gray4,
                        highlightColor: BaseColors.gray4.withValues(alpha: 0.5),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: double.infinity,
                              height: 16,
                              decoration: BoxDecoration(
                                color: BaseColors.gray4,
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Container(
                              width: MediaQuery.of(context).size.width * 0.6,
                              height: 16,
                              decoration: BoxDecoration(
                                color: BaseColors.gray4,
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                          ],
                        ),
                      )
                    : Column(
                        key: const ValueKey('quote'),
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '"${state.quote.q}"',
                            style: FontTheme.poppins12w400black().copyWith(
                              color: BaseColors.gray2,
                            ),
                          ),
                          const SizedBox(height: 6),  
                          Text(
                            '- ${state.quote.a}',
                            style: FontTheme.poppins12w400black().copyWith(
                              color: BaseColors.gray2,
                            ),
                          ),
                        ],
                      ),
              ),
            ],
          );
        },
      ),
    );
  }
}
