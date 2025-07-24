part of '_widgets.dart';

class MoodPercentageList extends StatefulWidget {
  final MonthMoodSummaryModel? summary;

  const MoodPercentageList({super.key, required this.summary});

  @override
  State<MoodPercentageList> createState() => _MoodPercentageListState();
}

class _MoodPercentageListState extends State<MoodPercentageList> {
  int touchedIndex = -1;

  @override
  Widget build(BuildContext context) {
    final summary = widget.summary;
    if (summary == null || summary.days.isEmpty) {
      return const SizedBox.shrink();
    }

    // ===== MONTHLY =====
    final monthlyCounts = Map<String, int>.from(summary.labelCount);
    final monthlyTotal = monthlyCounts.values
        .fold<int>(0, (a, b) => a + b)
        .toDouble();

    final sortedMonthly = monthlyCounts.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    final monthlySlices = _normalizeTo100(
      sortedMonthly,
      monthlyTotal,
      _monthlyPalette,
    );
    final dominant = monthlySlices.isNotEmpty ? monthlySlices.first : null;

    // ===== DAILY (TODAY) =====
    final today = DateTime.now();
    final todayDate = DateTime(today.year, today.month, today.day);
    final daySummary = summary.days.firstWhere(
      (d) => d.date == todayDate,
      orElse: () => DaySummaryModel(date: todayDate, entries: []),
    );

    final dailyCounts = <String, int>{};
    for (final e in daySummary.entries) {
      dailyCounts[e.label] = (dailyCounts[e.label] ?? 0) + 1;
    }
    final dailyTotal = dailyCounts.values
        .fold<int>(0, (a, b) => a + b)
        .toDouble();
    final sortedDaily = dailyCounts.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    final dailySlices = _normalizeTo100(
      sortedDaily,
      dailyTotal,
      const [BaseColors.gold3], 
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // === Dominant highlight ===
        if (dominant != null) ...[
          _DominantMoodHighlight(
            label: dominant.label,
            percent: dominant.displayPercent / 100.0,
            emoji: _emojiForLabel(dominant.label),
          ),
          const SizedBox(height: 20),
        ],

        // === Daily ===
        if (dailySlices.isNotEmpty) ...[
          Text(
            "Today's Mood Distribution",
            style: FontTheme.poppins16w500black(),
          ),
          const SizedBox(height: 8),
          ...dailySlices.map(
            (s) => _AnimatedMoodBar(
              label: s.label,
              emoji: _emojiForLabel(s.label),
              percent: s.displayPercent / 100.0,
              displayPercent: s.displayPercent,
              color: BaseColors.gold3,
              onTap: () => _showMoodDetail(context, s.label, s.count, true),
            ),
          ),
          const SizedBox(height: 28),
        ],

        // === Monthly ===
        Text(
          "Monthly Mood Distribution",
          style: FontTheme.poppins16w500black(),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 220,
          child: PieChart(
            PieChartData(
              sectionsSpace: 3,
              centerSpaceRadius: 45,
              pieTouchData: PieTouchData(
                touchCallback: (event, response) {
                  if (response != null &&
                      response.touchedSection != null &&
                      event.isInterestedForInteractions) {
                    setState(() {
                      touchedIndex =
                          response.touchedSection!.touchedSectionIndex;
                    });

                    // Reset after 2 seconds
                    Future.delayed(const Duration(seconds: 2), () {
                      if (mounted) setState(() => touchedIndex = -1);
                    });
                  }
                },
              ),
              sections: _buildRankedPieSections(monthlySlices, touchedIndex),
            ),
          ),
        ),
        const SizedBox(height: 16),

        // Top 4 Bars (opsional)
        ...monthlySlices
            .take(4)
            .map(
              (s) => _AnimatedMoodBar(
                label: s.label,
                emoji: _emojiForLabel(s.label),
                percent: s.displayPercent / 100.0,
                displayPercent: s.displayPercent,
                color: s.color,
                onTap: () => _showMoodDetail(context, s.label, s.count, false),
              ),
            ),
      ],
    );
  }

  List<PieChartSectionData> _buildRankedPieSections(
    List<_MoodSlice> slices,
    int touchedIndex,
  ) {
    return List.generate(slices.length, (index) {
      final s = slices[index];
      final isTouched = index == touchedIndex;
      final value = s.displayPercent
          .toDouble(); 
      final title = isTouched
          ? "${_emojiForLabel(s.label)} ${_capitalize(s.label)}\n${s.displayPercent}%"
          : "${s.displayPercent}%";

      return PieChartSectionData(
        color: s.color,
        value: value,
        radius: isTouched ? 72 : 65 - (index * 4),
        title: title,
        titleStyle: FontTheme.poppins12w500black().copyWith(
          color: BaseColors.white,
          fontWeight: FontWeight.bold,
        ),
      );
    });
  }

  void _showMoodDetail(
    BuildContext context,
    String label,
    int value,
    bool isToday,
  ) {
    showModalBottomSheet(
      context: context,
      backgroundColor: BaseColors.alabaster,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              isToday ? "Today's $label Moods" : "$label This Month",
              style: FontTheme.poppins16w500black(),
            ),
            const SizedBox(height: 10),
            Text(
              "$value ${isToday ? 'entries' : 'times'}",
              style: FontTheme.poppins14w600black(),
            ),
          ],
        ),
      ),
    );
  }
}

