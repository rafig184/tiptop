import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:tiptop/home.dart';
import 'package:tiptop/utils/colors.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToHome();
  }

  void _navigateToHome() async {
    await Future.delayed(Duration(seconds: 4));
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => HomePage()),
    );
  }

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
              LoadingAnimationWidget.inkDrop(
                color: backgroundColor,
                size: 50,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
