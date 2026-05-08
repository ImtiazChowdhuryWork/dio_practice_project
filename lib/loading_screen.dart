import 'dart:developer';
import 'package:dio_practice_project/Screens/Home/presentation/home_screen.dart';
import 'package:dio_practice_project/constants/app_constants.dart';
import 'package:dio_practice_project/helper/post_login.dart';
import 'package:dio_practice_project/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'helper/di.dart';
import 'helper/logger_util.dart';
import 'helper/helper_methods.dart';

final class Loading extends StatefulWidget {
  const Loading({super.key});

  @override
  State<Loading> createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    // Initialize default values first
    await setInitValue();

    final bool isLoggedIn = appData.read(kKeyAccessToken) != null;
    final bool isFirstTime = appData.read(kKeyfirstTime) ?? false;

    log('isFirstTime: $isFirstTime');
    log('isLoggedIn: $isLoggedIn');

    if (isLoggedIn) {
      await performPostLoginActions();

      // Navigate via GetX so bindings are applied
      Get.offAllNamed(Routes.homeScreen); // Make sure this route is in GetMaterialApp
    } else {
      // Not logged in
      // if (!Get.isRegistered<NetworkCaller>()) Get.put(NetworkCaller());

      // if (!Get.isRegistered<SignInRepository>()) Get.put(SignInRepository(Get.find()));

      // if (!Get.isRegistered<SignInScreenController>()) {
      //   Get.put(SignInScreenController(Get.find()));
      // }

      final Widget startScreen = isFirstTime ? HomeScreen() : HomeScreen();
      // Navigate via GetX
      Get.offAll(() => startScreen);
    }

    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    // Show a loading/welcome screen until navigation is done
    return _isLoading ? const HomeScreen() : const SizedBox.shrink();
  }
}
