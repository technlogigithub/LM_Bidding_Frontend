import 'package:flutter/material.dart';
import 'package:freelancer/screen/splash%20screen/mt_splash_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Freelancer App',
      theme: ThemeData(fontFamily: 'Display'),
      home: const SplashScreen(),
    );
  }
}
