// import 'package:flutter/material.dart';
// import 'pages/splash.dart'; // Import SplashPage

// void main() {
//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'New Project',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       home: SplashScreen(),
//       debugShowCheckedModeBanner: false, // Set SplashPage as the initial route
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(PaudhaApp());
}

class PaudhaApp extends StatelessWidget {
  const PaudhaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Paudha',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: HomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
