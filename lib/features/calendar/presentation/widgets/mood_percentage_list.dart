part of '_widgets.dart';

class MoodPercentageList extends StatelessWidget {
  final MonthMoodSummaryModel? summary;

  const MoodPercentageList({super.key, required this.summary});

  @override
  Widget build(BuildContext context) {
    if (summary == null || summary!.days.isEmpty) {
      return const SizedBox.shrink();
    }

    final total = summary!.days.length.toDouble();
    final sorted = summary!.labelCount.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Average Mood',
          style: FontTheme.poppins16w500black().copyWith(
            color: BaseColors.neutral100,
          ),
        ),
        const SizedBox(height: 12),
        ...sorted.map((e) {
          final percent = e.value / total;
          final emoji = _emojiForLabel(e.key);

          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: Row(
              children: [
                SizedBox(
                  width:
                      60, 
                  child: Text(e.key, style: FontTheme.poppins14w500black()),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: LinearProgressIndicator(
                      value: percent,
                      minHeight: 14,
                      color: BaseColors.gold3,
                      backgroundColor: BaseColors.gold3.withOpacity(0.2),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  '${(percent * 100).toStringAsFixed(0)}%',
                  style: FontTheme.poppins12w500black(),
                ),
                const SizedBox(width: 8),
                Text(emoji, style: const TextStyle(fontSize: 20)),
              ],
            ),
          );
        }),
      ],
    );
  }

  /// Fungsi pemetaan label → emoji
  String _emojiForLabel(String label) {
    const emojiMap = {
      'happy': '😄',
      'calm': '😌',
      'sad': '😔',
      'angry': '😡',
      'anxious': '😰',
      'tired': '😴',
    };
    return emojiMap[label.toLowerCase()] ?? '🙂';
  }
}
