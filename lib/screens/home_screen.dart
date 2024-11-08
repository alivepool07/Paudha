import 'dart:async';  // Import for Timer
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart'; // Import photo_view_gallery for image gallery functionality
import '../widgets/diagnosis_section.dart';
import '../widgets/crop_selection.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // List of image URLs or Asset paths for the carousel
  final List<String> imageList = [
    'assets/images/img1.jpg',
    'assets/images/img2.jpg',
    'assets/images/img3.jpg',
    'assets/images/img4.jpg'
  ];

  late PageController _pageController;  // Page controller to manage the image carousel
  int _currentIndex = 0; // Track the current image index
  late Timer _timer; // Timer for automatic image change

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _currentIndex);
    _timer = Timer.periodic(const Duration(seconds: 3), (Timer timer) {
      if (_currentIndex < imageList.length - 1) {
        _currentIndex++;
      } else {
        _currentIndex = 0;
      }

      _pageController.animateToPage(
        _currentIndex,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeIn,
      );
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Paudha'),
        actions: [
          IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () {
              // Add your onPressed code here!
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Container for controlling image gallery
            Container(
              height: 350.0, // Set height to desired value
              width: double.infinity, // Set width to full screen
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.0), // Adjust radius for rounded corners
                boxShadow: [ // Optional: adds shadow for depth
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: const Offset(0, 3), // Shadow direction
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20.0), // Apply the same border radius
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: imageList.length,
                  itemBuilder: (context, index) {
                    return Image.asset(
                      imageList[index],
                      fit: BoxFit.cover, // Ensure the image covers the container
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 30), // Space between image gallery and DiagnosisSection
            DiagnosisSection(),
            const SizedBox(height: 30), // Space between DiagnosisSection and crop selection title
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Select your crop',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            Expanded(child: CropSelection()),
          ],
        ),
      ),
    );
  }
}