import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import 'package:noor_quran/core/constants/enums/my_enums.dart';
import 'package:noor_quran/view_models/models/db/islamic/hadith.dart';
import 'package:noor_quran/view_models/models/db/isar_db.dart';

/// كلاس لتخزين قيم الفلاتر الحالية
class HadithFilters {
  String? book;
  String? narrator;
  String? topic;
  HadithGrade? grade;
  bool featuredOnly = false;
}

class HadithNotifier extends AsyncNotifier<List<Hadith>> {
  late Isar _db;
  List<Hadith> _allHadith = [];
  final HadithFilters _filters = HadithFilters();

  @override
  FutureOr<List<Hadith>> build() async {
    // 1. الحصول على نسخة قاعدة البيانات
    final database = IsarDb.database;
    if (database == null) throw Exception("Isar not initialized");
    _db = database;

    // 2. تحميل البيانات الأولية من Isar
    _allHadith = await _db.hadiths.where().findAll();
    
    // 3. تطبيق الفلاتر (التي تكون فارغة في البداية) وإرجاع النتيجة
    return _applyFiltersLocally();
  }

  // ---------------- CRUD (العمليات على البيانات) ----------------

  Future<void> addHadith(Hadith hadith) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await _db.writeTxn(() => _db.hadiths.put(hadith));
      _allHadith = [..._allHadith, hadith];
      return _applyFiltersLocally();
    });
  }

  Future<void> updateHadithGrade(Id id, HadithGrade grade) async {
    final index = _allHadith.indexWhere((h) => h.id == id);
    if (index == -1) return;

    state = await AsyncValue.guard(() async {
      _allHadith[index].grade = grade;
      await _db.writeTxn(() => _db.hadiths.put(_allHadith[index]));
      return _applyFiltersLocally();
    });
  }

  Future<void> deleteHadith(Id id) async {
    state = await AsyncValue.guard(() async {
      await _db.writeTxn(() => _db.hadiths.delete(id));
      _allHadith.removeWhere((h) => h.id == id);
      return _applyFiltersLocally();
    });
  }

  Future<void> toggleIsFeatured(String hadithText) async {
    final index = _allHadith.indexWhere((h) => h.hadith == hadithText);
    if (index == -1) return;

    state = await AsyncValue.guard(() async {
      _allHadith[index].isFeautred = !_allHadith[index].isFeautred;
      await _db.writeTxn(() => _db.hadiths.put(_allHadith[index]));
      return _applyFiltersLocally();
    });
  }

  // ---------------- FILTER LOGIC (منطق التصفية) ----------------

  List<Hadith> _applyFiltersLocally() {
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

    return result.toList();
  }

  /// تحديث حالة الـ Provider لإخطار الواجهات بالتغيير
  void _updateStateWithFilters() {
    state = AsyncData(_applyFiltersLocally());
  }

  // ---------------- GETTERS (الحصول على القيم الحالية) ----------------

  bool get isFilterEmpty => 
    _filters.book == null && 
    _filters.topic == null && 
    _filters.narrator == null && 
    _filters.grade == null && 
    !_filters.featuredOnly;

  String? get currentBook => _filters.book;
  String? get currentNarrator => _filters.narrator;
  String? get currentTopic => _filters.topic;
  
  /// تحويل الدرجة البرمجية إلى نص عربي للواجهة
  String? get currentGradeText {
    if (_filters.grade == null) return null;
    switch (_filters.grade!) {
      case HadithGrade.sahih: return "صحيح";
      case HadithGrade.hasan: return "حسن";
      case HadithGrade.daif: return "ضعيف";
    }
  }

  // ---------------- SETTERS (تعديل قيم الفلاتر) ----------------

  void setBook(String? value) { 
    _filters.book = value; 
    _updateStateWithFilters(); 
  }

  void setNarrator(String? value) { 
    _filters.narrator = value; 
    _updateStateWithFilters(); 
  }

  void setTopic(String? value) { 
    _filters.topic = value; 
    _updateStateWithFilters(); 
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
    _updateStateWithFilters();
  }

  void setFeatured(bool value) {
    _filters.featuredOnly = value;
    _updateStateWithFilters();
  }

  void clearFilters() {
    _filters
      ..book = null
      ..narrator = null
      ..topic = null
      ..grade = null
      ..featuredOnly = false;
    _updateStateWithFilters();
  }
}

// ---------------- PROVIDER DEFINITION ----------------

final hadithProvider = AsyncNotifierProvider<HadithNotifier, List<Hadith>>(() {
  return HadithNotifier();
});