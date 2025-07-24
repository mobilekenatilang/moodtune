part of '_widgets.dart';

class StatsItem extends StatelessWidget {
  final String label;
  final int number;
  const StatsItem({super.key, required this.label, required this.number});

  @override
  Widget build(BuildContext context) {
    String numberFinal = '0';

    if (label == 'Streak' && number == 367) {
      numberFinal = '1 year+';
    } else {
      numberFinal = number.toString();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: FontTheme.poppins12w600black().copyWith(
            color: BaseColors.gold3,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 2),
        Text(numberFinal, style: FontTheme.poppins22w700black()),
      ],
    );
  }
}
