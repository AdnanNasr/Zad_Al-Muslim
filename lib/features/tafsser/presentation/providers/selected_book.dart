import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zad_al_muslim/core/di/injection_container.dart';
import 'package:zad_al_muslim/features/tafsser/domain/entities/tafsser_entities.dart';

part 'selected_book.g.dart';

@riverpod
class SelectedBook extends _$SelectedBook {
  static const _prefId = 'selected_tafseer_book_id';
  static const _prefName = 'selected_tafseer_book_name';
  static const _prefDesc = 'selected_tafseer_book_desc';

  @override
  TafsserBookEntity build() {
    final prefs = sl<SharedPreferences>();
    final bookId = prefs.getString(_prefId) ?? "ar.jalalayn";
    final bookName = prefs.getString(_prefName) ?? "تفسير الجلالين";
    final bookDesc = prefs.getString(_prefDesc) ?? "أشهر التفاسير المختصرة؛ يقدم شرحاً وجيزاً للآيات بأسلوب يسهل فهمه للمبتدئين.";

    return TafsserBookEntity(
      name: bookName,
      id: bookId,
      description: bookDesc,
    );
  }

  void updateSelectedBook(TafsserBookEntity book) {
    final prefs = sl<SharedPreferences>();
    prefs.setString(_prefId, book.id);
    prefs.setString(_prefName, book.name);
    prefs.setString(_prefDesc, book.description);
    state = book;
  }
}
