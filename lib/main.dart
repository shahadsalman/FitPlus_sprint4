import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:fitplus/firebase/fb_notifications.dart';
import 'package:fitplus/firebase_options.dart';
import 'package:fitplus/services/location_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:get/get.dart';

// ignore: unused_import
import 'screens/home/mainGym.dart';
import 'screens/splash_screens/splash_screens.dart';
//latest v3
String userID = "";
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await FbNotifications.initNotifications();
  Get.put(LocationService());
  Stripe.publishableKey = 'pk_test_51KeFcDDG7u6dEAF5uEVLgT3kkVZOobiEMhaLel7c9i3zGqfESV3wCAZhF8FAvW7LyAZcTx9A5nc90KsbbE6baknq00f1CSz81Q';
  runApp(const MyApp());
}

final auth = FirebaseAuth.instance;

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home: const SplashScreen(),
      theme: Theme.of(context).copyWith(
          inputDecorationTheme: InputDecorationTheme(
        errorStyle: TextStyle(color: Colors.red, fontSize: 12, height: 0.4),
      )),
    );
  }
}
