part of '_pages.dart';

class AnalyzeJournal extends StatefulWidget {
  const AnalyzeJournal({
    super.key,
    required this.journal,
    this.fromHome = false,
  });

  final bool fromHome;
  final Journal journal;

  @override
  State<AnalyzeJournal> createState() => _AnalyzeJournalState();
}

class _AnalyzeJournalState extends State<AnalyzeJournal>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _backgroundController;
  late AnimationController _emojiController;
  late AnimationController _pulseController;

  late Animation<double> _fadeAnimation;
  late Animation<Color?> _backgroundAnimation;
  late Animation<double> _emojiScaleAnimation;
  late Animation<double> _pulseAnimation;

  late AnalyzeJournalUsecase _analyzeUsecase;
  late UpdateJournalUsecase _updateUsecase;
  late CalendarUsecases _calendarUsecases;

  bool _isLoading = true;
  bool _hasError = false;
  Analyzed? _analyzed;

  @override
  void initState() {
    super.initState();
    _analyzeUsecase = get.get<AnalyzeJournalUsecase>();
    _updateUsecase = get.get<UpdateJournalUsecase>();
    _calendarUsecases = get.get<CalendarUsecases>();

    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _backgroundController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _emojiController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
    );

    _backgroundAnimation =
        ColorTween(
          begin: _getBackgroundColor(),
          end: _getBackgroundColor().withValues(alpha: 0.8),
        ).animate(
          CurvedAnimation(
            parent: _backgroundController,
            curve: Curves.easeInOut,
          ),
        );

    _emojiScaleAnimation = Tween<double>(begin: 0.7, end: 1.1).animate(
      CurvedAnimation(parent: _emojiController, curve: Curves.elasticInOut),
    );

    _pulseAnimation = Tween<double>(begin: 0.95, end: 1.05).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _startLoadingAnimations();

    // Delay for animation to complete
    Future.delayed(const Duration(milliseconds: 500), _analyzeJournal);
  }

  void _startLoadingAnimations() {
    _fadeController.forward();
    _backgroundController.forward();
    _emojiController.repeat(reverse: true);
    _pulseController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _backgroundController.dispose();
    _emojiController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedBuilder(
        animation: Listenable.merge([
          _fadeAnimation,
          _backgroundAnimation,
          _emojiScaleAnimation,
          _pulseAnimation,
        ]),
        builder: (context, child) {
          return Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  _backgroundAnimation.value ?? _getBackgroundColor(),
                  (_backgroundAnimation.value ?? _getBackgroundColor())
                      .withValues(alpha: 0.6),
                  (_backgroundAnimation.value ?? _getBackgroundColor())
                      .withValues(alpha: 0.3),
                ],
                stops: const [0.0, 0.6, 1.0],
              ),
            ),
            child: SafeArea(
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: Column(
                  children: [
                    // Only show cancel button during loading or error states
                    if (_isLoading || _hasError)
                      Align(
                        alignment: Alignment.topRight,
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: TextButton(
                            onPressed: _handleClose,
                            style: TextButton.styleFrom(
                              foregroundColor: BaseColors.neutral90,
                              overlayColor: Colors.transparent,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                            ),
                            child: Text(
                              'Batal',
                              style: FontTheme.poppins14w500black().copyWith(
                                color: BaseColors.neutral90,
                              ),
                            ),
                          ),
                        ),
                      ),
                    Expanded(
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 32),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Transform.scale(
                                scale: _isLoading
                                    ? _emojiScaleAnimation.value *
                                          _pulseAnimation.value
                                    : 1.0,
                                child: Container(
                                  width: 140,
                                  height: 140,
                                  decoration: BoxDecoration(
                                    color: BaseColors.white.withValues(
                                      alpha: 0.95,
                                    ),
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withValues(
                                          alpha: 0.15,
                                        ),
                                        blurRadius: 25,
                                        offset: const Offset(0, 12),
                                      ),
                                      BoxShadow(
                                        color: _getBackgroundColor().withValues(
                                          alpha: 0.3,
                                        ),
                                        blurRadius: 15,
                                        offset: const Offset(0, 6),
                                      ),
                                    ],
                                  ),
                                  child: Center(
                                    child: Text(
                                      _getDisplayEmoji(),
                                      style: const TextStyle(fontSize: 72),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 40),
                              Text(
                                _getStatusText(),
                                style: FontTheme.poppins24w700black().copyWith(
                                  color: BaseColors.neutral100,
                                  fontSize: 26,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 16),
                              Text(
                                _getSubtitleText(),
                                style: FontTheme.poppins14w400black().copyWith(
                                  color: BaseColors.neutral90.withValues(
                                    alpha: 0.8,
                                  ),
                                  height: 1.6,
                                  fontSize: 15,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              if (_analyzed != null &&
                                  !_isLoading &&
                                  !_hasError) ...[
                                const SizedBox(height: 24),
                                Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.all(24),
                                  decoration: BoxDecoration(
                                    color: BaseColors.white.withValues(
                                      alpha: 0.95,
                                    ),
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(
                                      color: _getBackgroundColor().withValues(
                                        alpha: 0.3,
                                      ),
                                      width: 1,
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withValues(
                                          alpha: 0.08,
                                        ),
                                        blurRadius: 20,
                                        offset: const Offset(0, 8),
                                      ),
                                    ],
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.all(8),
                                            decoration: BoxDecoration(
                                              color: BaseColors.warning
                                                  .withValues(alpha: 0.1),
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                            child: Icon(
                                              Icons.auto_awesome,
                                              color: BaseColors.warning,
                                              size: 20,
                                            ),
                                          ),
                                          const SizedBox(width: 12),
                                          Text(
                                            'Saran',
                                            style:
                                                FontTheme.poppins14w600black()
                                                    .copyWith(
                                                      color:
                                                          BaseColors.neutral100,
                                                    ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 12),
                                      Text(
                                        _analyzed!.emotion.advice,
                                        style: FontTheme.poppins14w400black()
                                            .copyWith(height: 1.6),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 32),
                                SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton(
                                    onPressed: _handleContinue,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: BaseColors.gold3,
                                      foregroundColor: BaseColors.white,
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 18,
                                      ),
                                      elevation: 8,
                                      shadowColor: BaseColors.gold3.withValues(
                                        alpha: 0.4,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                    ),
                                    child: Text(
                                      'Lanjutkan',
                                      style: FontTheme.poppins14w600black()
                                          .copyWith(color: BaseColors.white),
                                    ),
                                  ),
                                ),
                              ],
                              if (_hasError) ...[
                                const SizedBox(height: 40),
                                SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton.icon(
                                    onPressed: _retryAnalysis,
                                    icon: Icon(
                                      Icons.refresh_rounded,
                                      color: BaseColors.white,
                                      size: 22,
                                    ),
                                    label: Text(
                                      'Coba Lagi',
                                      style: FontTheme.poppins14w600black()
                                          .copyWith(color: BaseColors.white),
                                    ),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: BaseColors.gold3,
                                      foregroundColor: BaseColors.white,
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 24,
                                      ),
                                      elevation: 8,
                                      shadowColor: BaseColors.gold3.withValues(
                                        alpha: 0.4,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 16),
                                TextButton(
                                  onPressed: _handleClose,
                                  style: TextButton.styleFrom(
                                    foregroundColor: BaseColors.neutral90
                                        .withValues(alpha: 0.7),
                                    overlayColor: Colors.transparent,
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 12,
                                    ),
                                  ),
                                  child: Text(
                                    'Kembali',
                                    style: FontTheme.poppins14w500black()
                                        .copyWith(
                                          color: BaseColors.neutral90
                                              .withValues(alpha: 0.7),
                                        ),
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
          );
        },
      ),
    );
  }

  String _getDisplayEmoji() {
    if (_hasError) return '😔';
    if (_isLoading) return '🤔';
    return _analyzed?.emotion.emoji ?? '✨';
  }

  String _getStatusText() {
    if (_hasError) return 'Oops, terjadi kesalahan';
    if (_isLoading) return 'Menganalisis jurnal...';
    return 'Analisis selesai!';
  }

  String _getSubtitleText() {
    if (_hasError) {
      return 'Tidak dapat menganalisis jurnal saat ini. Silakan coba lagi.';
    }
    if (_isLoading) {
      return 'Mohon tunggu sebentar, kami sedang memproses jurnal Anda.';
    }
    return 'Berikut adalah hasil analisis dan saran untuk Anda.';
  }

  Color _getBackgroundColor() {
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
        return BaseColors.alabaster;
    }
  }

  Future<void> _analyzeJournal() async {
    try {
      final analysisResult = await Future.wait([
        _analyzeUsecase.execute(widget.journal),
        Future.delayed(
          const Duration(milliseconds: 2500),
        ), // Minimum 2.5s loading
      ]);

      final result = analysisResult[0];

      result.fold(
        (failure) {
          setState(() {
            _hasError = true;
            _isLoading = false;
          });
          _emojiController.stop();
          _pulseController.stop();
        },
        (success) {
          final analyzed = success.data['result'] as Analyzed;

          setState(() {
            _analyzed = analyzed;
            _isLoading = false;
          });
          _emojiController.stop();
          _pulseController.stop();
          _emojiController.reset();
          _pulseController.reset();
        },
      );
    } catch (e) {
      setState(() {
        _hasError = true;
        _isLoading = false;
      });
      _emojiController.stop();
      _pulseController.stop();
    }
  }

  void _retryAnalysis() {
    setState(() {
      _isLoading = true;
      _hasError = false;
      _analyzed = null;
    });

    _emojiController.repeat(reverse: true);
    _pulseController.repeat(reverse: true);
    _analyzeJournal();
  }

  void _handleClose() {
    _fadeController.reverse().then((_) {
      nav.pop();
    });
  }

  void _handleContinue() {
    _fadeController.reverse().then((_) async {
      final updatedJournal = widget.journal.copyWith(
        mood: Mood.fromString(
          _analyzed?.emotion.label ?? widget.journal.mood.name,
        ),
        advice: _analyzed?.emotion.advice ?? '',
        playlist: _analyzed?.music ?? widget.journal.playlist,
      );

      final updateResult = await _updateUsecase.execute(updatedJournal);

      updateResult.fold(
        (failure) {
          LoggerService.e('Failed to update journal: ${failure.message}');
        },
        (success) {
          LoggerService.i('Journal updated successfully with analysis');
        },
      );

      final now = DateTime.now();
      final entry = DailyMoodEntry(
        timestamp: now,
        label:
            _analyzed?.emotion.label.toLowerCase() ?? updatedJournal.mood.name,
        emoji: _analyzed?.emotion.emoji ?? '🙂',
      );

      final saveRes = await _calendarUsecases.execute({'save': entry});
      saveRes.fold(
        (fail) => LoggerService.e('Save day mood failed: ${fail.message}'),
        (parsed) {
          final saved = parsed.data['result'] as MonthMoodSummaryModel;
          LoggerService.i('Day mood saved in month ${saved.month}');
        },
      );

      get.get<HomepageJournalCubit>().updateJournals();
      if (!widget.fromHome) {
        get.get<JournalListCubit>().refreshAll();
      }

      nav.pop(updatedJournal);
    });
  }
}
