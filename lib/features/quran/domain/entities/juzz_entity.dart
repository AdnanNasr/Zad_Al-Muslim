class JuzzEntity {
  final int id;
  final List<int> surahs;
  final VersesEntity versesEntity;
  JuzzEntity({
    required this.id,
    required this.surahs,
    required this.versesEntity,
  });
}

class VersesEntity {
  final Map<int, List<int>> verses;
  VersesEntity({required this.verses});
}
