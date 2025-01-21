import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../main.dart';
import 'home_screen.dart';

// Define the Color extension with withValue
extension ColorExtensions on Color {
  Color withValue(double value) {
    // Assuming 'value' represents alpha (opacity) 0.0 to 1.0
    int alpha = (value * 255).toInt().clamp(0, 255); // Clamp to ensure valid range
    return withAlpha(alpha);
  }
}

class LanguageSelectionScreen extends StatefulWidget {
  const LanguageSelectionScreen({super.key});

  @override
  State<LanguageSelectionScreen> createState() => _LanguageSelectionScreenState();
}

class _LanguageSelectionScreenState extends State<LanguageSelectionScreen> {
  double _opacityEn = 1.0;
  double _opacityHi = 1.0;
  double _opacityBn = 1.0;

  Future<void> _setLanguage(BuildContext context, String languageCode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('language_code', languageCode);
    await context.setLocale(
      Locale(languageCode.split('_')[0],
          languageCode.split('_').length > 1 ? languageCode.split('_')[1] : ''),
    );
    MyApp.setLocale(
      context,
      Locale(languageCode.split('_')[0],
          languageCode.split('_').length > 1 ? languageCode.split('_')[1] : ''),
    );
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const HomeScreen(apiService: null,)),
    );
  }

    void _handleTap(String languageCode, ValueSetter<double> setOpacity) {
    setOpacity(0.7); // Briefly reduce opacity
    _setLanguage(context, languageCode);
    Future.delayed(const Duration(milliseconds: 100), () {
      setOpacity(1.0); // Restore opacity
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select a language'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _buildLanguageCircle(
                context, 'en_US', 'English', 'E', Colors.blue, _opacityEn,
                (value) => setState(() => _opacityEn = value),
                    ()=> _handleTap('en_US', (value) => setState(()=> _opacityEn = value))
            ),
            const SizedBox(height: 20),
            _buildLanguageCircle(
                context, 'hi_IN', 'हिन्दी', 'ह', Colors.orange.shade200, _opacityHi,
                (value) => setState(() => _opacityHi = value),
                    ()=> _handleTap('hi_IN', (value) => setState(()=> _opacityHi = value))
            ),
            const SizedBox(height: 20),
            _buildLanguageCircle(
                context, 'bn_BD', 'বাংলা', 'বা', Colors.green.shade300, _opacityBn,
                (value) => setState(() => _opacityBn = value),
                    ()=> _handleTap('bn_BD', (value) => setState(()=> _opacityBn = value))
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLanguageCircle(
      BuildContext context,
      String languageCode,
      String languageName,
      String initial,
      Color borderColor,
      double opacity,
      ValueSetter<double> setOpacity,
      VoidCallback onTap
      ) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(50),
      splashColor: borderColor.withValue(0.9), // Use withValue here!
      child: AnimatedOpacity(
        opacity: opacity,
        duration: const Duration(milliseconds: 500),
        child: Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: borderColor, width: 2.0),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  initial,
                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                Text(
                  languageName,
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}