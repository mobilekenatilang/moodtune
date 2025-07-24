import 'package:hive/hive.dart';
import 'package:injectable/injectable.dart';
import 'package:moodtune/core/client/_client.dart';
import 'package:moodtune/core/constants/_constants.dart';
import 'package:moodtune/core/environments/_environments.dart';
import 'package:moodtune/core/extensions/_extensions.dart';
import 'package:moodtune/features/calendar/data/model/daily_mood_entry.dart';
import 'package:moodtune/features/calendar/data/model/day_summary_model.dart';
import 'package:moodtune/services/logger_service.dart';
import 'package:moodtune/features/calendar/data/model/month_mood_summary_model.dart';

part 'calendar_local_datasource.dart';