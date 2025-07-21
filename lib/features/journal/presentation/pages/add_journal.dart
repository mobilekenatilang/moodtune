part of '_pages.dart';

class AddJournal extends StatefulWidget {
  const AddJournal({super.key, this.isEditing = false, this.journal});

  final bool isEditing;
  final Journal? journal; // Optional journal for editing

  @override
  State<AddJournal> createState() => _AddJournalState();
}

class _AddJournalState extends State<AddJournal> {
  late final CreateJournalUsecase _createJournalUsecase;
  late final UpdateJournalUsecase _updateJournalUsecase;

  late final TextEditingController _titleController;
  late final TextEditingController _contentController;
  late bool _isSaveEnabled;

  @override
  void initState() {
    super.initState();
    _createJournalUsecase = get.get<CreateJournalUsecase>();
    _updateJournalUsecase = get.get<UpdateJournalUsecase>();

    _titleController = TextEditingController();
    _contentController = TextEditingController();

    if (widget.isEditing && widget.journal != null) {
      _titleController.text = widget.journal!.title;
      _contentController.text = widget.journal!.content;
    }

    // Listen to text changes to update save button state
    _titleController.addListener(_updateSaveButtonState);
    _contentController.addListener(_updateSaveButtonState);

    _isSaveEnabled =
        _titleController.text.trim().isNotEmpty &&
        _contentController.text.trim().isNotEmpty;
  }

  void _updateSaveButtonState() {
    final hasTitle = _titleController.text.trim().isNotEmpty;
    final hasContent = _contentController.text.trim().isNotEmpty;

    setState(() {
      _isSaveEnabled = hasTitle && hasContent;
    });
  }