/// Data slice setelah dinormalisasi.
class _MoodSlice {
  final String label;
  final int count;
  final int displayPercent; 
  final Color color;

  _MoodSlice({
    required this.label,
    required this.count,
    required this.displayPercent,
    required this.color,
  });
}

List<_MoodSlice> _normalizeTo100(
  List<MapEntry<String, int>> sortedEntries,
  double total,
  List<Color> palette,
) {
  if (sortedEntries.isEmpty || total == 0) return [];

  // 1) hitung raw percent & floor
  final rawPercents = <double>[];
  final floors = <int>[];
  final remainders = <double>[];

  for (final e in sortedEntries) {
    final raw = (e.value / total) * 100.0;
    rawPercents.add(raw);
    floors.add(raw.floor());
    remainders.add(raw - raw.floor());
  }

  // 2) distribute sisa ke remainder terbesar
  final baseSum = floors.fold<int>(0, (a, b) => a + b);
  int left = 100 - baseSum;

  // index remainders descending
  final idx = List<int>.generate(sortedEntries.length, (i) => i)
    ..sort((a, b) => remainders[b].compareTo(remainders[a]));

  final display = List<int>.from(floors);
  var i = 0;
  while (left > 0 && i < idx.length) {
    display[idx[i]] += 1;
    left--;
    i++;
    if (i == idx.length) i = 0;
  }

  // 3) build slices with colors
  final slices = <_MoodSlice>[];
  for (int i = 0; i < sortedEntries.length; i++) {
    slices.add(
      _MoodSlice(
        label: sortedEntries[i].key,
        count: sortedEntries[i].value,
        displayPercent: display[i],
        color: _pickColor(palette, i),
      ),
    );
  }

  slices.sort((a, b) => b.displayPercent.compareTo(a.displayPercent));
  return slices;
}

Color _pickColor(List<Color> palette, int index) {
  if (palette.isEmpty) return BaseColors.gold3;
  if (index < palette.length) return palette[index];
  return palette.last;
}

const _monthlyPalette = <Color>[
  BaseColors.gold2,
  BaseColors.gold3,
  BaseColors.goldenrod,
  BaseColors.silver1,
  BaseColors.silver3,
];

class _DominantMoodHighlight extends StatelessWidget {
  final String label;
  final double percent;
  final String emoji;

  const _DominantMoodHighlight({
    required this.label,
    required this.percent,
    required this.emoji,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [BaseColors.gold3, BaseColors.gold2],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: BaseColors.gold3.withOpacity(0.35),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Text(emoji, style: const TextStyle(fontSize: 34)),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Most Dominant Mood", style: FontTheme.poppins12w500black()),
              Text(
                "${_capitalize(label)} ${(percent * 100).toStringAsFixed(0)}%",
                style: FontTheme.poppins16w500black(),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _AnimatedMoodBar extends StatelessWidget {
  final String label;
  final String emoji;
  final double percent;
  final int displayPercent;
  final Color color;
  final VoidCallback onTap;

  const _AnimatedMoodBar({
    required this.label,
    required this.emoji,
    required this.percent,
    required this.displayPercent,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Row(
          children: [
            SizedBox(
              width: 70,
              child: Text(
                _capitalize(label),
                style: FontTheme.poppins14w500black(),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0, end: percent),
                  duration: const Duration(milliseconds: 900),
                  curve: Curves.easeOutCubic,
                  builder: (context, value, _) => Stack(
                    children: [
                      Container(
                        height: 14,
                        decoration: BoxDecoration(
                          color: BaseColors.neutral30,
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      FractionallySizedBox(
                        widthFactor: value,
                        child: Container(
                          height: 14,
                          decoration: BoxDecoration(
                            color: color,
                            borderRadius: BorderRadius.circular(8),
                            boxShadow: [
                              BoxShadow(
                                color: color.withOpacity(0.3),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Text("$displayPercent%", style: FontTheme.poppins12w500black()),
            const SizedBox(width: 8),
            Text(emoji, style: const TextStyle(fontSize: 20)),
          ],
        ),
      ),
    );
  }
}

String _capitalize(String text) {
  if (text.isEmpty) return text;
  return text[0].toUpperCase() + text.substring(1);
}

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
