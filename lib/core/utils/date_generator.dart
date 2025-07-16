enum TimeOfDay { morning, afternoon, evening }

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
  if (hour >= 4 && hour <= 12) return TimeOfDay.morning;
  if (hour >= 13 && hour <= 17) return TimeOfDay.afternoon;
  return TimeOfDay.evening;
}

String getGreeting(DateTime time) {
  switch (getTimeOfDay(time)) {
    case TimeOfDay.morning:
      return 'Good Morning';
    case TimeOfDay.afternoon:
      return 'Good Afternoon';
    case TimeOfDay.evening:
      return 'Good Evening';
  }
}
