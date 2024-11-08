import 'package:flutter/material.dart';
import 'package:camera/camera.dart';  // Import the camera package
import '../models/crop_model.dart';
import 'dart:io'; // Import for File
import 'package:path_provider/path_provider.dart'; // Import for path provider
import 'package:permission_handler/permission_handler.dart'; // Import for permission handler

class CropSelection extends StatefulWidget {
  const CropSelection({super.key});

  @override
  _CropSelectionState createState() => _CropSelectionState();
}

class _CropSelectionState extends State<CropSelection> {
  late List<CameraDescription> cameras;
  bool isCameraInitialized = false;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  // Initialize the camera
  Future<void> _initializeCamera() async {
    try {
      cameras = await availableCameras(); // Get available cameras
      setState(() {
        isCameraInitialized = true;
      });
    } catch (e) {
      print("Error fetching cameras: $e");
    }
  }

  // Request camera permission
  Future<void> _requestCameraPermission() async {
    final status = await Permission.camera.request();
    if (status.isGranted) {
      _openCamera(context);
    } else {
      print("Camera permission denied");
    }
  }

  // Open the camera when a crop is clicked
  Future<void> _openCamera(BuildContext context) async {
    if (!isCameraInitialized || cameras.isEmpty) {
      print("No camera available");
      return;
    }

    // Create a CameraController
    final cameraController = CameraController(cameras[0], ResolutionPreset.ultraHigh);

    try {
      // Initialize the camera
      await cameraController.initialize();
      if (!mounted) return;

      // Navigate to a new screen to show the camera preview
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CameraPreviewScreen(cameraController: cameraController),
        ),
      );
    } catch (e) {
      print("Error initializing camera: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<Crop> crops = [
      Crop(name: 'Wheat', icon: Icons.grain),
      Crop(name: 'Apple', icon: Icons.apple),
      Crop(name: 'Maize', icon: Icons.emoji_nature),
      Crop(name: 'Mango', icon: Icons.local_florist),
      Crop(name: 'Rice', icon: Icons.rice_bowl),
      Crop(name: 'Onion', icon: Icons.eco),
      Crop(name: 'Potato', icon: Icons.yard),
      Crop(name: 'Sugarcane', icon: Icons.local_bar),
      Crop(name: 'Wheat', icon: Icons.grain),
      Crop(name: 'Apple', icon: Icons.apple),
      Crop(name: 'Maize', icon: Icons.emoji_nature),
      Crop(name: 'Mango', icon: Icons.local_florist),
      Crop(name: 'Rice', icon: Icons.rice_bowl),
      Crop(name: 'Onion', icon: Icons.eco),
      Crop(name: 'Potato', icon: Icons.yard),
      Crop(name: 'Sugarcane', icon: Icons.local_bar),
    ];

    return isCameraInitialized
        ? GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 4),
            itemCount: crops.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () => _requestCameraPermission(), // Request camera permission when a crop is clicked
                child: Column(
                  children: [
                    CircleAvatar(
                      backgroundColor: Colors.lightGreen[100],
                      child: Icon(crops[index].icon, color: Colors.green),
                    ),
                    const SizedBox(height: 4),
                    Text(crops[index].name),
                  ],
                ),
              );
            },
          )
        : const Center(child: CircularProgressIndicator()); // Show a loading indicator if the camera is not initialized
  }
}

class CameraPreviewScreen extends StatefulWidget {
  final CameraController cameraController;

  const CameraPreviewScreen({super.key, required this.cameraController});

  @override
  _CameraPreviewScreenState createState() => _CameraPreviewScreenState();
}

class _CameraPreviewScreenState extends State<CameraPreviewScreen> {
  late CameraController _controller;
  bool _isTakingPicture = false;

  @override
  void initState() {
    super.initState();
    _controller = widget.cameraController;
    _controller.setFlashMode(FlashMode.torch);  // Get the camera controller passed from the previous screen
  }

  @override
  void dispose() {
    _controller.dispose(); // Dispose of the camera controller when leaving this screen
    super.dispose();
  }
Future<void> _takePicture() async {
  if (_isTakingPicture) return;

  setState(() {
    _isTakingPicture = true;
  });

  try {
    final image = await _controller.takePicture();
    final imagePath = image.path;

    // Save the image to the device
    final directory = await getApplicationDocumentsDirectory();
    final filePath = '${directory.path}/${DateTime.now().millisecondsSinceEpoch}.jpg';
    final File newImage = await File(imagePath).copy(filePath);

    // Debug logging to print the file path
    print('Image saved to: $filePath');

    // Show the captured image
    if (!mounted) return;
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => DisplayPictureScreen(imagePath: newImage.path),
      ),
    );
  } catch (e) {
    print("Error capturing image: $e");
  } finally {
    setState(() {
      _isTakingPicture = false;
    });
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Capture Image"),
        actions: [
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => Navigator.pop(context), // Close the camera preview and go back
          ),
        ],
      ),
      body: Column(
        children: [
          const SizedBox(height: 16), // Add space at the top
          Center(
            child: Container(
              width: 350,
              height: 450,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15), // Round edges
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: const Offset(0, 3), // Shadow direction
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15), // Round edges
                child: AspectRatio(
                  aspectRatio: _controller.value.aspectRatio,
                  child: CameraPreview(_controller),
                ),
              ),
            ),
          ),
          const SizedBox(height: 16), // Add space below the camera preview
          Expanded(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Text(
                  'Tips for better accurate result :\n\nEnsure that the damaged leaves are in the center of focus. '
                  'Hold your device steady and make sure there is enough light for a clear picture.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 10),
                ),
              ),
            ),
          ),
          ElevatedButton(
            onPressed: _takePicture,
            child: const Icon(Icons.camera_alt),
          ),
          const SizedBox(height: 16), // Add space below the capture button
        ],
      ),
    );
  }
}

class DisplayPictureScreen extends StatelessWidget {
  final String imagePath;

  const DisplayPictureScreen({super.key, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Display the Picture')),
      body: Image.file(File(imagePath)), // Display the captured image
    );
  }
}