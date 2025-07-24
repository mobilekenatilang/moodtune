import 'package:intl/intl.dart';

enum TimeOfDay { morning, afternoon, evening, night }

String getFormattedDate(DateTime date) {
  const months = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];

  const weekdays = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday',
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
      return 'Good Morning';
    case TimeOfDay.afternoon:
      return 'Good Afternoon';
    case TimeOfDay.evening:
      return 'Good Evening';
    case TimeOfDay.night:
      return 'Good Night';
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
  final diffInDays = difference.inDays;

  if (diffInSeconds < 60) {
    return '${diffInSeconds}s';
  } else if (diffInMinutes < 60) {
    return '${diffInMinutes}m';
  } else if (diffInHours < 24) {
    return '${diffInHours}h';
  } else {
    return '${diffInDays}d';
  }
}
