import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:garbo/screens/landing.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    FirebaseOptions options = FirebaseOptions(
      apiKey: 'AIzaSyD-wowkyK_iDUFxD7FeRRDSM5T6q7FQKdI',
      appId: '1:576873723625:android:bdb8170dcd48f2d57be278',
      messagingSenderId: '576873723625',
      projectId: 'garbo-85be1',
    );
    await Firebase.initializeApp(options: options);
    runApp(const MyApp());
  } catch (e) {
    print("Firebase initialization error: $e");
  }
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Auth App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const LandingPage(), // Set the initial route to the landing page
    );
  }
}
