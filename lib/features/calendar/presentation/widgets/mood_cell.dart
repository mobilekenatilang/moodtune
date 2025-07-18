part of '_widgets.dart';

class MoodCell extends StatelessWidget {
  final DateTime date;
  final String? emoji;
  final bool isToday;

  const MoodCell({
    super.key,
    required this.date,
    this.emoji,
    required this.isToday,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    final circleSize = screenWidth < 600
        ? screenWidth /
              12 
        : screenWidth / 20; 

    final display = emoji ?? date.day.toString();
    final backColor = isToday ? BaseColors.gold3 : BaseColors.white;
    final textColor = isToday ? BaseColors.white : BaseColors.neutral100;

    return Padding(
      padding: const EdgeInsets.all(2),
      child: Container(
        width: circleSize,
        height: circleSize,
        decoration: BoxDecoration(
          color: backColor,
          shape: BoxShape.circle,
          border: Border.all(color: BaseColors.neutral40, width: 0.5),
        ),
        child: Center(
          child: emoji != null
              ? Text(
                  emoji!,
                  style: TextStyle(
                    fontSize:
                        circleSize * 0.9,
                  ),
                )
              : Text(
                  display,
                  style: FontTheme.poppins14w600black().copyWith(
                    fontSize: screenWidth < 600
                        ? 14
                        : 12, 
                    color: textColor,
                  ),
                ),
        ),
      ),
    );
  }
}
