# Code Citations

## License: unknown
https://github.com/eslamfaisal/RawanBeauty/tree/27c875305e599cd5ffd3feb6f809a5befcd631b4/lib/main.dart

```
void setLocale(BuildContext context, Locale newLocale) {
    _MyAppState state = context.findAncestorStateOfType<_MyAppState>()!;
    state.setLocale(newLocale);
  }

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Locale? _locale
```


## License: unknown
https://github.com/IsuruBRanapana/Flutter/tree/bd791722561098999b35e9d4d7edbfc0447a066f/localization/my_localization/lib/app_localizations.dart

```
';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  static AppLocalizations of(BuildContext context) {
    return Localizations
```


## License: unknown
https://github.com/samirRibeiro77/daily_helper/tree/b597fc740ad45a9073ea047aa8599aa93e21d0df/lib/app_localizations.dart

```
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations
```


## License: unknown
https://github.com/santriarustamyan/Snapchat/tree/00c1a8dac16f812bcb23a70ac2189d9e117e90d3/lib/class/app_localizations.dart

```
flutter/material.dart';
import 'package:flutter/services.dart';

class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }
```


## License: MIT
https://github.com/alejandrocatalan/TFG-AC-Partes-Trabajo/tree/ca5f5ae08ffa0b8ba01a3d3782d83a12aa66ef0d/tfg_ac_partes_trabajo/lib/utils/app_localizations.dart

```
dart';
import 'package:flutter/services.dart';

class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<
```

