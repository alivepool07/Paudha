// // ignore_for_file: use_build_context_synchronously

// import 'package:flutter/material.dart';
// import 'package:easy_localization/easy_localization.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import '../main.dart';
// import 'home_screen.dart';

// class LanguageSelectionScreen extends StatelessWidget {
//   const LanguageSelectionScreen({super.key});

//   Future<void> _setLanguage(BuildContext context, String languageCode) async {
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.setString('language_code', languageCode);
//     await context.setLocale(Locale(languageCode.split('_')[0], languageCode.split('_').length > 1 ? languageCode.split('_')[1] : '')); // Set the locale dynamically
//     MyApp.setLocale(context, Locale(languageCode.split('_')[0], languageCode.split('_').length > 1 ? languageCode.split('_')[1] : ''));
//     Navigator.pushReplacement(
//       context,
//       MaterialPageRoute(builder: (_) => const HomeScreen()),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Select Language'),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             ElevatedButton(
//               onPressed: () => _setLanguage(context, 'en_US'),
//               child: const Text('English'),
//             ),
//             ElevatedButton(
//               onPressed: () => _setLanguage(context, 'hi_IN'),
//               child: const Text('हिन्दी'),
//             ),
//             ElevatedButton(
//               onPressed: () => _setLanguage(context, 'bn_BD'),
//               child: const Text('বাংলা'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

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
    await context.setLocale(
      Locale(languageCode.split('_')[0],
          languageCode.split('_').length > 1 ? languageCode.split('_')[1] : ''),
    ); // Set the locale dynamically
    MyApp.setLocale(
      context,
      Locale(languageCode.split('_')[0],
          languageCode.split('_').length > 1 ? languageCode.split('_')[1] : ''),
    );
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const HomeScreen()),
    );
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
        mainAxisAlignment: MainAxisAlignment.center, // Centers the items vertically
        crossAxisAlignment: CrossAxisAlignment.center, // Centers the items horizontally
        children: [
          _buildLanguageCircle(context, 'en_US', 'English', 'E', Colors.blue),
          const SizedBox(height: 20), // Add spacing between circles
          _buildLanguageCircle(context, 'hi_IN', 'हिन्दी', 'ह', Colors.orange.shade200),
          const SizedBox(height: 20), // Add spacing between circles
          _buildLanguageCircle(context, 'bn_BD', 'বাংলা', 'বা', Colors.green.shade300),
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
  ) {
    return InkWell(
      onTap: () => _setLanguage(context, languageCode),
      borderRadius: BorderRadius.circular(50),
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
    );
  }
}
