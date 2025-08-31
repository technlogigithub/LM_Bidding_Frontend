import 'package:flutter/material.dart';
import 'package:freelancer/screen/splash%20screen/mt_splash_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Freelancer App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: 'Display'),
      home: const SplashScreen(),
    );
  }
}
