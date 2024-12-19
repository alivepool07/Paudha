import 'dart:async'; // For Timer
import 'package:flutter/material.dart';
import 'package:paudha_app/translations/locale_keys.g.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:validators/validators.dart'; // For IP address validation
import 'package:easy_localization/easy_localization.dart';
import '../widgets/diagnosis_section.dart';
import '../widgets/crop_selection.dart';
import '../translations/locale_keys.g.dart'; // Import the generated keys

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _ipController = TextEditingController();
  String? _savedIpAddress;
  bool _isIpValid = false;

  late PageController _pageController;
  Timer? _autoSlideTimer;

  @override
  void initState() {
    super.initState();
    _loadIpAddress();
    _pageController = PageController(initialPage: 0);
    _startAutoSlide();
  }

  void _startAutoSlide() {
    _autoSlideTimer = Timer.periodic(const Duration(seconds: 3), (Timer timer) {
      if (_pageController.hasClients) {
        int nextPage = (_pageController.page!.toInt() + 1) % 4;
        _pageController.animateToPage(
          nextPage,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeIn,
        );
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    _autoSlideTimer?.cancel(); // Cancel the timer
    super.dispose();
  }

  Future<void> _loadIpAddress() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _savedIpAddress = prefs.getString('server_ip');
      _ipController.text = _savedIpAddress ?? '';
      _isIpValid = isIP(_ipController.text);
    });
  }

  Future<void> _saveIpAddress() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('server_ip', _ipController.text);
    setState(() {
      _savedIpAddress = _ipController.text;
      _isIpValid = isIP(_ipController.text);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(LocaleKeys.title.tr()), // Updated to use LocaleKeys
        automaticallyImplyLeading: false, // Remove default leading widget
        actions: [
          Builder(
            builder: (context) => IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () {
                Scaffold.of(context).openEndDrawer(); // Open right-side drawer
              },
            ),
          ),
        ],
      ),
      endDrawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: const BoxDecoration(
                color: Colors.blue,
              ),
              child: Text(
                LocaleKeys.settings.tr(), // Updated to use LocaleKeys
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              title: Text(LocaleKeys.server_Ip_Address
                  .tr()), // Updated to use LocaleKeys
              subtitle: TextField(
                controller: _ipController,
                decoration: InputDecoration(
                  hintText: LocaleKeys.enter_Ip_Address
                      .tr(), // Updated to use LocaleKeys
                  errorText: _isIpValid
                      ? null
                      : LocaleKeys.invalid_Ip_Address
                          .tr(), // Updated to use LocaleKeys
                ),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  setState(() {
                    _isIpValid = isIP(value);
                  });
                },
              ),
            ),
            ListTile(
              title: ElevatedButton(
                onPressed: _isIpValid
                    ? () {
                        _saveIpAddress();
                        Navigator.pop(context); // Close the drawer
                      }
                    : null,
                child: Text(LocaleKeys.save.tr()), // Updated to use LocaleKeys
              ),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Container for controlling image gallery
            Container(
              height: 360.0, // Set the height of the container
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16.0), // Rounded edges
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5), // Shadow color
                    spreadRadius: 5, // Spread radius
                    blurRadius: 7, // Blur radius
                    offset: const Offset(0, 3), // Shadow position
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(
                    16.0), // Clip the images with rounded edges
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: 4, // Number of images
                  itemBuilder: (context, index) {
                    return Image.asset(
                      'assets/images/img${index + 1}.jpg',
                      fit:
                          BoxFit.cover, // Ensure the image covers the container
                    );
                  },
                ),
              ),
            ),
            const SizedBox(
                height: 30), // Space between image gallery and DiagnosisSection
            const DiagnosisSection(),
            const SizedBox(
                height:
                    30), // Space between DiagnosisSection and crop selection title
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                LocaleKeys.Select_your_crop.tr(), // Updated to use LocaleKeys
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            const Expanded(
                child:
                    CropSelection()), // Ensure CropSelection is localized if necessary
          ],
        ),
      ),
    );
  }
}
