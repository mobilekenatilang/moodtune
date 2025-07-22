import 'package:injectable/injectable.dart';
import 'package:moodtune/core/client/_client.dart';
import 'package:moodtune/core/environments/_environments.dart';
import 'package:moodtune/core/extensions/_extensions.dart';
import 'package:moodtune/features/journal/data/model/analyzed.dart';
import 'package:moodtune/features/journal/data/model/journal.dart';
import 'package:moodtune/services/logger_service.dart';
import 'package:moodtune/services/sqflite_service.dart';

part 'journal_local_datasource.dart';
part 'journal_remote_datasource.dart';