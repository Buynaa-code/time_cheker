import 'package:flutter/material.dart';

import 'package:time_cheker/const/colors.dart';
import 'package:time_cheker/const/text_field.dart';
import 'package:time_cheker/screens/login/login_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      body: Stack(
        children: [
          // Background image
          Positioned(
            top: 0,
            child: Image.asset(
              'assets/background.png', // Replace with your image asset
              fit: BoxFit.cover, // Ensures the image covers the area
            ),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: Image.asset(
              'assets/asd.png', // Replace with your image asset
              fit: BoxFit.cover, // Ensures the image covers the area
              width: MediaQuery.of(context).size.width * 0.8,
            ),
          ),
          // Onboarding content
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Onboarding Title and Description
                Text(
                  'Тавтай морилно уу!',
                  style: ktsBodyLarge.copyWith(color: greyColor6),
                ),
                const SizedBox(height: 20),
                Text(
                  'Та өөрийн ажлын',
                  style: ktsBodyMassiveBold.copyWith(color: greyColor8),
                  textAlign: TextAlign.center,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      ' цагаа хянах боломжтой',
                      style: ktsBodyMassiveBold.copyWith(color: greyColor8),
                    ),
                  ],
                ),
                const SizedBox(height: 30),

                // Toggle Button

                const SizedBox(height: 20),

                // Next Button
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LoginScreen(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: whiteColor,
                    backgroundColor: informationColor0,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 40, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.arrow_forward, color: whiteColor),
                      const SizedBox(width: 8),
                      Text(
                        'Эхлэх',
                        style: ktsBodyLarge.copyWith(color: whiteColor),
                      ),
                      const SizedBox(width: 8),
                      const Icon(Icons.double_arrow, color: whiteColor),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
