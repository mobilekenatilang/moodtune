part of '_pages.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late HomepageCubit _cubit;
  late HomepageJournalCubit _journalCubit;
  late ProfileBloc _profileBloc;

  @override
  void initState() {
    super.initState();
    _journalCubit = get.get<HomepageJournalCubit>();
    _journalCubit.init();
    _cubit = get.get<HomepageCubit>();
    _cubit.fetchQuote();
    _profileBloc = get.get<ProfileBloc>();
    _profileBloc.add(FetchProfile());
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
            height: MediaQuery.of(context).size.height / 2,
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
            physics: const ClampingScrollPhysics(),
            children: [
              _buildHeader(),
              const SizedBox(height: 32),
              _buildStatsSection(),
              const SizedBox(height: 24),
              _buildJournalPreview(),
              const SizedBox(height: 100),
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
          BlocBuilder<ProfileBloc, ProfileState>(
            bloc: _profileBloc,
            builder: (context, state) {
              String userName = 'User';
              if (state is ProfileLoaded && state.profile.name.isNotEmpty) {
                userName = state.profile.name
                    .split(' ')
                    .first; // Ambil nama depan saja
              }
              return Text('$userName!', style: FontTheme.poppins24w700black());
            },
          ),
          const SizedBox(height: 24),
          BlocBuilder<HomepageJournalCubit, HomepageJournalState>(
            bloc: _journalCubit,
            buildWhen: (previous, current) => previous.streak != current.streak,
            builder: (context, state) {
              return WeeklyStreak(streak: state.streak);
            },
          ),
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
                child: BlocBuilder<HomepageJournalCubit, HomepageJournalState>(
                  bloc: _journalCubit,
                  builder: (context, state) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: StatsItem(
                            label: 'Streak',
                            number: state.streakCount,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: StatsItem(
                            label: 'Entries',
                            number: state.totalEntries,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: StatsItem(
                            label: 'Days',
                            number: state.daysCount,
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),
              _buildQuoteSection(),
              const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 22),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                  backgroundColor: BaseColors.gold3,
                ),
                onPressed: () => nav.push(AddJournal(fromHome: true)),
                child: SizedBox(
                  width: double.infinity,
                  child: Text(
                    'Bagaimana perasaanmu hari ini?',
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
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Icon(LucideIcons.sparkles, color: BaseColors.gold3, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    'Quote of The Day',
                    style: FontTheme.poppins14w600black().copyWith(
                      fontSize: 15,
                    ),
                  ),
                ],
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

  Widget _buildJournalPreview() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Jurnal Terbaru',
                style: FontTheme.poppins14w600black().copyWith(fontSize: 16),
              ),
              InkWell(
                onTap: () => _journalCubit.updateJournals(),
                borderRadius: BorderRadius.circular(20),
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Icon(
                    Icons.refresh,
                    color: BaseColors.neutral70,
                    size: 20,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          BlocBuilder<HomepageJournalCubit, HomepageJournalState>(
            bloc: _journalCubit,
            buildWhen: (previous, current) =>
                previous.journals != current.journals,
            builder: (context, state) {
              if (state.journals.isEmpty) {
                return Container(
                  padding: const EdgeInsets.symmetric(vertical: 24),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.book_outlined,
                          color: BaseColors.gray3,
                          size: 32,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Tidak ada jurnal yang kamu buat minggu ini...',
                          style: FontTheme.poppins14w400black().copyWith(
                            color: BaseColors.gray2,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }
              return Column(
                children: [
                  ...state.journals
                      .take(5)
                      .map(
                        (journal) => Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: JournalCard(
                            journal: journal,
                            isPreview: true,
                            onTap: () {
                              nav.push(
                                JournalPage(journal: journal, fromHome: true),
                              );
                            },
                          ),
                        ),
                      ),
                ],
              );
            },
          ),
          const SizedBox(height: 8),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 18),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
              backgroundColor: BaseColors.gold3,
            ),
            onPressed: () => nav.push(JournalListPage()),
            child: SizedBox(
              width: double.infinity,
              child: Text(
                'See More Journals',
                style: FontTheme.poppins14w600black().copyWith(
                  color: BaseColors.white,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
