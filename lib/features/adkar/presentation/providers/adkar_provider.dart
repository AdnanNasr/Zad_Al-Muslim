import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zad_al_muslim/core/di/injection_container.dart';
import 'package:zad_al_muslim/features/adkar/domain/entities/adkar_entity.dart';
import 'package:zad_al_muslim/features/adkar/domain/usecases/get_all_adkar.dart';
import 'package:zad_al_muslim/features/adkar/domain/usecases/get_adkar_by_category.dart';

// Provider to get the use cases from GetIt
final getAllAdkarUseCaseProvider = Provider<GetAllAdkar>((ref) {
  return sl<GetAllAdkar>();
});

final getAdkarByCategoryUseCaseProvider = Provider<GetAdkarByCategory>((ref) {
  return sl<GetAdkarByCategory>();
});

// FutureProvider for fetching all adkar
final allAdkarProvider = FutureProvider<List<AdkarEntity>>((ref) async {
  final usecase = ref.watch(getAllAdkarUseCaseProvider);
  final result = await usecase();
  return result.fold((failure) => throw failure, (adkar) => adkar);
});

// Family FutureProvider for fetching specific adkar category
final adkarByCategoryProvider = FutureProvider.family<AdkarEntity, String>((
  ref,
  category,
) async {
  final usecase = ref.watch(getAdkarByCategoryUseCaseProvider);
  final result = await usecase(category);
  return result.fold((failure) => throw failure, (adkar) => adkar);
});