  @override
  void dispose() {
    _titleController.removeListener(_updateSaveButtonState);
    _contentController.removeListener(_updateSaveButtonState);
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          _titleController.text.trim().isEmpty &&
                  _contentController.text.trim().isEmpty
              ? nav.pop()
              : _showBackConfirmationDialog();
        }
      },
      child: Scaffold(
        backgroundColor: BaseColors.alabaster,
        appBar: _buildAppbar(),
        body: Padding(
          padding: const EdgeInsets.only(top: 24),
          child: Container(
            decoration: BoxDecoration(
              color: BaseColors.white,
              borderRadius: BorderRadius.circular(48),
              border: Border.all(color: BaseColors.gray4, width: 0.5),
              boxShadow: [
                BoxShadow(
                  color: BaseColors.gray3.withValues(alpha: 0.1),
                  blurRadius: 20,
                  offset: const Offset(0, -10),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(32, 28, 32, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Judul ceritamu", style: FontTheme.poppins14w600black()),
                  const SizedBox(height: 8),
                  Container(
                    decoration: BoxDecoration(
                      color: BaseColors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: BaseColors.gray4, width: 1),
                    ),
                    child: TextFormField(
                      controller: _titleController,
                      style: FontTheme.roboto14w400black(),
                      cursorColor: BaseColors.neutral70,
                      enableInteractiveSelection: true,
                      contextMenuBuilder: (context, editableTextState) {
                        return AdaptiveTextSelectionToolbar.editable(
                          clipboardStatus: ClipboardStatus.pasteable,
                          onCopy: () => editableTextState.copySelection(
                            SelectionChangedCause.toolbar,
                          ),
                          onCut: () => editableTextState.cutSelection(
                            SelectionChangedCause.toolbar,
                          ),
                          onPaste: () => editableTextState.pasteText(
                            SelectionChangedCause.toolbar,
                          ),
                          onSelectAll: () => editableTextState.selectAll(
                            SelectionChangedCause.toolbar,
                          ),
                          onLookUp: null,
                          onSearchWeb: null,
                          onShare: null,
                          onLiveTextInput: null,
                          anchors: editableTextState.contextMenuAnchors,
                        );
                      },
                      decoration: InputDecoration(
                        hintText: "Judul Ceritamu",
                        hintStyle: FontTheme.roboto14w400black().copyWith(
                          color: BaseColors.gray3,
                        ),
                        border: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        contentPadding: const EdgeInsets.all(12),
                        counterText: "", // This removes the counter
                      ),
                      maxLength: 50,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    "Apa yang kamu rasakan sekarang?",
                    style: FontTheme.poppins14w600black(),
                  ),
                  const SizedBox(height: 8),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: BaseColors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: BaseColors.gray4, width: 1),
                      ),
                      child: TextFormField(
                        controller: _contentController,
                        style: FontTheme.roboto14w400black(),
                        cursorColor: BaseColors.neutral70,
                        maxLines: null,
                        expands: true,
                        textAlignVertical: TextAlignVertical.top,
                        enableInteractiveSelection: true,
                        decoration: InputDecoration(
                          hintText: "Apa yang kamu rasakan?",
                          hintStyle: FontTheme.roboto14w400black().copyWith(
                            color: BaseColors.gray3,
                          ),
                          border: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          contentPadding: const EdgeInsets.all(16),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  AppBar _buildAppbar() {
    return AppBar(
      centerTitle: true,
      scrolledUnderElevation: 0,
      elevation: 0,
      actionsPadding: EdgeInsets.fromLTRB(0, 8, 8, 0),
      title: Column(
        children: [
          const SizedBox(height: 8),
          Text(
            widget.isEditing ? 'Edit Jurnal' : 'Tambah Jurnal',
            style: FontTheme.poppins14w600black().copyWith(fontSize: 15),
          ),
          const SizedBox(height: 2),
          Text(
            getFormattedDate(DateTime.now()),
            style: FontTheme.poppins10w500black().copyWith(
              color: BaseColors.gray2,
              fontSize: 11,
            ),
          ),
        ],
      ),
      backgroundColor: BaseColors.alabaster,
      leading: Padding(
        padding: const EdgeInsets.only(top: 8),
        child: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: () =>
              _titleController.text.trim().isEmpty &&
                  _contentController.text.trim().isEmpty
              ? nav.pop()
              : _showBackConfirmationDialog(),
          splashColor: BaseColors.transparent,
          highlightColor: BaseColors.transparent,
        ),
      ),
      actions: [
        IconButton(
          icon: Icon(
            Icons.check_rounded,
            color: _isSaveEnabled ? BaseColors.neutral90 : BaseColors.gray3,
          ),
          onPressed: _isSaveEnabled
              ? () {
                  try {
                    final journal = _saveJournal();
                    nav.pushReplacement(JournalPage(journal: journal));
                    showSuccessSnackBar(context, 'Jurnal berhasil disimpan!');
                  } catch (e) {
                    // Handle any errors that might occur during saving
                    LoggerService.e('Failed to save journal: ${e.toString()}');
                    showErrorSnackBar(context, 'Gagal menyimpan jurnal..');
                  }
                }
              : null,
          splashColor: BaseColors.transparent,
          highlightColor: BaseColors.transparent,
        ),
      ],
    );
  }

  void _showBackConfirmationDialog() {
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
                    color: BaseColors.warning.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.warning_rounded,
                    color: BaseColors.warning,
                    size: 30,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'Batalkan ${widget.isEditing ? 'Edit' : 'Tambah'} Jurnal?',
                  style: FontTheme.poppins18w700black(),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                Text(
                  'Perubahan yang belum disimpan akan hilang dan tidak dapat dikembalikan.',
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
                        onPressed: () {
                          nav.pop();
                          nav.pop();
                        },
                        style: TextButton.styleFrom(
                          backgroundColor: BaseColors.danger,
                          foregroundColor: BaseColors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          'Ya, Batalkan',
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
                          'Gajadi deh',
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

  // TODO: Implement the actual saving logic here
  Journal _saveJournal() {
    if (_isSaveEnabled) {
      final Journal journal;

      if (widget.isEditing && widget.journal != null) {
        journal = widget.journal!.copyWith(
          title: _titleController.text,
          content: _contentController.text,
        );
        _updateJournalUsecase.execute(journal);
      } else {
        journal = Journal(
          title: _titleController.text,
          content: _contentController.text,
          timestamp: DateTime.now().millisecondsSinceEpoch.toString(),
          mood: Mood.unknown,
        );
        _createJournalUsecase.execute(journal);
      }

      get.get<HomepageJournalCubit>().updateJournals();

      return journal;
    } else {
      throw ArgumentError('Cannot save journal with empty title or content');
    }
  }
}
