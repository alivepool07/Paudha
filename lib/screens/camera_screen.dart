// import 'dart:async';
// import 'dart:io';

// import 'package:camera/camera.dart';
// import 'package:flutter/material.dart';
// import 'package:permission_handler/permission_handler.dart';

// Future<void> main() async {
//   WidgetsFlutterBinding.ensureInitialized();

//   final cameras = await availableCameras();
//   final firstCamera = cameras.first;

//   runApp(
//     MaterialApp(
//       theme: ThemeData.dark(),
//       home: TakePictureScreen(camera: firstCamera),
//     ),
//   );
// }

// class TakePictureScreen extends StatefulWidget {
//   final CameraDescription camera;

//   const TakePictureScreen({super.key, required this.camera});

//   @override
//   TakePictureScreenState createState() => TakePictureScreenState();
// }

// class TakePictureScreenState extends State<TakePictureScreen> {
//   late CameraController _controller;
//   late Future<void> _initializeControllerFuture;

//   @override
//   void initState() {
//     super.initState();
//     _requestPermissionsAndInitializeCamera();
//   }

//   Future<void> _requestPermissionsAndInitializeCamera() async {
//     await Permission.camera.request();
//     await Permission.storage.request();

//     _controller = CameraController(
//       widget.camera,
//       ResolutionPreset.medium,
//     );
//     _initializeControllerFuture = _controller.initialize();
//     setState(() {});
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final size = MediaQuery.of(context).size;

//     return Scaffold(
//       appBar: AppBar(title: const Text('Take a picture')),
//       body: FutureBuilder<void>(
//         future: _initializeControllerFuture,
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.done) {
//             // Wrap CameraPreview in FittedBox with BoxFit.cover
//             return SizedBox(
//               width: size.width,
//               height: size.height,
//               child: FittedBox(
//                 fit: BoxFit.cover,
//                 child: SizedBox(
//                   width: size.width,
//                   height: size.height,
//                   child: CameraPreview(_controller),
//                 ),
//               ),
//             );
//           } else {
//             return const Center(child: CircularProgressIndicator());
//           }
//         },
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () async {
//           try {
//             await _initializeControllerFuture;
//             final image = await _controller.takePicture();

//             if (!context.mounted) return;

//             await Navigator.of(context).push(
//               MaterialPageRoute(
//                 builder: (context) => DisplayPictureScreen(imagePath: image.path),
//               ),
//             );
//           } catch (e) {
//             print("Error capturing image: $e");
//           }
//         },
//         child: const Icon(Icons.camera_alt),
//       ),
//     );
//   }
// }

// class DisplayPictureScreen extends StatelessWidget {
//   final String imagePath;

//   const DisplayPictureScreen({super.key, required this.imagePath});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Display the Picture')),
//       body: Image.file(File(imagePath)),
//     );
//   }
// }

//-------------------------------------------------------------------------------------------------------------------------------
// V2

// import 'dart:io';
// import 'package:camera/camera.dart';
// import 'package:flutter/material.dart';

// class CameraPreviewScreen extends StatefulWidget {
//   const CameraPreviewScreen({super.key});

//   @override
//   State<CameraPreviewScreen> createState() => _CameraPreviewScreenState();
// }

// class _CameraPreviewScreenState extends State<CameraPreviewScreen> {
//   CameraController? _controller;
//   late Future<void> _initializeCameraFuture;
//   int _cameraIndex = 0;
//   bool _isRecording = false;

//   @override
//   void initState() {
//     super.initState();
//     _initializeCameraFuture = _initializeCamera();
//   }

//   Future<void> _initializeCamera() async {
//     // Obtain a list of the available cameras on the device.
//     final cameras = await availableCameras();

//     // Get a specific camera from the list of available cameras.
//     _cameraIndex = 0; // Use the first camera by default
//     final camera = cameras[_cameraIndex];

//     _controller = CameraController(
//       camera,
//       ResolutionPreset.ultraHigh,
//     );

//     await _controller!.initialize();
//   }

//   @override
//   void dispose() {
//     _controller?.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Camera Preview')),
//       body: FutureBuilder<void>(
//         future: _initializeCameraFuture,
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.done) {
//             return Stack(
//               alignment: Alignment.center,
//               children: [
//                 SizedBox(
//                   width: 200, // Match the parent width
//                   height: 200, // Match the parent height
//                   child: AspectRatio(
//                     aspectRatio: 1.0, // 1:1 aspect ratio
//                     child: CameraPreview(_controller!),
//                   ),
//                 ),
//                 // Add zoom, focus, and other controls here, e.g., using GestureDetector or custom widgets
//               ],
//             );
//           } else {
//             return const Center(child: CircularProgressIndicator());
//           }
//         },
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () async {
//           if (!_isRecording) {
//             try {
//               await _controller!.startVideoRecording();
//               setState(() {
//                 _isRecording = true;
//               });
//             } catch (e) {
//               print(e);
//             }
//           } else {
//             XFile file = await _controller!.stopVideoRecording();
//             print(file.path);
//             setState(() {
//               _isRecording = false;
//             });
//           }
//         },
//         child: Icon(_isRecording ? Icons.stop : Icons.videocam),
//       ),
//     );
//   }
// }



// ------------------------------------------------------------------------------------------------------------------------------------------------

//V3
// import 'package:flutter/material.dart';

// class TextDisplayScreen extends StatelessWidget {
//   final String textContent;

//   const TextDisplayScreen({super.key, required this.textContent});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: SingleChildScrollView(
//           child: Text(
//             textContent,
//             style: TextStyle(
//               fontSize: 16.0,
//               color: Colors.black,
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:camera/camera.dart';

Future<CameraController> createCameraController(
    CameraDescription cameraDescription, ResolutionPreset resolutionPreset) async {
  final cameraController = CameraController(cameraDescription, resolutionPreset);
  await cameraController.initialize();
  return cameraController;
}