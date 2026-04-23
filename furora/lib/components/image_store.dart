import 'dart:convert';
import 'dart:typed_data';
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

  static Future<void> loadFromDisk() async {
    final prefs = await SharedPreferences.getInstance();
    final keys = prefs.getStringList('image_keys') ?? [];

    images = [];
    for (final key in keys) {
      final b64 = prefs.getString('${key}_bytes');
      if (b64 == null) continue;

      final bytes = base64Decode(b64);
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

  static Future<void> addImage(CapturedImage image) async {
    images.add(image);

    final prefs = await SharedPreferences.getInstance();
    final key = 'img_${DateTime.now().millisecondsSinceEpoch}';

    await prefs.setString('${key}_bytes', base64Encode(image.bytes));
    await prefs.setString('${key}_expression', image.expression);
    await prefs.setString('${key}_location', image.location);
    await prefs.setInt('${key}_date', image.date.millisecondsSinceEpoch);

    final keys = prefs.getStringList('image_keys') ?? [];
    keys.add(key);
    await prefs.setStringList('image_keys', keys);
  }
}