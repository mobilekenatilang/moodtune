part of '_cubit.dart';

@singleton
class HomepageJournalCubit extends Cubit<HomepageJournalState> {
  final GetJournalByWeekUsecase _getJournalByWeekUsecase;

  HomepageJournalCubit(this._getJournalByWeekUsecase)
    : super(
        HomepageJournalState(
          streak: [0, 0, 0, 10, -1, -1, -1],
          streakCount: 0,
          totalEntries: 0,
          daysCount: 0,
        ),
      );

  Future<void> init() async {
    emit(
      HomepageJournalState(
        streak: await _fetchStreak(),
        streakCount: await _calculateCurrentStreak(),
        totalEntries: await SqfliteService.count('journal'),
        daysCount: await _getDaysCount(),
        journals: await _initJournals(),
      ),
    );
  }

  Future<void> updateJournals() async {
    final journals = await _getJournalByWeekUsecase.execute(DateTime.now());
    journals.fold(
      (failure) {
        LoggerService.e('Error updating journals: ${failure.message}');
      },
      (success) async {
        if (success.data['result'].isEmpty) {
          LoggerService.w('No journals found for the current week');
          emit(state.copyWith(journals: []));
        } else {
          emit(
            state.copyWith(
              streak: await _fetchStreak(),
              streakCount: await _calculateCurrentStreak(),
              totalEntries: await SqfliteService.count('journal'),
              journals: success.data['result'] as List<Journal>,
            ),
          );
        }
      },
    );
  }

  Future<List<int>> _fetchStreak() async {
    final now = DateTime.now();
    final today = now.day;
    final weekday = now.weekday;

    return SqfliteService.query(
          'journal',
          'CAST(timestamp AS INTEGER) >= '
              '${getStartOfWeek(now).millisecondsSinceEpoch}',
        )
        .then((value) {
          final List<int> streak = [-1, -1, -1, -1, -1, -1, -1];
          streak[weekday - 1] = 10;

          LoggerService.i('Fetched streak data: $value');

          for (final row in value) {
            final theDay = DateTime.fromMillisecondsSinceEpoch(
              int.parse(row['timestamp']),
            );
            final theDayDate = theDay.day;
            final theDayWeekday = theDay.weekday;

            if (theDayDate == today) {
              streak[theDayWeekday - 1] = 11;
            } else if (theDayDate < today) {
              streak[theDayWeekday - 1] = 1;
            }
          }

          LoggerService.i('Streak after processing: $streak');

          for (int i = 0; i < weekday; i++) {
            if (streak[i] == -1) {
              streak[i] = 0;
            }
          }

          LoggerService.i('Final streak: $streak');

          return streak;
        })
        .catchError((error) {
          LoggerService.e('Error fetching streak: $error');
          return state.streak;
        });
  }

  Future<int> _calculateCurrentStreak() async {
    try {
      final journalEntries = await SqfliteService.getAll('journal');

      if (journalEntries.isEmpty) {
        LoggerService.i('No journal entries found - streak is 0');
        return 0;
      }

      final Set<String> journalDates = {};

      for (final entry in journalEntries) {
        final timestamp = int.parse(entry['timestamp']);
        final date = DateTime.fromMillisecondsSinceEpoch(timestamp);
        final dateKey =
            '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
        journalDates.add(dateKey);
      }

      LoggerService.i('Found journals on ${journalDates.length} unique days');

      final now = DateTime.now();
      int streakCount = 0;
      DateTime currentDate = DateTime(
        now.year,
        now.month,
        now.day,
      ); // Start with today

      while (true) {
        final dateKey =
            '${currentDate.year}-'
            '${currentDate.month.toString().padLeft(2, '0')}'
            '-${currentDate.day.toString().padLeft(2, '0')}';

        if (journalDates.contains(dateKey)) {
          streakCount++;
        } else if (!(streakCount == 0 && currentDate.day == now.day)) {
          break;
        }

        if (streakCount > 367) {
          LoggerService.w('Streak calculation safety limit reached (367 days)');
          break;
        }

        currentDate = currentDate.subtract(const Duration(days: 1));
      }

      LoggerService.i('Current streak: $streakCount consecutive days');
      return streakCount;
    } catch (error) {
      LoggerService.e('Error calculating streak: $error');
      return 0;
    }
  }

  Future<int> _getDaysCount() async {
    final date =
        PrefService.getString(PreferencesKeys.firstOpen) ??
        DateTime.now().millisecondsSinceEpoch.toString();
    final firstOpenDate = DateTime.fromMillisecondsSinceEpoch(int.parse(date));
    final now = DateTime.now();
    final difference = now.difference(firstOpenDate).inDays;
    return difference < 0 ? 0 : difference;
  }

  Future<List<Journal>> _initJournals() async {
    final data = await _getJournalByWeekUsecase.execute(DateTime.now());

    return data.fold(
      (failure) {
        LoggerService.e('Error fetching journals: $failure');
        return <Journal>[];
      },
      (success) {
        if (success.data['result'].isEmpty) {
          LoggerService.w('No journals found for the current week');
          return <Journal>[];
        }
        return success.data['result'] as List<Journal>;
      },
    );
  }
}
