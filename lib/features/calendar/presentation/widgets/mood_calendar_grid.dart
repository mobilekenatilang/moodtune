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
    // 1) Header hari
    final header = ['Su', 'Mo', 'Tu', 'We', 'Th', 'Fr', 'Sa'];

    // 2) Hitung offset hari pertama & jumlah hari
    final firstDayOfMonth = DateTime(currentMonth.year, currentMonth.month, 1);
    final daysInMonth = DateUtils.getDaysInMonth(
      currentMonth.year,
      currentMonth.month,
    );
    final offset = firstDayOfMonth.weekday % 7; // Mon=1…Sun=7 → Sun=0

    // 3) Map tanggal → DaySummaryModel
    final dayMap = {for (final d in summary?.days ?? []) d.date.day: d};

    // 4) Bangun list sel (header + tanggal)
    final List<Widget> cells = [];

    // header hari
    cells.addAll(
      header.map(
        (e) => Center(child: Text(e, style: FontTheme.poppins12w600black())),
      ),
    );

    // offset kosong
    for (int i = 0; i < offset; i++) {
      cells.add(const SizedBox.shrink());
    }

    // tanggal dengan emoji last mood
    for (int day = 1; day <= daysInMonth; day++) {
      final date = DateTime(currentMonth.year, currentMonth.month, day);
      final daySummary = dayMap[day];
      final isToday = DateUtils.isSameDay(date, DateTime.now());

      cells.add(MoodCell(date: date, daySummary: daySummary, isToday: isToday));
    }

    // 5) Render grid
    return GridView.count(
      crossAxisCount: 7,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: cells,
    );
  }
}
