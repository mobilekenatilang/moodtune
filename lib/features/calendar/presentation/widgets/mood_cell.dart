part of '_widgets.dart';

class MoodCell extends StatelessWidget {
  final DaySummaryModel? daySummary;
  final DateTime date;
  final bool isToday;

  const MoodCell({
    super.key,
    required this.date,
    this.daySummary,
    required this.isToday,
  });

  @override
  Widget build(BuildContext context) {
    final emoji = daySummary?.entries.isNotEmpty == true
        ? daySummary!.entries.last.emoji
        : null;
    final display = emoji ?? date.day.toString();
    final screenWidth = MediaQuery.of(context).size.width;
    final circleSize = screenWidth / 12;

    final fontSize = emoji != null
        ? circleSize *
              0.8 
        : circleSize * 0.5; 

    return GestureDetector(
      onTap: (daySummary?.entries.isNotEmpty == true)
          ? () => _showDayDetail(context, daySummary!)
          : null,
      child: Container(
        width: circleSize,
        height: circleSize,
        margin: const EdgeInsets.all(2),
        decoration: BoxDecoration(
          color: isToday ? BaseColors.gold3 : BaseColors.white,
          shape: BoxShape.circle,
          border: Border.all(color: BaseColors.neutral40, width: 0.5),
        ),
        child: Center(
          child: Text(display, style: TextStyle(fontSize: fontSize)),
        ),
      ),
    );
  }

  void _showDayDetail(BuildContext context, DaySummaryModel summary) {
    showModalBottomSheet(
      context: context,
      backgroundColor: BaseColors.alabaster,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Your moods on ${DateFormat.yMMMMd('en_US').format(date)}',
              style: FontTheme.poppins16w500black(),
            ),
            const SizedBox(height: 12),
            ...summary.entries.map((e) {
              final time = TimeOfDay.fromDateTime(e.timestamp).format(context);
              return ListTile(
                leading: Text(e.emoji, style: const TextStyle(fontSize: 24)),
                title: Text(
                  e.label.capitalize(),
                  style: FontTheme.poppins14w600black(),
                ),
                trailing: Text(time, style: FontTheme.poppins12w400black2()),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }
}
