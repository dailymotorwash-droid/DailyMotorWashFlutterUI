class AppVersionPolicy {
  final String latestVersion;
  final int latestVersionCode;
  final int minimumSupportedVersionCode;
  final bool forceUpdate;
  final String updateUrl;
  final String message;

  const AppVersionPolicy({
    required this.latestVersion,
    required this.latestVersionCode,
    required this.minimumSupportedVersionCode,
    required this.forceUpdate,
    required this.updateUrl,
    required this.message,
  });

  factory AppVersionPolicy.fromJson(Map<String, dynamic> json) {
    return AppVersionPolicy(
      latestVersion: json['latestVersion'] as String,
      latestVersionCode: (json['latestVersionCode'] as num).toInt(),
      minimumSupportedVersionCode:
      (json['minimumSupportedVersionCode'] as num).toInt(),
      forceUpdate: json['forceUpdate'] as bool,
      updateUrl: json['updateUrl'] as String,
      message: json['message'] as String,
    );
  }
}