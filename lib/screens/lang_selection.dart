import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../main.dart';

class LanguageSelectionScreen extends StatelessWidget {
  const LanguageSelectionScreen({super.key});

  Future<void> _setLocale(BuildContext context, Locale locale) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('language_code', locale.languageCode);

    // Restart the app with the new locale
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => MyApp(locale: locale)),
      (route) => false,
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
              onPressed: () => _setLocale(context, const Locale('en')),
              child: const Text('English'),
            ),
            ElevatedButton(
              onPressed: () => _setLocale(context, const Locale('hi')),
              child: const Text('हिन्दी'),
            ),
            ElevatedButton(
              onPressed: () => _setLocale(context, const Locale('bn')),
              child: const Text('বাংলা'),
            ),
          ],
        ),
      ),
    );
  }
}
