class AdhanReciter {
  const AdhanReciter({
    required this.id,
    required this.name,
    required this.normalAsset,
    required this.fajrAsset,
  });

  final String id;
  final String name;
  final String normalAsset;
  final String fajrAsset;

  String assetFor({required bool isFajr}) => isFajr ? fajrAsset : normalAsset;
}
