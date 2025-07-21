part of '_widgets.dart';

class JournalCard extends StatelessWidget {
  const JournalCard({
    super.key,
    required this.journal,
    this.isPreview = false,
    required this.onTap,
  });

  final Journal journal;
  final bool isPreview;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final date = DateTime.fromMillisecondsSinceEpoch(
      int.parse(journal.timestamp),
    );

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: BaseColors.alabaster,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: BaseColors.gray4.withValues(alpha: 0.5)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  isPreview
                      ? '${getFormattedDate(date)} - ${getTime(date)}'
                      : getFormattedDate(date),
                  style: FontTheme.poppins10w500black().copyWith(
                    color: BaseColors.gray2,
                  ),
                ),
                Text(journal.mood.emoji, style: const TextStyle(fontSize: 12)),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              journal.title,
              style: FontTheme.poppins12w600black(),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            Text(
              journal.content,
              style: FontTheme.poppins10w400black().copyWith(
                color: BaseColors.gray2,
                height: 1.3,
              ),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
