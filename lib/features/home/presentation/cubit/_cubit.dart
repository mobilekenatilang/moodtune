import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:moodtune/core/utils/date_generator.dart';
import 'package:moodtune/features/home/data/model/quote.dart';
import 'package:moodtune/features/home/domain/usecases/_usecases.dart';
import 'package:moodtune/services/logger_service.dart';

part 'homepage_cubit.dart';
part 'homepage_state.dart';
