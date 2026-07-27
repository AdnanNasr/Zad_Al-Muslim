enum AppUpdateType { none, optional, required }

class AppUpdateModel {
  const AppUpdateModel({
    required this.type,
    required this.currentBuild,
    required this.latestBuild,
    required this.minimumBuild,
    required this.title,
    required this.message,
    required this.storeUrl,
    this.fromTrustedRemoteValue = false,
  });

  final AppUpdateType type;
  final int currentBuild;
  final int latestBuild;
  final int minimumBuild;
  final String title;
  final String message;
  final String storeUrl;
  final bool fromTrustedRemoteValue;

  bool get hasUpdate => type != AppUpdateType.none;
  bool get isRequired => type == AppUpdateType.required;
}
