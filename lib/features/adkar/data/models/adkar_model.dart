import 'package:zad_al_muslim/features/adkar/domain/entities/adkar_entity.dart';
import 'package:isar/isar.dart';

part 'adkar_model.g.dart';

@collection
class AdkarModel {
  Id id = Isar.autoIncrement;

  @Index()
  String category = '';
  List<String> text = [];
  List<String> footnote = [];
  List<int> counts = [];

  AdkarModel();

  AdkarModel.full({
    required this.category,
    required this.footnote,
    required this.text,
    required this.counts,
  });

  factory AdkarModel.fromJson(String categoryName, Map<String, dynamic> json) {
    final List<String> texts = json['text'] != null
        ? List<String>.from(json['text'])
        : [];
    final List<int> parsedCounts = texts.map((t) => _parseCount(t)).toList();

    return AdkarModel.full(
      category: categoryName,
      text: texts,
      footnote: json['footnote'] != null
          ? List<String>.from(json['footnote'])
          : [],
      counts: parsedCounts,
    );
  }

  static int _parseCount(String text) {
    if (text.contains('مائة مرة')) return 100;
    if (text.contains('عشر مرات')) return 10;
    if (text.contains('سبع مرات')) return 7;
    if (text.contains('أربع مرات')) return 4;
    if (text.contains('ثلاث مرات') || text.contains('ثلاثاً')) return 3;
    if (text.contains('مرتين')) return 2;
    if (text.contains('مرة واحدة') || text.contains('مرةً')) return 1;

    // Check for patterns like (3) or (10) if they exist, but mostly it's text.
    final match = RegExp(r'\((\d+)\s+مرات\)').firstMatch(text);
    if (match != null) {
      return int.tryParse(match.group(1) ?? '1') ?? 1;
    }

    return 1; // Default
  }

  Map<String, dynamic> toJson() {
    return {
      'category': category,
      'text': text,
      'footnote': footnote,
      'counts': counts,
    };
  }

  factory AdkarModel.fromEntity(AdkarEntity entity) {
    return AdkarModel.full(
      category: entity.category,
      text: entity.text,
      footnote: entity.footnote,
      counts: entity.counts,
    );
  }

  AdkarEntity toEntity() {
    return AdkarEntity(
      category: category,
      footnote: footnote,
      text: text,
      counts: counts,
    );
  }

  /// Helper function to parse the entire JSON file into a List of AdkarModel
  static List<AdkarModel> fromJsonList(Map<String, dynamic> jsonMap) {
    return jsonMap.entries.map((entry) {
      return AdkarModel.fromJson(
        entry.key,
        entry.value as Map<String, dynamic>,
      );
    }).toList();
  }
}
