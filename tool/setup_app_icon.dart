import 'dart:io';

void main() {
  print('========================================');
  print('     AniSpin App Icon Setup Script     ');
  print('========================================\n');

  final String sourcePath = r'C:\Users\sahil\.gemini\antigravity-ide\brain\759d018e-4259-41b0-bdd2-70e0d654aabb\media__1784555159065.jpg';
  final File sourceFile = File(sourcePath);

  if (!sourceFile.existsSync()) {
    print('❌ Source image file not found at: $sourcePath');
    return;
  }

  final Directory iconsDir = Directory('assets/icons');
  if (!iconsDir.existsSync()) {
    iconsDir.createSync(recursive: true);
    print('📁 Created directory: assets/icons/');
  }

  final File targetJpg = File('assets/icons/app_icon.jpg');
  final File targetPng = File('assets/icons/app_icon.png');

  sourceFile.copySync(targetJpg.path);
  print('✅ Copied icon to: assets/icons/app_icon.jpg (${targetJpg.lengthSync()} bytes)');

  sourceFile.copySync(targetPng.path);
  print('✅ Copied icon to: assets/icons/app_icon.png (${targetPng.lengthSync()} bytes)');

  print('\n✨ App icon setup complete!');
  print('To update native launcher icons (Android, iOS, Web, Windows, macOS), run:');
  print('  1. flutter pub get');
  print('  2. dart run flutter_launcher_icons\n');
}
