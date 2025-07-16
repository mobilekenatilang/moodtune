part of '_widgets.dart';

class WeeklyStreak extends StatelessWidget {
  final DateTime? dateNow;
  const WeeklyStreak({super.key, required this.dateNow});

  @override
  Widget build(BuildContext context) {
    final List<String> daysOfWeek = [
      'Sen',
      'Sel',
      'Rab',
      'Kam',
      'Jum',
      'Sab',
      'Min',
    ];

    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 360),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: daysOfWeek.asMap().entries.map((entry) {
          int index = entry.key;
          String day = entry.value;

          // TODO: Ambil dari SharedPreferences
          bool isToday = index == dateNow!.weekday - 1;
          bool isPast = index < dateNow!.weekday - 1;
          bool isCompleted = (index < dateNow!.weekday - 1);

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
