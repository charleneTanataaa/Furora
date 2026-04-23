import 'dart:io';
import 'dart:typed_data';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CapturedImage {
  final Uint8List bytes;
  final DateTime date;
  final String expression;
  final String location;

  CapturedImage({
    required this.bytes,
    required this.date,
    required this.expression,
    required this.location,
  });
}

class ImageStore {
  static List<CapturedImage> images = [];

  // Call this once at app startup in main()
  static Future<void> loadFromDisk() async {
    final prefs = await SharedPreferences.getInstance();
    final dir = await getApplicationDocumentsDirectory();
    final keys = prefs.getStringList('image_keys') ?? [];

    images = [];
    for (final key in keys) {
      final path = '${dir.path}/$key.jpg';
      final file = File(path);
      if (!await file.exists()) continue;

      final bytes = await file.readAsBytes();
      final expression = prefs.getString('${key}_expression') ?? '';
      final location = prefs.getString('${key}_location') ?? '';
      final dateMs = prefs.getInt('${key}_date') ?? 0;

      images.add(CapturedImage(
        bytes: bytes,
        date: DateTime.fromMillisecondsSinceEpoch(dateMs),
        expression: expression,
        location: location,
      ));
    }
  }

  // Call this when saving a new photo
  static Future<void> addImage(CapturedImage image) async {
    images.add(image);

    final prefs = await SharedPreferences.getInstance();
    final dir = await getApplicationDocumentsDirectory();
    final key = 'img_${DateTime.now().millisecondsSinceEpoch}';

    // Save image file
    final file = File('${dir.path}/$key.jpg');
    await file.writeAsBytes(image.bytes);

    // Save metadata
    await prefs.setString('${key}_expression', image.expression);
    await prefs.setString('${key}_location', image.location);
    await prefs.setInt('${key}_date', image.date.millisecondsSinceEpoch);

    // Update key list
    final keys = prefs.getStringList('image_keys') ?? [];
    keys.add(key);
    await prefs.setStringList('image_keys', keys);
  }
}