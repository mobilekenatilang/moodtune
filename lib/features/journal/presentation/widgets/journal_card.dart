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
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          color: BaseColors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: BaseColors.gray5.withValues(alpha: 0.8)),
          boxShadow: [
            BoxShadow(
              color: BaseColors.gray5,
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    isPreview
                        ? '${getFormattedDate(date)} - ${getTime(date)}'
                        : getFormattedDate(date),
                    style: FontTheme.poppins10w500black().copyWith(
                      color: BaseColors.gray1,
                    ),
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
                    style: FontTheme.poppins10w400black().copyWith(height: 1.3),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 20), // just in case...
            CircleAvatar(
              radius: 16,
              backgroundColor: _backgroundColor().withValues(alpha: 0.8),
              child: Text(
                journal.mood.emoji,
                style: const TextStyle(fontSize: 14),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _backgroundColor() {
    switch (journal.mood) {
      case Mood.happy:
        return const Color(0xFFF9EEB0);
      case Mood.calm:
        return const Color(0xFFD5EBF6);
      case Mood.sad:
        return const Color(0xFFD0D3DA);
      case Mood.angry:
        return const Color(0xFFF2B4C3);
      case Mood.anxious:
        return const Color(0xFFF8D8AF);
      case Mood.tired:
        return const Color(0xFFBEBCE1);
      default:
        return BaseColors.gray5; // Unknown mood
    }
  }
}
