import 'package:intl/intl.dart';

enum TimeOfDay { morning, afternoon, evening, night }

String getFormattedDate(DateTime date) {
  const months = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'Mei',
    'Jun',
    'Jul',
    'Ags',
    'Sep',
    'Okt',
    'Nov',
    'Des',
  ];

  const weekdays = [
    'Senin',
    'Selasa',
    'Rabu',
    'Kamis',
    'Jumat',
    'Sabtu',
    'Minggu',
  ];

  String weekday = weekdays[date.weekday - 1];
  String month = months[date.month - 1];

  return '$weekday, ${date.day} $month ${date.year}';
}

TimeOfDay getTimeOfDay(DateTime time) {
  final hour = time.hour;
  if (hour >= 4 && hour < 12) {
    return TimeOfDay.morning;
  } else if (hour >= 12 && hour < 17) {
    return TimeOfDay.afternoon;
  } else if (hour >= 17 && hour < 21) {
    return TimeOfDay.evening;
  } else {
    return TimeOfDay.night;
  }
}

String getGreeting(DateTime time) {
  switch (getTimeOfDay(time)) {
    case TimeOfDay.morning:
      return 'Selamat Pagi';
    case TimeOfDay.afternoon:
      return 'Selamat Siang';
    case TimeOfDay.evening:
      return 'Selamat Sore';
    case TimeOfDay.night:
      return 'Selamat Malam';
  }
}

DateTime getStartOfWeek(DateTime date) {
  final weekday = date.weekday;
  final daysToSubtract = weekday - DateTime.monday;
  return date.subtract(Duration(days: daysToSubtract));
}

String getTime(DateTime postDate) {
  final now = DateTime.now();
  final difference = now.difference(postDate);

  final diffInSeconds = difference.inSeconds;
  final diffInMinutes = difference.inMinutes;
  final diffInHours = difference.inHours;

  if (diffInSeconds < 60) {
    return '${diffInSeconds}s';
  } else if (diffInMinutes < 60) {
    return '${diffInMinutes}m';
  } else if (diffInHours < 24) {
    return '${diffInHours}h';
  } else {
    return DateFormat('dd MMM yyyy').format(postDate);
  }
}
