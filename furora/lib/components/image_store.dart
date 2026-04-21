import 'dart:typed_data';

class ImageStore {
  static List<CapturedImage> images = [];
}

class CapturedImage{
  final Uint8List bytes;
  final String expression;
  final DateTime date;
  final String location;

  CapturedImage({
    required this.bytes,
    required this.expression,
    required this.date,
    required this.location,
  });
}