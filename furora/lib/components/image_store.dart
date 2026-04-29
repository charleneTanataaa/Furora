import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/rendering.dart';
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
  
  static Future<Directory> _getImageDir() async{
    final appDir = await getApplicationDocumentsDirectory();
    final imageDir = Directory('${appDir.path}/furora_images');

    if(!await imageDir.exists()){
      await imageDir.create(recursive: true);
    }
    return imageDir;
  }

  static Future<void> addImage(CapturedImage image) async{
    images.add(image);
    await _saveToDisk(image);
  }

  static Future<void> _saveToDisk(CapturedImage image) async{
    try{
      final dir = await _getImageDir();
      final timestamp = image.date.microsecondsSinceEpoch;

      final imageFile = File('${dir.path}/$timestamp.jpg');
      await imageFile.writeAsBytes(image.bytes);

      final metaFile = File('${dir.path}/$timestamp.meta');
      await metaFile.writeAsString(
        '${image.expression}|${image.date.toIso8601String()}|${image.location}'
      );
    } catch (e) {
      debugPrint('Error saving image: $e');
    }
  }

  static Future<void> loadFromDisk() async {
    try{
      final dir = await _getImageDir();
      debugPrint('Images stored at: ${dir.path}');
      final files = dir.listSync().whereType<File>().toList();
      final jpgFiles = files.where((f) => f.path.endsWith('.jpg')).toList();

      for(final file in jpgFiles){
        final timestamp = file.path.split('/').last.replaceAll('.jpg', '');
        final metaFile = File('${dir.path}/$timestamp.meta');

        if(!await metaFile.exists()) continue;

        final meta = await metaFile.readAsString();
        final parts = meta.split('|');
        if(parts.length < 3) continue;

        final bytes = await file.readAsBytes();
        images.add(CapturedImage(
          bytes: bytes, 
          date: DateTime.parse(parts[1]), 
          expression: parts[0], 
          location: parts[2],
          ),
        );
      } 
    } catch (e) {
      debugPrint('Error loading images: $e');
    }
  }
}