part of '_widgets.dart';

class StreakItem extends StatelessWidget {
  final String day;
  final bool isPast;
  final bool isToday;
  final bool isCompleted;
  const StreakItem({
    super.key,
    required this.day,
    required this.isPast,
    required this.isToday,
    required this.isCompleted,
  });

  @override
  Widget build(BuildContext context) {
    final backColor = !isPast
        ? BaseColors.alabaster
        : isCompleted
        ? BaseColors.gold3
        : BaseColors.alabaster;

    final iconColor = isToday && isCompleted
        ? BaseColors.gold3
        : isCompleted
        ? BaseColors.alabaster
        : BaseColors.bronze4;

    return Container(
      padding: const EdgeInsets.fromLTRB(6, 6, 6, 8),
      decoration: BoxDecoration(
        color: isToday ? BaseColors.gold3 : Colors.transparent,
        borderRadius: BorderRadius.circular(64),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: backColor,
              shape: BoxShape.circle,
              border: Border.all(
                color: !isPast && !isToday
                    ? BaseColors.neutral60
                    : BaseColors.transparent,
                width: 0.5,
              ),
            ),
            child: Center(
              child: !isToday && !isPast
                  ? const SizedBox.shrink()
                  : SvgPicture.asset(
                      isCompleted ? Assets.svg.checkCircle : Assets.svg.xCircle,
                      width: 18,
                      height: 18,
                      colorFilter: ColorFilter.mode(iconColor, BlendMode.srcIn),
                    ),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            day,
            style: FontTheme.poppins12w600black().copyWith(
              color: isToday ? BaseColors.alabaster : BaseColors.neutral100,
            ),
          ),
        ],
      ),
    );
  }
}
