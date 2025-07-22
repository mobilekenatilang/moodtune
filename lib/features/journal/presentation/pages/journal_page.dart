part of '_pages.dart';

class JournalPage extends StatefulWidget {
  const JournalPage({super.key, required this.journal});

  final Journal journal;

  @override
  State<JournalPage> createState() => _JournalPageState();
}

class _JournalPageState extends State<JournalPage> {
  late DeleteJournalUsecase _deleteJournalUsecase;
  late Journal _journal;

  @override
  void initState() {
    super.initState();
    _deleteJournalUsecase = get.get<DeleteJournalUsecase>();
    _journal = widget.journal;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _backgroundColor(),
      body: SafeArea(
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
                        kBottomNavigationBarHeight -
                        48,
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
                                  _journal.mood.emoji,
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
                                      int.parse(_journal.timestamp),
                                    ),
                                  ),
                                  style: FontTheme.poppins12w600black()
                                      .copyWith(fontSize: 13),
                                ),
                                const SizedBox(height: 1),
                                Text(
                                  _journal.mood == Mood.unknown
                                      ? 'Hmm..'
                                      : _journal.mood.name.capitalize(),
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
                          _journal.title,
                          style: FontTheme.poppins22w700black(),
                        ),
                        const SizedBox(height: 14),
                        Text(
                          _journal.content,
                          style: FontTheme.poppins14w400black().copyWith(
                            height: 1.5,
                          ),
                        ),
                        if (_journal.advice?.isNotEmpty == true) ...[
                          const SizedBox(height: 20),
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: BaseColors.gray3,
                                width: 0.5,
                              ),
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
                                    Text(
                                      'Saran',
                                      style: FontTheme.poppins14w600black(),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  _journal.advice!,
                                  style: FontTheme.poppins12w400black()
                                      .copyWith(
                                        height: 1.4,
                                        color: BaseColors.gray2,
                                      ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: BaseColors.white,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(32),
            topRight: Radius.circular(32),
          ),
          border: Border.all(color: BaseColors.gray4, width: 0.5),
          boxShadow: [
            BoxShadow(
              color: BaseColors.gray5.withValues(alpha: 0.8),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () => _showDeleteDialog(),
                icon: Icon(
                  LucideIcons.trash2,
                  color: BaseColors.error,
                  size: 20,
                ),
                label: Text(
                  'Delete',
                  style: FontTheme.poppins14w600black().copyWith(
                    color: BaseColors.error,
                    fontSize: 15,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: BaseColors.white,
                  side: BorderSide(color: BaseColors.error, width: 1),
                  padding: const EdgeInsets.all(20),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
            if (_journal.advice?.isEmpty ?? true) ...[
              const SizedBox(width: 14),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => _navigateToAnalyze(),
                  icon: Icon(
                    LucideIcons.sparkles,
                    color: BaseColors.white,
                    size: 20,
                  ),
                  label: Text(
                    'Analisis',
                    style: FontTheme.poppins14w600black().copyWith(
                      color: BaseColors.white,
                      fontSize: 15,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: BaseColors.gold3,
                    padding: const EdgeInsets.all(20),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
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
          onPressed: _journal.advice?.isEmpty ?? true
              ? () => nav.pushReplacement(
                  AddJournal(journal: _journal, isEditing: true),
                )
              : () {
                  LoggerService.i('Music button pressed');
                },
          icon: Icon(
            _journal.advice?.isEmpty ?? true
                ? LucideIcons.edit
                : LucideIcons.headphones,
            size: 20,
            color: BaseColors.neutral100,
          ),
          splashColor: BaseColors.transparent,
          highlightColor: BaseColors.transparent,
        ),
      ],
    );
  }

  void _showDeleteDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Dialog(
          backgroundColor: BaseColors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(32, 32, 32, 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: BaseColors.error.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    LucideIcons.trash2,
                    color: BaseColors.error,
                    size: 30,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'Hapus Jurnal?',
                  style: FontTheme.poppins18w700black(),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                Text(
                  'Jurnal yang dihapus tidak dapat dikembalikan.',
                  style: FontTheme.poppins14w400black().copyWith(
                    color: BaseColors.gray1,
                    height: 1.4,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                Column(
                  children: [
                    SizedBox(
                      width: double.infinity,
                      child: TextButton(
                        onPressed: () async {
                          nav.pop();
                          await _deleteJournal();
                        },
                        style: TextButton.styleFrom(
                          backgroundColor: BaseColors.error,
                          foregroundColor: BaseColors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          'Ya, Hapus',
                          style: FontTheme.poppins14w600black().copyWith(
                            color: BaseColors.white,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      width: double.infinity,
                      child: TextButton(
                        onPressed: () => nav.pop(),
                        style: TextButton.styleFrom(
                          foregroundColor: BaseColors.neutral90,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          'Batal',
                          style: FontTheme.poppins14w600black(),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _deleteJournal() async {
    final result = await _deleteJournalUsecase.execute(_journal.timestamp);

    result.fold(
      (failure) {
        showErrorSnackBar(
          context,
          'Failed to delete journal: ${failure.message}',
        );
      },
      (success) {
        // Navigate back and show success message
        nav.pop();
        showSuccessSnackBar(context, 'Journal deleted successfully');
        get.get<HomepageJournalCubit>().updateJournals();
      },
    );
  }

  void _navigateToAnalyze() {
    nav.push(AnalyzeJournal(journal: _journal)).then((result) {
      if (result != null && result is Journal) {
        setState(() {
          _journal = result;
        });
        get.get<HomepageJournalCubit>().updateJournals();
      }
    });
  }

  Color _backgroundColor() {
    switch (_journal.mood) {
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
