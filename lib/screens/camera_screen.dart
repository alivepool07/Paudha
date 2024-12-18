import 'package:camera/camera.dart';

Future<CameraController> createCameraController(
    CameraDescription cameraDescription, ResolutionPreset resolutionPreset) async {
  final cameraController = CameraController(cameraDescription, resolutionPreset);
  await cameraController.initialize();
  return cameraController;
}