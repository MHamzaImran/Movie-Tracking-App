import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_tracker/screens/authentication/login.dart';
import 'package:movie_tracker/screens/home/profile/profileData.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();

  runApp(
    BlocProvider(
      create: (context) =>
          ProfileCubit(), // Create your ProfileCubit instance here
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
        value: context.read<ProfileCubit>(),
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Movie Tracking App',
          home: LoginScreen(),
        ));
  }
}
