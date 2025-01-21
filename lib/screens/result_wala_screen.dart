import 'dart:io';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:paudha_app/translations/locale_keys.g.dart';

class DisplayPictureScreen extends StatelessWidget {
  // final File originalImage;
  // final String diseaseName;

  // const DisplayPictureScreen({Key? key, 
  // required this.originalImage, 
  // required this.diseaseName}) : super(key: key);

  final String imagePath;
  final String diseaseName;
  final String originalImage;

  const DisplayPictureScreen({
    Key? key,
    required this.imagePath,
    required this.diseaseName,
    required this.originalImage,
  }) : super(key: key);

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
                'Disease Name: $diseaseName',
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
