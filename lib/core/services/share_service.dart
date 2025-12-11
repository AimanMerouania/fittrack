import 'dart:io';
import 'dart:typed_data';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class ShareService {
  Future<void> shareImage(Uint8List imageBytes, String text) async {
    try {
      final tempDir = await getTemporaryDirectory();
      final file = await File('${tempDir.path}/workout_summary.png').create();
      await file.writeAsBytes(imageBytes);

      await Share.shareXFiles(
        [XFile(file.path)],
        text: text,
      );
    } catch (e) {
      // Manage error nicely
      print("Error sharing image: $e");
    }
  }
}
