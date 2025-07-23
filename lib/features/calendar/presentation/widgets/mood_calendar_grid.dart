part of '_widgets.dart';

class MoodCalendarGrid extends StatelessWidget {
  final DateTime currentMonth;
  final MonthMoodSummaryModel? summary;

  const MoodCalendarGrid({
    super.key,
    required this.currentMonth,
    required this.summary,
  });

  @override
  Widget build(BuildContext context) {
    // Header hari
    final header = ['Su', 'Mo', 'Tu', 'We', 'Th', 'Fr', 'Sa'];

    // Hitung offset hari pertama & jumlah hari
    final firstDayOfMonth = DateTime(currentMonth.year, currentMonth.month, 1);
    final daysInMonth = DateUtils.getDaysInMonth(
      currentMonth.year,
      currentMonth.month,
    );
    final firstWeekday = firstDayOfMonth.weekday % 7; // Flutter: Mon=1…Sun=7

    // Map DayMoodModel ke emoji
    final moodMap = {for (final d in summary?.days ?? []) d.date.day: d.emoji};

    List<Widget> cells = [];

    // Header hari
    cells.addAll(
      header.map(
        (e) => Center(child: Text(e, style: FontTheme.poppins12w600black())),
      ),
    );

    // Offset kosong sebelum tanggal 1
    for (int i = 0; i < firstWeekday; i++) {
      cells.add(const SizedBox.shrink());
    }

    // Tanggal dengan emoji atau angka biasa
    for (int day = 1; day <= daysInMonth; day++) {
      final date = DateTime(currentMonth.year, currentMonth.month, day);
      final emoji = moodMap[day];
      final isToday = DateUtils.isSameDay(date, DateTime.now());

      cells.add(MoodCell(date: date, emoji: emoji, isToday: isToday));
    }

    final screenWidth = MediaQuery.of(context).size.width;
    final cellWidth = screenWidth / 9; 
    final cellHeight = cellWidth;

    return GridView.count(
      crossAxisCount: 7,
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      childAspectRatio: cellWidth / cellHeight,
      children: cells,
    );
  }
}
