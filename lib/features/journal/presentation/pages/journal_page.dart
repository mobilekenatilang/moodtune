part of '_pages.dart';

class JournalPage extends StatefulWidget {
  const JournalPage({super.key, required this.journal});

  final Journal journal;

  @override
  State<JournalPage> createState() => _JournalPageState();
}

class _JournalPageState extends State<JournalPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _backgroundColor(),
      body: Stack(
        children: [
          SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  _buildAppbar(),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                    child: Container(
                      width: double.infinity,
                      constraints: BoxConstraints(
                        minHeight:
                            MediaQuery.of(context).size.height -
                            MediaQuery.of(context).padding.top -
                            kToolbarHeight -
                            16,
                      ),
                      decoration: BoxDecoration(
                        color: BaseColors.white,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(32),
                          topRight: Radius.circular(32),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Container(
                                  width: 42,
                                  height: 42,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: BaseColors.gray5,
                                  ),
                                  child: Center(
                                    child: Text(
                                      widget.journal.mood.emoji,
                                      style: const TextStyle(fontSize: 20),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      getFormattedDate(
                                        DateTime.fromMillisecondsSinceEpoch(
                                          int.parse(widget.journal.timestamp),
                                        ),
                                      ),
                                      style: FontTheme.poppins12w600black()
                                          .copyWith(fontSize: 13),
                                    ),
                                    const SizedBox(height: 1),
                                    Text(
                                      widget.journal.mood == Mood.unknown
                                          ? 'Hmm..'
                                          : widget.journal.mood.name
                                                .capitalize(),
                                      style: FontTheme.poppins12w600black()
                                          .copyWith(
                                            color: BaseColors.gray2,
                                            fontSize: 11,
                                          ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),
                            Text(
                              widget.journal.title,
                              style: FontTheme.poppins22w700black(),
                            ),
                            const SizedBox(height: 14),
                            Text(
                              widget.journal.content,
                              style: FontTheme.poppins14w400black().copyWith(
                                height: 1.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (widget.journal.advice?.isNotEmpty == true)
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                margin: const EdgeInsets.all(16),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: BaseColors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: BaseColors.gray3.withValues(alpha: 0.2),
                      blurRadius: 8,
                      offset: const Offset(0, -2),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.lightbulb_outline,
                          color: BaseColors.warning,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Text('Advice', style: FontTheme.poppins14w600black()),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      widget.journal.advice!,
                      style: FontTheme.poppins14w400black().copyWith(
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          if (widget.journal.playlist?.isNotEmpty == true)
            Positioned(
              bottom: widget.journal.advice?.isNotEmpty == true ? 120 : 24,
              right: 24,
              child: FloatingActionButton(
                onPressed: () {
                  // TODO: Navigate to playlist page
                },
                backgroundColor: _backgroundColor(),
                child: Icon(Icons.music_note, color: BaseColors.neutral90),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildAppbar() {
    return AppBar(
      centerTitle: true,
      scrolledUnderElevation: 0,
      elevation: 0,
      actionsPadding: EdgeInsets.fromLTRB(0, 8, 8, 0),
      title: Column(
        children: [
          const SizedBox(height: 8),
          Text(
            'Jurnal',
            style: FontTheme.poppins14w600black().copyWith(fontSize: 15),
          ),
        ],
      ),
      backgroundColor: _backgroundColor(),
      leading: Padding(
        padding: const EdgeInsets.only(top: 8),
        child: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: () => nav.pop(),
          splashColor: BaseColors.transparent,
          highlightColor: BaseColors.transparent,
        ),
      ),
      actions: [
        IconButton(
          onPressed: widget.journal.advice?.isNotEmpty == true
              ? null
              : () => nav.pushReplacement(
                  AddJournal(journal: widget.journal, isEditing: true),
                ),
          icon: Icon(
            LucideIcons.edit,
            size: 20,
            color: widget.journal.advice?.isNotEmpty == true
                ? BaseColors.gray3
                : BaseColors.neutral100,
          ),
          splashColor: BaseColors.transparent,
          highlightColor: BaseColors.transparent,
        ),
      ],
    );
  }

  Color _backgroundColor() {
    switch (widget.journal.mood) {
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
        return BaseColors.alabaster; // Unknown mood
    }
  }
}
