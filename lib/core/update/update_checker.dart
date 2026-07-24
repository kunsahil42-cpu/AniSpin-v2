import 'dart:convert';
import 'package:http/http.dart' as http;

class AppUpdateInfo {
  final String latestVersion;
  final String apkSize; // e.g. "15.4 MB"
  final String releaseDate; // e.g. "20/07/2026"
  final String downloadUrl;
  final bool isUpdateAvailable;

  AppUpdateInfo({
    required this.latestVersion,
    required this.apkSize,
    required this.releaseDate,
    required this.downloadUrl,
    required this.isUpdateAvailable,
  });
}

class UpdateChecker {
  static const String currentVersion = "v2.1.0"; // Current version of the app

  static Future<AppUpdateInfo> checkForUpdates() async {
    try {
      final response = await http.get(
        Uri.parse('https://api.github.com/repos/kunsahil42-cpu/AniSpin-v2/releases/latest'),
        headers: {
          'Accept': 'application/vnd.github.v3+json',
        },
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final latestTag = data['tag_name'] as String;
        final publishedAt = data['published_at'] as String;
        final downloadUrl = data['html_url'] as String;

        // Parse date
        final date = DateTime.tryParse(publishedAt) ?? DateTime.now();
        final releaseDate = "${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}";

        // Parse asset size
        String apkSize = "Unknown Size";
        final assets = data['assets'] as List?;
        if (assets != null && assets.isNotEmpty) {
          final asset = assets[0];
          final sizeBytes = asset['size'] as int?;
          if (sizeBytes != null) {
            final mb = sizeBytes / (1024 * 1024);
            apkSize = "${mb.toStringAsFixed(1)} MB";
          }
        }

        final updateAvailable = isNewerVersion(currentVersion, latestTag);

        return AppUpdateInfo(
          latestVersion: latestTag,
          apkSize: apkSize,
          releaseDate: releaseDate,
          downloadUrl: downloadUrl,
          isUpdateAvailable: updateAvailable,
        );
      }
    } catch (_) {}

    return AppUpdateInfo(
      latestVersion: currentVersion,
      apkSize: "0 MB",
      releaseDate: "",
      downloadUrl: "https://github.com/kunsahil42-cpu/AniSpin-v2/releases",
      isUpdateAvailable: false,
    );
  }

  static bool isNewerVersion(String current, String latest) {
    String clean(String v) {
      final val = v.trim().toLowerCase();
      return val.startsWith('v') ? val.substring(1) : val;
    }

    final currentClean = clean(current);
    final latestClean = clean(latest);

    final currentParts = currentClean.split('.').map((e) => int.tryParse(e) ?? 0).toList();
    final latestParts = latestClean.split('.').map((e) => int.tryParse(e) ?? 0).toList();

    while (currentParts.length < 3) {
      currentParts.add(0);
    }
    while (latestParts.length < 3) {
      latestParts.add(0);
    }

    for (int i = 0; i < 3; i++) {
      if (latestParts[i] > currentParts[i]) {
        return true;
      }
      if (latestParts[i] < currentParts[i]) {
        return false;
      }
    }
    return false;
  }
}
