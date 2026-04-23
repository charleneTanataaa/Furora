import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:furora/components/image_store.dart';
import 'dart:typed_data';

class CameraScreen extends StatefulWidget {
  final List<CameraDescription> cameras;
  final VoidCallback onGoHome;
  const CameraScreen({super.key, required this.cameras, required this.onGoHome});

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  CameraController? controller;
  XFile? imageFile;
  bool _isTakingPicture = false;

  void _toggleFlash() async {
    if (controller == null) return;
    try {
      if (controller!.value.flashMode == FlashMode.torch) {
        await controller!.setFlashMode(FlashMode.off);
      } else {
        await controller!.setFlashMode(FlashMode.torch);
      }
      setState(() {});
    } catch (e) {
      debugPrint("Flash error: $e");
    }
  }

  @override
  void initState() {
    super.initState();
    if (widget.cameras.isEmpty) {
      debugPrint("No cameras available");
      return;
    }
    controller = CameraController(widget.cameras[0], ResolutionPreset.max);
    controller!.initialize().then((_) {
      if (!mounted) return;
      setState(() {});
    }).catchError((Object e) {
      if (e is CameraException) {
        debugPrint('Camera error: ${e.code}');
      }
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  void _takePicture() async {
    String _fakeDetectionExpression() {
      final expressions = [':)', 'zz', '><', 'T_T'];
      expressions.shuffle();
      return expressions.first;
    }

    if (_isTakingPicture) return;
    _isTakingPicture = true;

    try {
      final XFile picture = await controller!.takePicture();
      final Uint8List bytes = await picture.readAsBytes();
      final detectedExpression = _fakeDetectionExpression();

      ImageStore.addImage(
        CapturedImage(
          bytes: bytes,
          expression: detectedExpression,
          date: DateTime.now(),
          location: "Unknown",
        ),
      );

      await Future.delayed(const Duration(milliseconds: 100));
      Navigator.pop(context);
    } catch (e) {
      debugPrint('ERR take picture: $e');
    } finally {
      _isTakingPicture = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.cameras.isEmpty || controller == null) {
      return const Scaffold(
        body: Center(child: Text("No camera available")),
      );
    }

    if (!controller!.value.isInitialized) return const SizedBox.shrink();

    final screenSize = MediaQuery.of(context).size;
    final squareSize = screenSize.width * 0.8; // 80% of screen width

    return Scaffold(
      body: Stack(
        children: [
          SizedBox.expand(
            child: CameraPreview(controller!),
          ),
 
          Positioned(
            top: MediaQuery.of(context).padding.top + 10,
            left: 16,
            child: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.close, color: Colors.white, size: 28),
            ),
          ),

          Positioned(
            top: MediaQuery.of(context).padding.top + 10,
            right: 16,
            child: IconButton(
              onPressed: _toggleFlash,
              icon: Icon(
                controller!.value.flashMode == FlashMode.torch
                    ? Icons.flash_on
                    : Icons.flash_off,
                color: Colors.white,
                size: 28,
              ),
              
            ),
          ),

          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 32),
              child: GestureDetector(
                onTap: _isTakingPicture ? null : _takePicture,
                child: Opacity(
                  opacity: _isTakingPicture ? 0.5 : 1.0,
                  child: Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.white,
                        width: 4,
                      ),
                    ),
                    child: Center(
                      child: Container(
                        width: 60,
                        height: 60,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}