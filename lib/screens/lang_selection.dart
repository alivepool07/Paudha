// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../main.dart';
import 'home_screen.dart';

class LanguageSelectionScreen extends StatelessWidget {
  const LanguageSelectionScreen({super.key});

  Future<void> _setLanguage(BuildContext context, String languageCode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('language_code', languageCode);
    await context.setLocale(Locale(languageCode.split('_')[0], languageCode.split('_').length > 1 ? languageCode.split('_')[1] : '')); // Set the locale dynamically
    MyApp.setLocale(context, Locale(languageCode.split('_')[0], languageCode.split('_').length > 1 ? languageCode.split('_')[1] : ''));
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const HomeScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Language'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () => _setLanguage(context, 'en_US'),
              child: const Text('English'),
            ),
            ElevatedButton(
              onPressed: () => _setLanguage(context, 'hi_IN'),
              child: const Text('हिन्दी'),
            ),
            ElevatedButton(
              onPressed: () => _setLanguage(context, 'bn_BD'),
              child: const Text('বাংলা'),
            ),
          ],
        ),
      ),
    );
  }
}