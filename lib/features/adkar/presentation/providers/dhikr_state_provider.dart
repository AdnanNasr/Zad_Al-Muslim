import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import 'package:zad_al_muslim/core/database/isar_db.dart';
import 'package:zad_al_muslim/features/adkar/data/models/dhikr_state_model.dart';

class DhikrStateParams {
  final String dhikrId;
  final int initialCount;

  DhikrStateParams({
    required this.dhikrId,
    required this.initialCount,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DhikrStateParams &&
          runtimeType == other.runtimeType &&
          dhikrId == other.dhikrId;

  @override
  int get hashCode => dhikrId.hashCode;
}

final dhikrStateProvider =
    StateNotifierProvider.family<DhikrStateNotifier, int, DhikrStateParams>(
  (ref, params) {
    return DhikrStateNotifier(params);
  },
);

class DhikrStateNotifier extends StateNotifier<int> {
  final DhikrStateParams params;

  DhikrStateNotifier(this.params) : super(params.initialCount) {
    _loadSync();
  }

  void _loadSync() {
    final isar = IsarDb.database;
    if (isar == null) return;

    final stateModel = isar.dhikrStateModels
        .where()
        .dhikrIdEqualTo(params.dhikrId)
        .findFirstSync();

    if (stateModel != null) {
      final today = DateTime.now();
      final modelDate = stateModel.date;

      if (modelDate.year == today.year &&
          modelDate.month == today.month &&
          modelDate.day == today.day) {
        state = stateModel.remainingCount;
      }
    }
  }

  void decrement() {
    if (state > 0) {
      state--;
      _saveAsync();
    }
  }

  void reset() {
    state = params.initialCount;
    _saveAsync();
  }

  Future<void> _saveAsync() async {
    final isar = IsarDb.database;
    if (isar == null) return;

    await isar.writeTxn(() async {
      // Find existing or create new
      var stateModel = await isar.dhikrStateModels
          .where()
          .dhikrIdEqualTo(params.dhikrId)
          .findFirst();

      if (stateModel == null) {
        stateModel = DhikrStateModel()
          ..dhikrId = params.dhikrId
          ..remainingCount = state
          ..date = DateTime.now();
      } else {
        stateModel.remainingCount = state;
        stateModel.date = DateTime.now();
      }

      await isar.dhikrStateModels.put(stateModel);
    });
  }
}
