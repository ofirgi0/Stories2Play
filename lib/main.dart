import 'package:flutter/material.dart';
import 'views/login_screen.dart';
import 'views/main_screen.dart'; // <- create next
import 'views/story_screen.dart'; // ← we’ll create this soon



void main() {
  runApp(const Stories2PlayApp());
}

class Stories2PlayApp extends StatelessWidget {
  const Stories2PlayApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Stories2Play',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue),
      initialRoute: '/',
      routes: {
        '/': (context) => const LoginScreen(),
        '/main': (context) => const MainScreen(),
        // '/story': (context) => const StoryScreen(), // temporary
      },
    );
  }
}
