

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:paudha_app/api_stuff.dart';
import 'package:paudha_app/screens/result_wala_screen.dart';
import 'package:paudha_app/translations/locale_keys.g.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:image/image.dart' as img; // For image resizing
import 'dart:io';
import '../models/crop_model.dart';

class CropSelection extends StatefulWidget {
  const CropSelection({super.key});

  @override
  _CropSelectionState createState() => _CropSelectionState();
}

String diseaseName = 'Bacterial Spot';

class _CropSelectionState extends State<CropSelection> {
  late List<CameraDescription> cameras;
  bool isCameraInitialized = false;
  List<Crop> crops = [];
  bool isLoading = true;

  final ApiService apiService =
      ApiService('http://192.168.1.10:8050'); // Base URL for the backend

  @override
  void initState() {
    super.initState();
    _initializeCamera();
    _fetchCrops();
  }

  // Initialize camera
  Future<void> _initializeCamera() async {
    try {
      cameras = await availableCameras();
      setState(() {
        isCameraInitialized = true;
      });
    } catch (e) {
      print("Error fetching cameras: $e");
    }
  }

  // Fetch crop data using API
  Future<void> _fetchCrops() async {
    try {
      final cropData = await apiService.getCropDetails();
      print('Fetched crop data: $cropData');

      setState(() {
        crops = cropData
            .where((data) =>
                data['isPublic'] == true && data['isClassifierLoaded'] == true)
            .map((data) => Crop.fromJson(data))
            .toList();
        isLoading = false;
      });

      if (crops.isEmpty) {
        print('No crops meet the conditions.');
      }
    } catch (e) {
      print('Error fetching crops: $e');
      setState(() => isLoading = false);
    }
  }

  // Request camera permissions
  Future<void> _requestCameraPermission(Crop selectedCrop) async {
    final status = await Permission.camera.request();
    if (status.isGranted) {
      _openCamera(context, selectedCrop);
    } else {
      print("Camera permission denied");
    }
  }

  // Open camera
  Future<void> _openCamera(BuildContext context, Crop selectedCrop) async {
    if (!isCameraInitialized || cameras.isEmpty) {
      print("No camera available");
      return;
    }

    final cameraController =
        CameraController(cameras[0], ResolutionPreset.ultraHigh);

    try {
      await cameraController.initialize();
      if (!mounted) return;

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CameraPreviewScreen(
            cameraController: cameraController,
            diseaseName: diseaseName,
            selectedCropId: selectedCrop.id,
            cropDimensions: {
              'dimX': selectedCrop.dimX,
              'dimY': selectedCrop.dimY,
            },
          ),
        ),
      );
    } catch (e) {
      print("Error initializing camera: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Center(child: CircularProgressIndicator())
        : crops.isNotEmpty
            ? GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4),
                itemCount: crops.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () => _requestCameraPermission(crops[index]),
                    child: Column(
                      children: [
                        CircleAvatar(
                          backgroundColor: Colors.lightGreen[100],
                          child: const Icon(Icons.agriculture, color: Colors.green),
                        ),
                        const SizedBox(height: 4),
                        Text(crops[index].name),
                      ],
                    ),
                  );
                },
              )
            : const Center(
                child: Text(
                  'No crops available.',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              );
  }
}

// Camera Preview Screen
class CameraPreviewScreen extends StatefulWidget {
  final CameraController cameraController;
  final int selectedCropId;
  final Map<String, int> cropDimensions;

  const CameraPreviewScreen({
    super.key,
    required this.cameraController,
    required this.selectedCropId,
    required this.cropDimensions,
    required String diseaseName,
  });

  @override
  _CameraPreviewScreenState createState() => _CameraPreviewScreenState();
}

class _CameraPreviewScreenState extends State<CameraPreviewScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(LocaleKeys.Take_a_Picture.tr(),
            style: const TextStyle(color: Colors.white)),
        backgroundColor: Colors.green,
      ),
      body: Column(
        children: [
          Expanded(
            child: CameraPreview(widget.cameraController),
          ),
          ElevatedButton(
            onPressed: _takePicture,
            child: const Icon(Icons.camera_alt),
          ),
        ],
      ),
    );
  }
  late CameraController _controller;
  bool _isTakingPicture = false;

  final ApiService apiService =
      ApiService('http://192.168.1.10:8050'); // Base URL for backend

  @override
  void initState() {
    super.initState();
    _controller = widget.cameraController;
    _controller.setFlashMode(FlashMode.torch);
  }

  @override
  void dispose() {
    _controller.dispose();
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

      // Resize image
      final originalImage = img.decodeImage(File(imagePath).readAsBytesSync());
      final resizedImage = img.copyResize(
        originalImage!,
        width: widget.cropDimensions['dimX']!,
        height: widget.cropDimensions['dimY']!,
      );

      final directory = await getExternalStorageDirectory();
      final filePath =
          '${directory!.path}/resized_${DateTime.now().millisecondsSinceEpoch}.jpeg';
      final newImage = File(filePath)
        ..writeAsBytesSync(img.encodeJpg(resizedImage));

      // Send image to backendFF
      final diseaseName = await apiService.getDiseasePrediction(
        cropId: widget.selectedCropId,
        imageFile: newImage,
      );

      if (!mounted) return;

      await _controller.setFlashMode(FlashMode.off);

      // Navigate to results
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => DisplayPictureScreen(
            imagePath: newImage.path,
            diseaseName: diseaseName,
            originalImage: imagePath,
          ),
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
  Widget buildd(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(LocaleKeys.Take_a_Picture.tr(),
            style: const TextStyle(color: Colors.white)),
        backgroundColor: Colors.green,
      ),
      body: Column(
        children: [
          Expanded(
            child: CameraPreview(_controller),
          ),
          ElevatedButton(
            onPressed: _takePicture,
            child: const Icon(Icons.camera_alt),
          ),
        ],
      ),
    );
  }
}
