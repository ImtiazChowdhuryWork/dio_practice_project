import 'dart:io';

import 'package:dio_practice_project/features/counter/presentation/bindings/counter_binding.dart';
import 'package:dio_practice_project/features/counter/presentation/pages/counter_page.dart';
import 'package:dio_practice_project/features/home/presentation/bindings/home_binding.dart';
import 'package:dio_practice_project/features/home/presentation/pages/home_page.dart';
import 'package:dio_practice_project/features/sign_in/presentation/bindings/sign_in_binding.dart';
import 'package:dio_practice_project/features/sign_in/presentation/pages/sign_in_page.dart';
import 'package:dio_practice_project/features/sign_up/presentation/bindings/sign_up_binding.dart';
import 'package:dio_practice_project/features/sign_up/presentation/pages/sign_up_page.dart';
import 'package:dio_practice_project/features/welcome/presentation/pages/welcome_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Routes {
  static const String welcome = '/';
  static const String home = '/home';
  static const String counter = '/counter';
  static const String signIn = '/sign_in';
  static const String signUp = '/sign_up';

  static final appRoutes = [
    GetPage(
      name: welcome,
      page: () => const WelcomePage(),
      transition: _transition(),
      customTransition: _customTransition(),
      transitionDuration: _duration(),
    ),
    GetPage(
      name: home,
      page: () => const HomePage(),
      binding: HomeBinding(),
      transition: _transition(),
      customTransition: _customTransition(),
      transitionDuration: _duration(),
    ),
    GetPage(
      name: counter,
      page: () => const CounterPage(),
      binding: CounterBinding(),
      transition: _transition(),
      customTransition: _customTransition(),
      transitionDuration: _duration(),
    ),
    GetPage(
      name: signIn,
      page: () => const SignInPage(),
      binding: SignInBinding(),
      transition: _transition(),
      customTransition: _customTransition(),
      transitionDuration: _duration(),
    ),
    GetPage(
      name: signUp,
      page: () => const SignUpPage(),
      binding: SignUpBinding(),
      transition: _transition(),
      customTransition: _customTransition(),
      transitionDuration: _duration(),
    ),
  ];
}

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

Transition _transition() =>
    Platform.isAndroid ? Transition.fade : Transition.cupertino;

CustomTransition? _customTransition() =>
    Platform.isAndroid ? FastFadeTransition() : null;

Duration _duration() => Platform.isAndroid
    ? const Duration(milliseconds: 1)
    : const Duration(milliseconds: 300);
