import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:noor_quran/core/di/injection_container.dart';
import 'package:noor_quran/core/errors/failures.dart';
import 'package:noor_quran/features/quran/data/models/juzz_model.dart';
import 'package:noor_quran/features/quran/domain/usecases/get_juzz.dart';

final singleJuzzProvider = Provider.family<Either<Failure, JuzzModel>, int>((
  ref,
  id,
) {
  return sl<GetJuzz>().call(id);
});
