import 'dart:math';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../data/model/day_mood_model.dart';
import '../../data/model/month_mood_summary_model.dart';

class CalendarTestPage extends StatefulWidget {
  const CalendarTestPage({super.key});

  @override
  State<CalendarTestPage> createState() => _CalendarTestPageState();
}

class _CalendarTestPageState extends State<CalendarTestPage> {
  late Box<MonthMoodSummaryModel> _box;
  List<DayMoodModel> _days = [];
  final Random _random = Random();

  final List<Map<String, String>> moods = [
    {'label': 'happy', 'emoji': '😄'},
    {'label': 'calm', 'emoji': '😌'},
    {'label': 'sad', 'emoji': '😔'},
    {'label': 'angry', 'emoji': '😡'},
    {'label': 'anxious', 'emoji': '😰'},
    {'label': 'tired', 'emoji': '😴'},
  ];

  @override
  void initState() {
    super.initState();
    _box = Hive.box<MonthMoodSummaryModel>('calendar_mood');
    _loadData();
  }

  void _loadData() {
    final allSummaries = _box.values.toList();
    final allDays = <DayMoodModel>[];
    for (var s in allSummaries) {
      allDays.addAll(s.days);
    }

    // urutkan dari yang paling baru ke paling lama
    allDays.sort((a, b) => b.date.compareTo(a.date));

    setState(() {
      _days = allDays;
    });
  }

  Future<void> _addRandomMood() async {
    final randomYear = DateTime.now().year;
    final randomMonth = _random.nextInt(12) + 1;
    final daysInMonth = DateTime(randomYear, randomMonth + 1, 0).day;
    final randomDay = _random.nextInt(daysInMonth) + 1;

    final randomDate = DateTime(randomYear, randomMonth, randomDay);
    final key =
        "${randomDate.year}-${randomDate.month.toString().padLeft(2, '0')}";

    final randomMood = (moods..shuffle()).first;

    final newMood = DayMoodModel(
      date: randomDate,
      label: randomMood['label']!,
      emoji: randomMood['emoji']!,
    );

    final existing = _box.get(key);
    MonthMoodSummaryModel updated;

    if (existing == null) {
      updated = MonthMoodSummaryModel(
        year: randomDate.year,
        month: randomDate.month,
        days: [newMood],
        avgMood: 0,
        labelCount: {newMood.label: 1},
        lastSync: DateTime.now(),
      );
    } else {
      final days = List<DayMoodModel>.from(existing.days);
      final idx = days.indexWhere(
        (d) =>
            d.date.year == randomDate.year &&
            d.date.month == randomDate.month &&
            d.date.day == randomDate.day,
      );

      if (idx == -1) {
        days.add(newMood);
      } else {
        final oldLabel = days[idx].label;
        if (oldLabel != newMood.label) {
          existing.labelCount[oldLabel] = (existing.labelCount[oldLabel]! - 1)
              .clamp(0, 9999);
        }
        days[idx] = newMood;
      }

      final labelCount = Map<String, int>.from(existing.labelCount);
      labelCount[newMood.label] = (labelCount[newMood.label] ?? 0) + 1;

      updated = existing.copyWith(
        days: days,
        labelCount: labelCount,
        lastSync: DateTime.now(),
      );
    }

    await _box.put(key, updated);
    _loadData();
  }

  Future<void> _deleteFirstMood() async {
    if (_days.isEmpty) return;

    final oldestMood = _days.last;
    final key =
        "${oldestMood.date.year}-${oldestMood.date.month.toString().padLeft(2, '0')}";
    final existing = _box.get(key);

    if (existing != null) {
      final days = List<DayMoodModel>.from(existing.days);
      days.removeWhere(
        (d) =>
            d.date.year == oldestMood.date.year &&
            d.date.month == oldestMood.date.month &&
            d.date.day == oldestMood.date.day,
      );

      final labelCount = Map<String, int>.from(existing.labelCount);
      if (labelCount.containsKey(oldestMood.label)) {
        labelCount[oldestMood.label] = (labelCount[oldestMood.label]! - 1)
            .clamp(0, 9999);
        if (labelCount[oldestMood.label] == 0) {
          labelCount.remove(oldestMood.label);
        }
      }

      if (days.isEmpty) {
        await _box.delete(key);
      } else {
        final updated = existing.copyWith(
          days: days,
          labelCount: labelCount,
          lastSync: DateTime.now(),
        );
        await _box.put(key, updated);
      }
    }

    _loadData();
  }

  String _formatDate(DateTime date) {
    final months = [
      "Jan",
      "Feb",
      "Mar",
      "Apr",
      "Mei",
      "Jun",
      "Jul",
      "Agu",
      "Sep",
      "Okt",
      "Nov",
      "Des",
    ];
    return "${date.day} ${months[date.month - 1]} ${date.year}";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Hive Calendar Test"),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            tooltip: "Hapus data pertama",
            onPressed: _deleteFirstMood,
          ),
          IconButton(
            icon: const Icon(Icons.add),
            tooltip: "Tambah random mood",
            onPressed: _addRandomMood,
          ),
        ],
      ),
      body: _days.isEmpty
          ? const Center(child: Text("Belum ada data mood"))
          : ListView.builder(
              itemCount: _days.length,
              itemBuilder: (context, index) {
                final day = _days[index];
                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  child: ListTile(
                    leading: CircleAvatar(
                      radius: 20,
                      child: Text(
                        day.emoji,
                        style: const TextStyle(fontSize: 24),
                      ),
                    ),
                    title: Text(
                      _formatDate(day.date),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    subtitle: Text(
                      day.label,
                      style: const TextStyle(fontSize: 14),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
