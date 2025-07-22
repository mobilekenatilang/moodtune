part of '_cubit.dart';

class HomepageJournalState extends Equatable {
  final List<int> streak;
  final int streakCount;
  final int totalEntries;
  final int daysCount;
  final List<Journal> journals;

  const HomepageJournalState({
    required this.streak,
    required this.streakCount,
    required this.totalEntries,
    required this.daysCount,
    this.journals = const [],
  });

  HomepageJournalState copyWith({
    List<int>? streak,
    int? streakCount,
    int? totalEntries,
    int? daysCount,
    List<Journal>? journals,
  }) {
    return HomepageJournalState(
      streak: streak ?? this.streak,
      streakCount: streakCount ?? this.streakCount,
      totalEntries: totalEntries ?? this.totalEntries,
      daysCount: daysCount ?? this.daysCount,
      journals: journals ?? this.journals,
    );
  }

  @override
  List<Object> get props => [
    streak,
    streakCount,
    totalEntries,
    daysCount,
    journals,
  ];
}

//////////////////////////////////////////
//  NOTE: Integer on streak:            //
//  0 = No entry, past                  //
//  1 = Entry, past                     //
//  2 = No entry, today                 //
//  10 = No entry, today                //
//  11 = Entry, today                   //
//  -1 = Future date (not yet reached)  //
//////////////////////////////////////////
