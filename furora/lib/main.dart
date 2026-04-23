import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:furora/components/main_navigation.dart';
import 'package:furora/components/image_store.dart';

List<CameraDescription> cameras = [];

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  try {
    cameras = await availableCameras();
  } catch (e) {
    debugPrint('Camera not supported on this platform: $e');
  }
  
  await ImageStore.loadFromDisk();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Furora',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
      ),
      home: MainNavigation(cameras: cameras),
    );
  }
}