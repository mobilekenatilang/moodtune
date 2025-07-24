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
        streakCount: 21, // TODO: Actually fetch this from the database
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
              streakCount: 21, // TODO: Actually fetch this from the database
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
