import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import 'package:noor_quran/constants/enums/my_enums.dart';
import 'package:noor_quran/view_models/models/db/islamic/hadith.dart';
import 'package:noor_quran/view_models/models/db/isar_db.dart';

class HadithFilters {
  String? book;
  String? narrator;
  String? topic;
  HadithGrade? grade;
  bool featuredOnly = false;
}

class HadithProvider extends StateNotifier<List<Hadith>> {
  HadithProvider(this.db) : super([]);

  final Isar db;

  List<Hadith> _allHadith = [];
  final HadithFilters _filters = HadithFilters();

  // ---------------- LOAD ----------------
  Future<void> loadHadith() async {
    _allHadith = await db.hadiths.where().findAll();
    _applyFilters();
  }

  // ---------------- CRUD ----------------
  Future<void> addHadith(Hadith hadith) async {
    await db.writeTxn(() async {
      await db.hadiths.put(hadith);
    });

    _allHadith = [..._allHadith, hadith];
    _applyFilters();
  }

  Future<void> updateHadithGrade(Id id, HadithGrade grade) async {
    final index = _allHadith.indexWhere((h) => h.id == id);
    if (index == -1) return;

    _allHadith[index].grade = grade;

    await db.writeTxn(() async {
      await db.hadiths.put(_allHadith[index]);
    });

    _applyFilters();
  }

  Future<void> deleteHadith(Id id) async {
    await db.writeTxn(() async {
      await db.hadiths.delete(id);
    });

    _allHadith.removeWhere((h) => h.id == id);
    _applyFilters();
  }

  Future<void> toggleIsFeautred(String hadithText) async {
    final index = _allHadith.indexWhere((h) => h.hadith == hadithText);
    if (index == -1) return;

    _allHadith[index].isFeautred = !_allHadith[index].isFeautred;

    await db.writeTxn(() async {
      await db.hadiths.put(_allHadith[index]);
    });

    _applyFilters();
  }

  /// Returns true when **no** filters are currently active.
  ///
  /// The previous implementation of this method returned true whenever *any*
  /// filter was set which made the name misleading and caused the UI logic in
  /// `FilterContainer` to behave incorrectly.  The flip in meaning is part of
  /// the reason the old filter text would re‑appear after clearing all filters
  /// then choosing a new one.
  bool get isFilterEmpty {
    return _filters.book == null &&
        _filters.topic == null &&
        _filters.narrator == null &&
        _filters.grade == null &&
        !_filters.featuredOnly;
  }

  // helpers used by the widgets so they can synchronise their local state with
  // the values stored in the provider.
  String? get currentBook => _filters.book;
  String? get currentNarrator => _filters.narrator;
  String? get currentTopic => _filters.topic;
  HadithGrade? get currentGrade => _filters.grade;

  /// Converts the current grade to the corresponding Arabic label used by the
  /// UI.  `null` is returned when no grade filter is active.
  String? get currentGradeText {
    switch (_filters.grade) {
      case HadithGrade.sahih:
        return "صحيح";
      case HadithGrade.hasan:
        return "حسن";
      case HadithGrade.daif:
        return "ضعيف";
      default:
        return null;
    }
  }

  // ---------------- FILTER CORE ----------------
  void _applyFilters() {
    Iterable<Hadith> result = _allHadith;

    if (_filters.book != null) {
      result = result.where((h) => h.book == _filters.book);
    }

    if (_filters.narrator != null) {
      result = result.where((h) => h.hadithNarrator == _filters.narrator);
    }

    if (_filters.topic != null) {
      result = result.where((h) => h.topic == _filters.topic);
    }

    if (_filters.grade != null) {
      result = result.where((h) => h.grade == _filters.grade);
    }

    if (_filters.featuredOnly) {
      result = result.where((h) => h.isFeautred);
    }

    state = result.toList();
  }

  // ---------------- FILTER SETTERS ----------------
  void setBook(String? value) {
    _filters.book = value;
    _applyFilters();
  }

  void setNarrator(String? value) {
    _filters.narrator = value;
    _applyFilters();
  }

  void setTopic(String? value) {
    _filters.topic = value;
    _applyFilters();
  }

  void setGradeFromText(String? value) {
    switch (value) {
      case "صحيح":
        _filters.grade = HadithGrade.sahih;
        break;
      case "حسن":
        _filters.grade = HadithGrade.hasan;
        break;
      case "ضعيف":
        _filters.grade = HadithGrade.daif;
        break;
      default:
        _filters.grade = null;
    }
    _applyFilters();
  }

  void setFeatured(bool value) {
    _filters.featuredOnly = value;
    _applyFilters();
  }

  void clearFilters() {
    _filters
      ..book = null
      ..narrator = null
      ..topic = null
      ..grade = null
      ..featuredOnly = false;

    // make sure the state changes even if `_allHadith` has the same identity as
    // the previous state; rebuilding the list forces widgets that are watching
    // the provider to run again which is important for the filter containers.
    state = List<Hadith>.from(_allHadith);
  }
}

// ---------------- PROVIDER ----------------
final hadithProvider = StateNotifierProvider<HadithProvider, List<Hadith>>((
  ref,
) {
  final db = IsarDb.database;
  if (db == null) {
    throw Exception("Isar not initialized");
  }

  final notifier = HadithProvider(db);
  notifier.loadHadith();
  return notifier;
});
