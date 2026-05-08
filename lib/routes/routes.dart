import 'dart:io';


import 'package:dio_practice_project/Screens/Home/presentation/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../Screens/welcome_screen/presentation/welcome_screen.dart';


class Routes {
  ///Section : Common Screens Routing
  ///Section : Normal Users Routing

  static const String welcomeScreen = '/';
  static const String onboardingScreen = '/onboarding_screen';
  static const String homeScreen = '/home_screen';
  

  static final appRoutes = [
    ///Splash Screen
    GetPage(
      name: welcomeScreen,
      page: () => WelcomeScreen(),
      transition: _transition(),
      customTransition: _customTransition(),
      transitionDuration: _duration(),
    ),


    ///Splash Screen
    GetPage(
      name: homeScreen,
      page: () => HomeScreen(),
      transition: _transition(),
      customTransition: _customTransition(),
      transitionDuration: _duration(),
    ),






  ];
}

/// Custom ultra-fast fade for Android
class FastFadeTransition extends CustomTransition {
  @override
  Widget buildTransition(
    BuildContext context,
    Curve? curve,
    Alignment? alignment,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return FadeTransition(opacity: animation, child: child);
  }
}

/// Utility method to apply platform-aware transitions
Transition _transition() =>
    Platform.isAndroid ? Transition.fade : Transition.cupertino;

CustomTransition? _customTransition() =>
    Platform.isAndroid ? FastFadeTransition() : null;

Duration _duration() => Platform.isAndroid
    ? const Duration(milliseconds: 1)
    : const Duration(milliseconds: 300);


// /// All GetPages in your app
// final List<GetPage> appRoutes = [

//   GetPage(
//     name: AppRoutes.notificationsScreen,
//     page: () => NotificationsScreen(),
//     transition: _transition(),
//     customTransition: _customTransition(),
//     transitionDuration: _duration(),
//   ),

//   /// 🟢 Example: Using typed arguments model
//   GetPage(
//     name: AppRoutes.editProfileScreen,
//     page: () {
//       final args = Get.arguments as EditProfileArgs;
//       return EditProfileScreen(
//         firstName: args.firstName,
//         lastName: args.lastName,
//         email: args.email,
//         phone: args.phone,
//         address: args.address,
//         profileImage: args.profileImage,
//         age: args.age,
//         city: args.city,
//         country: args.country,
//       );
//     },
//     transition: _transition(),
//     customTransition: _customTransition(),
//     transitionDuration: _duration(),
//   ),


// ];
