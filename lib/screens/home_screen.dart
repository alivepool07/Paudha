
import 'dart:async'; // For Timer
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:validators/validators.dart'; // For IP address validation
import '../widgets/diagnosis_section.dart';
import '../widgets/crop_selection.dart';

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
  int _currentPage = 0;

  // Load the saved IP address from SharedPreferences
  Future<void> _loadIpAddress() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _savedIpAddress = prefs.getString('server_ip');
      _ipController.text = _savedIpAddress ?? '';
      _isIpValid = isIP(_ipController.text);
    });
  }

  // Save the IP address to SharedPreferences
  Future<void> _saveIpAddress() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('server_ip', _ipController.text);
    setState(() {
      _savedIpAddress = _ipController.text;
    });
    Navigator.pop(context); // Close drawer safely
  }

  @override
  void initState() {
    super.initState();
    _loadIpAddress();
    _ipController.addListener(() {
      setState(() {
        _isIpValid = isIP(_ipController.text);
      });
    });

    // Initialize PageController
    _pageController = PageController();

    // Start the timer for auto-sliding
    _startAutoSlide();
  }

  void _startAutoSlide() {
    _autoSlideTimer = Timer.periodic(const Duration(milliseconds: 1500), (timer) {
      if (_pageController.hasClients) {
        _currentPage++;
        if (_currentPage >= 4) {
          _currentPage = 0; // Reset to the first image
        }
        _pageController.animateToPage(
          _currentPage,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _ipController.dispose();
    _pageController.dispose();
    _autoSlideTimer?.cancel(); // Cancel the timer
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Paudha'),
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
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 15, 205, 40),
              ),
              child: Text(
                'Settings',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
            ListTile(
              title: const Text('Server IP Address'),
              subtitle: TextField(
                controller: _ipController,
                decoration: InputDecoration(
                  hintText: 'Enter your server IP address',
                  errorText: _isIpValid || _ipController.text.isEmpty
                      ? null
                      : 'Invalid IP address',
                ),
                keyboardType: TextInputType.number,
              ),
            ),
            ListTile(
              title: ElevatedButton(
                onPressed: _isIpValid
                    ? () {
                        _saveIpAddress(); // Save and close drawer
                      }
                    : null,
                child: const Text('Save IP Address'),
              ),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Image gallery
            Container(
              height: 350.0,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20.0),
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: 4,
                  itemBuilder: (context, index) {
                    return Image.asset(
                      'assets/images/img${index + 1}.jpg',
                      fit: BoxFit.cover,
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 30),
            DiagnosisSection(),
            const SizedBox(height: 30),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Select your crop',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 20),
            const Expanded(child : CropSelection()),
          ],
        ),
      ),
    );
  }
}


// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:paudha_app/l10n.dart';
// import 'package:paudha_app/widgets/crop_selection.dart';
// import 'package:paudha_app/widgets/diagnosis_section.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:validators/validators.dart'; // Import for IP address validation
// import 'package:paudha_app/widgets/diagnosis_section.dart';
// import 'package:paudha_app/widgets/crop_selection.dart';
// import 'package:paudha_app/l10n.dart';
// class HomeScreen extends StatefulWidget {
//   const HomeScreen({super.key});

//   @override
//   _HomeScreenState createState() => _HomeScreenState();
// }

// class _HomeScreenState extends State<HomeScreen> {
//   final TextEditingController _ipController = TextEditingController();
//   String? _savedIpAddress;
//   late PageController _pageController;
//   late Timer _timer;
//   int _currentPage = 0;

//   final List<String> imageList = [
//     'assets/images/img1.jpg',
//     'assets/images/img2.jpg',
//     'assets/images/img3.jpg',
//     'assets/images/img4.jpg',
//   ];

//   @override
//   void initState() {
//     super.initState();
//     _loadIpAddress();
//     _pageController = PageController(initialPage: _currentPage);
//     _timer = Timer.periodic(Duration(seconds: 1, milliseconds: 500), (Timer timer) {
//       if (_currentPage < imageList.length - 1) {
//         _currentPage++;
//       } else {
//         _currentPage = 0;
//       }

//       _pageController.animateToPage(
//         _currentPage,
//         duration: Duration(milliseconds: 300),
//         curve: Curves.easeIn,
//       );
//     });
//   }

//   @override
//   void dispose() {
//     _pageController.dispose();
//     _timer.cancel();
//     super.dispose();
//   }

//   // Load the saved IP address from SharedPreferences
//   Future<void> _loadIpAddress() async {
//     final prefs = await SharedPreferences.getInstance();
//     setState(() {
//       _savedIpAddress = prefs.getString('server_ip');
//       _ipController.text = _savedIpAddress ?? '';
//     });
//   }

//   // Save the IP address to SharedPreferences
//   Future<void> _saveIpAddress() async {
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.setString('server_ip', _ipController.text);
//     setState(() {
//       _savedIpAddress = _ipController.text;
//     });
//   }

//   // Validate the IP address format
//   bool _isValidIpAddress(String ip) {
//     return isIP(ip);
//   }

//   @override
//   Widget build(BuildContext context) {
//     final localizations = AppLocalizations.of(context);

//     return Scaffold(
//       appBar: AppBar(
//         title: Text(localizations.translate('title')),
//       ),
//       drawer: Drawer(
//         child: ListView(
//           padding: EdgeInsets.zero,
//           children: <Widget>[
//             DrawerHeader(
//               decoration: BoxDecoration(
//                 color: Colors.blue,
//               ),
//               child: Text(
//                 localizations.translate('settings'),
//                 style: TextStyle(
//                   color: Colors.white,
//                   fontSize: 24,
//                 ),
//               ),
//             ),
//             ListTile(
//               title: Text(localizations.translate('serverIpAddress')),
//               subtitle: TextField(
//                 controller: _ipController,
//                 decoration: InputDecoration(
//                   hintText: localizations.translate('enterIpAddress'),
//                   errorText: _isValidIpAddress(_ipController.text) ? null : localizations.translate('invalidIpAddress'),
//                 ),
//                 keyboardType: TextInputType.number,
//                 onChanged: (value) {
//                   setState(() {});
//                 },
//               ),
//             ),
//             ListTile(
//               title: ElevatedButton(
//                 onPressed: _isValidIpAddress(_ipController.text)
//                     ? () {
//                         _saveIpAddress();
//                         Navigator.pop(context); // Close the drawer
//                       }
//                     : null,
//                 child: Text(localizations.translate('save')),
//               ),
//             ),
//           ],
//         ),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             // Container for controlling image gallery
//             Container(
//               height: 300.0, // Set the height of the container
//               child: PageView.builder(
//                 controller: _pageController,
//                 itemCount: imageList.length,
//                 itemBuilder: (context, index) {
//                   return Image.asset(
//                     imageList[index],
//                     fit: BoxFit.cover, // Ensure the image covers the container
//                   );
//                 },
//               ),
//             ),
//             const SizedBox(height: 30), // Space between image gallery and DiagnosisSection
//             const DiagnosisSection(),
//             const SizedBox(height: 30), // Space between DiagnosisSection and crop selection title
//             const Align(
//               alignment: Alignment.centerLeft,
//               child: Text(
//                 'Select your crop',
//                 style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//               ),
//             ),
//             Expanded(child: CropSelection()), // Corrected line
//           ],
//         ),
//       ),
//     );
//   }
// }