import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'pages/welcome.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  Future<FirebaseApp> _initializeFirebase() async {
    return Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cash Out',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home: FutureBuilder(
        future: _initializeFirebase(),
        builder: (context, snapshot) {
          // 🔥 If Firebase is still loading, we still show WelcomePage instantly
          if (snapshot.connectionState == ConnectionState.done) {
            return const WelcomePage();
          } else {
            // Firebase initializing in background, but don't delay the UI
            return const WelcomePage();
          }
        },
      ),
    );
  }
}
