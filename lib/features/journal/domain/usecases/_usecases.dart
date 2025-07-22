import 'package:either_dart/either.dart';
import 'package:injectable/injectable.dart';
import 'package:moodtune/core/bases/use_case/use_case.dart';
import 'package:moodtune/core/errors/failure.dart';
import 'package:moodtune/core/extensions/_extensions.dart';
import 'package:moodtune/features/journal/domain/entities/filter_journal.dart';
import 'package:moodtune/features/journal/domain/repositories/_repositories.dart';
import 'package:moodtune/features/journal/data/model/journal.dart';

part 'get_all_journal_usecase.dart';
part 'get_journal_by_month_usecase.dart';
part 'get_journal_by_week_usecase.dart';
part 'search_journal_usecase.dart';
part 'get_journal_by_timestamp_usecase.dart';
part 'create_journal_usecase.dart';
part 'analyze_journal_usecase.dart';
part 'update_journal_usecase.dart';
part 'delete_journal_usecase.dart';
