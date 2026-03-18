import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:noor_quran/core/di/injection_container.dart';
import 'package:noor_quran/core/errors/failures.dart';
import 'package:noor_quran/features/quran/data/models/juzz_model.dart';
import 'package:noor_quran/features/quran/domain/usecases/get_juzz.dart';

final allJuzzProvider = Provider<Either<Failure, List<JuzzModel>>>((ref) {
  return sl<GetAllJuzz>().call();
});
