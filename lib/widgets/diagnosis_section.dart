import 'package:flutter/material.dart';

class DiagnosisSection extends StatelessWidget {
  const DiagnosisSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          
          Column(
            children: [
              
              Icon(Icons.camera_alt, size: 40, color: Colors.green),
              SizedBox(height: 8),
              Text('Take a picture'),
            ],
          ),
          Icon(Icons.arrow_forward, color: Colors.green),
          Column(
            children: [
              Icon(Icons.assignment, size: 40, color: Colors.green),
              SizedBox(height: 8),
              Text('See results'),
            ],
          ),
        ],
      ),
    );
  }
}
