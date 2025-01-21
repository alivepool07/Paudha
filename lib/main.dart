import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:paudha_app/api_stuff.dart';
import 'package:paudha_app/translations/locale_keys.g.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'screens/home_screen.dart';
import 'screens/lang_selection.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env"); // Load environment variables
  await EasyLocalization.ensureInitialized();
  final apiService = ApiService('http://192.168.1.10:8050');

  final prefs = await SharedPreferences.getInstance();
  final String? languageCode = prefs.getString('language_code');
  print('Language code from SharedPreferences: $languageCode');

  Locale? startLocale;
  if (languageCode != null) {
    final parts = languageCode.split('_');
    if (parts.length == 2) {
      startLocale = Locale(parts[0], parts[1]);
    } else {
      startLocale = Locale(languageCode);
    }
  }

  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('en', 'US'), Locale('hi', 'IN'), Locale('bn', 'BD')],
      path: 'assets/translations', // translation files
      fallbackLocale: const Locale('en', 'US'),
      //assetLoader: CodegenLoader(),
      startLocale: startLocale,
      child: const MyApp(),
    ),
  );
}

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
  
  var apiService;

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
      title: LocaleKeys.title.tr(),
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      debugShowCheckedModeBanner: false,
      home: _locale == null ? const LanguageSelectionScreen() : HomeScreen(apiService: apiService),
    );
  }
}