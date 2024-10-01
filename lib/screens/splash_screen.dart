import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Navigate to home page after 5 seconds
    Future.delayed(const Duration(seconds: 4), () {
      context.go('/country');
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,  // Ensures the container takes full width
        height: double.infinity, // Ensures the container takes full height
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/flags.gif"), // Ensure this path is correct
            fit: BoxFit.fitHeight, // This makes the image cover the whole screen
          ),
        ),
      ),
    );
  }
}
