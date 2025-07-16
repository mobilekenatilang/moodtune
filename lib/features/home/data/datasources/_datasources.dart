import 'dart:convert';

import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';
import 'package:moodtune/core/client/_client.dart';
import 'package:moodtune/core/constants/_constants.dart';
import 'package:moodtune/core/environments/_environments.dart';
import 'package:moodtune/core/extensions/_extensions.dart';
import 'package:moodtune/features/home/data/model/quote.dart';
import 'package:moodtune/services/logger_service.dart';
import 'package:moodtune/services/pref_service.dart';

part 'quote_remote_datasource.dart';
part 'quote_local_datasource.dart';
