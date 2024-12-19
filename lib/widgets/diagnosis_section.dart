import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:paudha_app/translations/locale_keys.g.dart';

class DiagnosisSection extends StatelessWidget {
  const DiagnosisSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:  EdgeInsets.all(16),
      
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(8),
      ),
      child:  Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          
          Column(
            children: [
              
              Icon(Icons.camera_alt, size: 40, color: Colors.green),
              SizedBox(height: 8),
              Text(
                LocaleKeys.Take_a_Picture.tr(),   //take picture wala text
              ),
            ],
          ),
          Icon(Icons.arrow_forward, color: Colors.green),
          Column(
            children: [
              Icon(Icons.assignment, size: 40, color: Colors.green),
              SizedBox(height: 8),
              Text(
                LocaleKeys.See_Results.tr(),  // see resulyts wala text
              ),
            ],
          ),
        ],
      ),
    );
  }
}
