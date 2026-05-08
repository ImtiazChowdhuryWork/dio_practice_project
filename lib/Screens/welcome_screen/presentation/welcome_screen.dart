import 'package:dio_practice_project/constants/text_font_style.dart';
import 'package:dio_practice_project/gen/colors.gen.dart';
import 'package:flutter/material.dart';



class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.teal,
      body: Center(child: Text('Welcome Screen',style: TextFontStyle.headline24w700cFFFFFFStylePoppins,),),
    );
    
  }
}