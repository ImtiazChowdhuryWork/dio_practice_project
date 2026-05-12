import 'dart:developer';

import 'package:dio_practice_project/core/constants/app_constants.dart';
import 'package:dio_practice_project/core/di/injection_container.dart';
import 'package:dio_practice_project/core/utils/helper_methods.dart';
import 'package:dio_practice_project/core/utils/post_login.dart';
import 'package:dio_practice_project/features/home/presentation/pages/home_page.dart';
import 'package:dio_practice_project/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
    initDefaultStorageValues();
    await initDeviceId();
    await Future.delayed(const Duration(seconds: 2));

    final bool isLoggedIn = appData.read(kKeyAccessToken) != null;
    final bool isFirstTime = appData.read(kKeyfirstTime) ?? false;

    log('isFirstTime: $isFirstTime');
    log('isLoggedIn: $isLoggedIn');

    if (isLoggedIn) {
      await performPostLoginActions();
      Get.offAllNamed(Routes.home);
    } else {
      Get.offAll(() => const HomePage());
    }

    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading ? const HomePage() : const SizedBox.shrink();
  }
}
