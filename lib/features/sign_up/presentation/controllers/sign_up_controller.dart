import 'package:dio_practice_project/core/constants/app_constants.dart';
import 'package:dio_practice_project/core/di/injection_container.dart';
import 'package:dio_practice_project/core/errors/exceptions.dart';
import 'package:dio_practice_project/features/sign_up/domain/usecases/sign_up_usecase.dart';
import 'package:dio_practice_project/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SignUpController extends GetxController {
  final SignUpUseCase _signUpUseCase;

  SignUpController(this._signUpUseCase);

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  final obscurePassword = true.obs;
  final obscureConfirmPassword = true.obs;
  final isLoading = false.obs;

  void togglePasswordVisibility() =>
      obscurePassword.value = !obscurePassword.value;

  void toggleConfirmPasswordVisibility() =>
      obscureConfirmPassword.value = !obscureConfirmPassword.value;

  Future<void> signUp() async {
    final name = nameController.text.trim();
    final email = emailController.text.trim();
    final password = passwordController.text.trim();
    final confirmPassword = confirmPasswordController.text.trim();

    if (name.isEmpty || email.isEmpty || password.isEmpty) {
      Get.snackbar('Error', 'All fields are required',
          snackPosition: SnackPosition.BOTTOM);
      return;
    }

    if (password != confirmPassword) {
      Get.snackbar('Error', 'Passwords do not match',
          snackPosition: SnackPosition.BOTTOM);
      return;
    }

    if (password.length < 6) {
      Get.snackbar('Error', 'Password must be at least 6 characters',
          snackPosition: SnackPosition.BOTTOM);
      return;
    }

    try {
      isLoading.value = true;

      final result = await _signUpUseCase.execute(
        name: name,
        email: email,
        password: password,
      );

      // Persist tokens
      await appData.write(kKeyAccessToken, result.accessToken);
      await appData.write(kKeyRefreshToken, result.refreshToken);
      await appData.write(kKeyIsLoggedIn, true);
      await appData.write(kKeyName, result.user.name);
      await appData.write(kKeyEmail, result.user.email);
      await appData.write(kKeyUserID, result.user.id);

      Get.offAllNamed(Routes.home);
    } on ServerException catch (e) {
      Get.snackbar('Error', e.message, snackPosition: SnackPosition.BOTTOM);
    } catch (e) {
      Get.snackbar('Error', 'Something went wrong. Please try again.',
          snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }
}
