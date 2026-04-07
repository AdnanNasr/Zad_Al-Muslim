class AdkarEntity {
  final String category;
  final List<String> text;
  final List<String> footnote;
  final List<int> counts;
  AdkarEntity({
    required this.category,
    required this.footnote,
    required this.text,
    required this.counts,
  });
}
