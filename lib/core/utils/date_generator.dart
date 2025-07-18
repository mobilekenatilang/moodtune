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
      return 'Good Morning';
    case TimeOfDay.afternoon:
      return 'Good Afternoon';
    case TimeOfDay.evening:
      return 'Good Evening';
    case TimeOfDay.night:
      return 'Good Night';
  }
}
