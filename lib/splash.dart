import 'package:flutter/material.dart';
import 'package:tiptop/utils/colors.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: primaryColor,
        // Center the content vertically and horizontally
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'images/logo2.png', // Adjust the path to your logo image
                width: 300, // Set the width of the image
                height: 300, // Set the height of the image
                fit: BoxFit.contain,
              ),
              const SizedBox(
                  height:
                      20), // Add some space between the image and the loader
              // LoadingAnimationWidget.threeRotatingDots(
              //   color: Colors.white,
              //   size: 50,
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
