
//-------------------------------v2-------------------
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:validators/validators.dart'; // Import for IP address validation
import '../l10n.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _ipController = TextEditingController();
  String? _savedIpAddress;

  @override
  void initState() {
    super.initState();
    _loadIpAddress();
  }

  // Load the saved IP address from SharedPreferences
  Future<void> _loadIpAddress() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _savedIpAddress = prefs.getString('server_ip');
      _ipController.text = _savedIpAddress ?? '';
    });
  }

  // Save the IP address to SharedPreferences
  Future<void> _saveIpAddress() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('server_ip', _ipController.text);
    setState(() {
      _savedIpAddress = _ipController.text;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(AppLocalizations.of(context).translate('save') +
            ' ' +
            AppLocalizations.of(context).translate('serverIpAddress') +
            '!'),
      ),
    );
  }

  // Validate the IP address format
  bool _isValidIpAddress(String ip) {
    return isIP(ip);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).translate('title')),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: const BoxDecoration(
                color: Colors.blue,
              ),
              child: Text(
                AppLocalizations.of(context).translate('settings'),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              title: Text(AppLocalizations.of(context)
                  .translate('serverIpAddress')),
              subtitle: TextField(
                controller: _ipController,
                decoration: InputDecoration(
                  hintText: AppLocalizations.of(context)
                      .translate('enterIpAddress'),
                  errorText: _ipController.text.isEmpty ||
                          _isValidIpAddress(_ipController.text)
                      ? null
                      : 'Invalid IP address',
                ),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  setState(() {});
                },
              ),
            ),
            ListTile(
              title: ElevatedButton(
                onPressed: _isValidIpAddress(_ipController.text)
                    ? () {
                        _saveIpAddress();
                        Navigator.pop(context); // Close the drawer
                      }
                    : null,
                child: Text(AppLocalizations.of(context).translate('save')),
              ),
            ),
          ],
        ),
      ),
      body: Center(
        child: Text(
          AppLocalizations.of(context).translate('savedIpAddress').replaceFirst(
              '{ip}', _savedIpAddress ?? AppLocalizations.of(context).translate('none')),
          style: const TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
