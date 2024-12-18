import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:paudha_app/screens/lang_selection.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'l10n.dart';
import 'screens/home_screen.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart'; // Import dotenv package



void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  final prefs = await SharedPreferences.getInstance();
  await prefs.clear();
  final String? languageCode = prefs.getString('language_code');
  print('Language code from SharedPreferences: $languageCode');
  runApp(MyApp(locale: languageCode != null ? Locale(languageCode) : null));
}

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   final prefs = await SharedPreferences.getInstance();
//   await prefs.clear(); // Clear all stored preferences (reset app language)
//   runApp(const MyApp());
// }

class MyApp extends StatefulWidget {
  final Locale? locale;

  const MyApp({super.key, this.locale});

  static void setLocale(BuildContext context, Locale newLocale) {
    _MyAppState state = context.findAncestorStateOfType<_MyAppState>()!;
    state.setLocale(newLocale);
  }

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Locale? _locale;

  @override
  void initState() {
    super.initState();
    _locale = widget.locale;
    print('Initial locale: $_locale');
  }

  void setLocale(Locale locale) {
    setState(() {
      _locale = locale;
      print('Locale set to: $_locale');
    });
  }

  @override
  Widget build(BuildContext context) {
    print('Building app with locale: $_locale');
    return MaterialApp(
      title: 'Flutter Localization Demo',
      locale: _locale,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en', ''), // English
        Locale('hi', ''), // Hindi
        Locale('bn', ''), // Bangla
      ],
      debugShowCheckedModeBanner: false,
      home: _locale == null ? const LanguageSelectionScreen() : const HomeScreen(),
    );
  }
}
