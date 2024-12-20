import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:jim/firebase_options.dart';
import 'package:jim/src/api/api_service.dart';
// import 'package:jim/src/api/auth.dart';
import 'package:jim/src/base_class/firebase_notif.dart';
// import 'package:jim/src/auth/secure_storage.dart';
// import 'package:jim/src/screens/home/bottom_bar.dart';
import 'package:jim/src/screens/welcome.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await dotenv.load(fileName: ".env"); // Load environment variables
  } catch (e) {
    throw Exception('Error loading .env file: $e'); // Print error if any
  }

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await FirebaseNotification().initNotifications();

  setupInterceptors();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: WelcomeScreen(),
      );
  }
}
