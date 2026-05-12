import 'package:dio_practice_project/core/styles/text_styles.dart';
import 'package:flutter/material.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.teal,
      body: Center(
        child: Text(
          'Welcome Screen',
          style: TextFontStyle.headline24w700cFFFFFFStylePoppins,
        ),
      ),
    );
  }
}
