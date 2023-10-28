import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:movie_tracker/models/watch_list.dart';
import 'package:movie_tracker/screens/authentication/login.dart';
import 'package:provider/provider.dart';

import 'models/theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    const MyApp(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => Watchlist()),
        ChangeNotifierProvider(create: (context) => ThemeController()),
      ],
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Movie Tracking App',
        home: LoginScreen(),
      ),
    );
  }
}
