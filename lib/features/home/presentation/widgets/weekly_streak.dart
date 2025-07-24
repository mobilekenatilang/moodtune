part of '_widgets.dart';

class WeeklyStreak extends StatelessWidget {
  final List<int>? streak;
  const WeeklyStreak({super.key, required this.streak});

  @override
  Widget build(BuildContext context) {
    final List<String> daysOfWeek = [
      'Mon',
      'Tue',
      'Wed',
      'Thu',
      'Fri',
      'Sat',
      'Sun',
    ];

    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 360),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: daysOfWeek.asMap().entries.map((entry) {
          int index = entry.key;
          String day = entry.value;

          bool isPast = streak![index] == 0 || streak![index] == 1;
          bool isToday = streak![index] == 10 || streak![index] == 11;
          bool isCompleted = streak![index] % 10 == 1;

          return StreakItem(
            day: day,
            isPast: isPast,
            isToday: isToday,
            isCompleted: isCompleted,
          );
        }).toList(),
      ),
    );
  }
}
