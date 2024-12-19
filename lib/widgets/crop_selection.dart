import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:paudha_app/translations/locale_keys.g.dart';
import '../models/crop_model.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:image/image.dart' as img; // For image resizing
import 'package:http/http.dart' as http;

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

  Future<void> _requestCameraPermission() async {
    final status = await Permission.camera.request();
    if (status.isGranted) {
      _openCamera(context);
    } else {
      print("Camera permission denied");
    }
  }

  Future<void> _openCamera(BuildContext context) async {
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
          builder: (context) =>
              CameraPreviewScreen(cameraController: cameraController),
        ),
      );
    } catch (e) {
      print("Error initializing camera: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<Crop> crops = [
      Crop(name: 'Wheat'.tr(), icon: Icons.grain), 
      Crop(name: 'Apple'.tr(), icon: Icons.apple),
      Crop(name: 'Maize'.tr(), icon: Icons.emoji_nature),
      Crop(name: 'Mango'.tr(), icon: Icons.local_florist),
      Crop(name: 'Rice'.tr(), icon: Icons.rice_bowl),
      Crop(name: 'Onion'.tr(), icon: Icons.eco),
      Crop(name: 'Potato'.tr(), icon: Icons.yard),
      Crop(name: 'Sugarcane'.tr(), icon: Icons.local_bar),
      Crop(name: 'Wheat'.tr(), icon: Icons.grain), 
      Crop(name: 'Apple'.tr(), icon: Icons.apple),
      Crop(name: 'Maize'.tr(), icon: Icons.emoji_nature),
      Crop(name: 'Mango'.tr(), icon: Icons.local_florist),
      Crop(name: 'Rice'.tr(), icon: Icons.rice_bowl),
      Crop(name: 'Onion'.tr(), icon: Icons.eco),
      Crop(name: 'Potato'.tr(), icon: Icons.yard),
      Crop(name: 'Sugarcane'.tr(), icon: Icons.local_bar),
    ];

    return isCameraInitialized
        ? GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4),
            itemCount: crops.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () => _requestCameraPermission(),
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
        : const Center(child: CircularProgressIndicator());
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

      // Resize the image
      final originalImage = img.decodeImage(File(imagePath).readAsBytesSync());
      final resizedImage =
          img.copyResize(originalImage!, width: 214, height: 214);

      final directory = await getExternalStorageDirectory();
      final filePath =
          '${directory!.path}/resized_${DateTime.now().millisecondsSinceEpoch}.jpg';
      final newImage = File(filePath)
        ..writeAsBytesSync(img.encodeJpg(resizedImage));

      // Send the image to the backend
      final String? diseaseName = await _sendImageToBackend(newImage);

      if (!mounted) return;

      await _controller.setFlashMode(FlashMode.off);

      // Navigate to the result screen
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => DisplayPictureScreen(
            imagePath: newImage.path,
            diseaseName: diseaseName ?? 'Unknown Disease',
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

  Future<String?> _sendImageToBackend(File imageFile) async {
    const String serverUrl = 'http://<YOUR-SERVER-IP>:8050/public/get_disease';

    try {
      var request = http.MultipartRequest('POST', Uri.parse(serverUrl));
      request.headers['x-api-key'] = '54265bb8-3f69-4c1b-a2db-4ed4bbc274a7';
      request.fields['crop_id'] = '1'; // Replace this dynamically if needed
      request.files
          .add(await http.MultipartFile.fromPath('image', imageFile.path));

      final response = await request.send();

      if (response.statusCode == 200) {
        final responseBody = await response.stream.bytesToString();
        return responseBody; // Expect disease name from backend
      } else {
        print('Error: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error uploading image: $e');
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(LocaleKeys.Take_a_Picture.tr(),
            style: TextStyle(color: Colors.white)),
        backgroundColor:
            Colors.green, // Add background color to match the theme
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: CameraPreview(_controller),
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _takePicture,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green, // Button color
                shape: const CircleBorder(),
                padding: const EdgeInsets.all(
                    20), // Increase padding to make button larger
              ),
              child:
                  const Icon(Icons.camera_alt, color: Colors.white, size: 40),
            ),
            const SizedBox(height: 20),
            Text(
              LocaleKeys.Camera_button.tr(),
              style: const TextStyle(fontSize: 18, color: Colors.black),
            ),
          ],
        ),
      ),
    );
  }
}

//---------------------------------------------------------------------DISPPLAAAAYYYYYYYYYYYYYYYYYYY--------------------------------------------------------------

class DisplayPictureScreen extends StatelessWidget {
  final String imagePath;
  final String diseaseName;

  const DisplayPictureScreen({
    super.key,
    required this.imagePath,
    required this.diseaseName,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          LocaleKeys.diagnosis_Results.tr(),
        ),
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Adding some space from the top
            const SizedBox(height: 20),

            // Center the image with a fixed height
            Center(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(
                      10), // Rounded corners for the image
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3), // Shadow effect
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.file(
                    File(imagePath),
                    height: 500,
                    width: 500,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),

            // Space between image and result box
            const SizedBox(height: 40),

            // Disease name box with padding, rounded corners, and a background color
            Container(
              padding: const EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.green[50],
                border: Border.all(
                  color: Colors.green,
                  width: 2,
                ),
              ),
              child: Text(
                LocaleKeys.detected_Disease.tr(args: [diseaseName]),
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
