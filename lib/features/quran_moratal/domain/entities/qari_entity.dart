class QariEntity {
  final String name;
  final String username;
  final String narration;
  final String? image;

  QariEntity({
    required this.name,
    required this.username,
    required this.narration,
    this.image,
  });
}
