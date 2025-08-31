import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

import 'providers/user_provider.dart';
import 'providers/transaction_provider.dart';
import 'pages/welcome.dart';
import 'pages/home/home.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    print('✅ Firebase initialized successfully');
  } catch (e) {
    print('❌ Firebase initialization failed: $e');
  }

  runApp(const CashOutApp());
}

class CashOutApp extends StatelessWidget {
  const CashOutApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (context) => TransactionProvider(context)),
      ],
      child: const AppWithTheme(),
    );
  }
}

class AppWithTheme extends StatelessWidget {
  const AppWithTheme({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(
      builder: (context, userProvider, _) {
        final initialPage = userProvider.isLoggedIn ? const HomePage() : const WelcomePage();

        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Cash Out',
          theme: userProvider.currentTheme,
          home: initialPage,
        );
      },
    );
  }
}
