import 'package:dio_practice_project/core/styles/text_styles.dart';
import 'package:dio_practice_project/core/utils/ui_helpers.dart';
import 'package:dio_practice_project/features/sign_up/presentation/controllers/sign_up_controller.dart';
import 'package:dio_practice_project/shared/widgets/custom_elevated_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class SignUpPage extends GetView<SignUpController> {
  const SignUpPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF5F7FA),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(UIHelper.kDefaulutPadding()),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: IconButton(
                  icon: const Icon(Icons.arrow_back_ios, color: Colors.black87),
                  onPressed: () => Get.back(),
                ),
              ),
              UIHelper.verticalSpace(30.h),

              ///Logo
              Center(
                child: Container(
                  height: 80,
                  width: 80,
                  decoration: BoxDecoration(
                    color: Colors.teal,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Icon(
                    Icons.person_add_outlined,
                    color: Colors.white,
                    size: 40,
                  ),
                ),
              ),
              UIHelper.verticalSpace(30.h),

              /// Ttitle
              Text(
                'Create Account',
                style: TextFontStyle.headline28w500c000000StylePoppins,
              ),

              UIHelper.verticalSpace(6.h),

              /// Sub-Title
              Text(
                'Sign up to get started',
                style: TextFontStyle.headline15w500c989898StylePoppins,
              ),

              UIHelper.verticalSpace(30.h),

              /// Label : Name
              _buildLabel('Full Name'),
              UIHelper.verticalSpace(8.h),

              ///Field : Name
              _buildTextField(
                controller: controller.nameController,
                hint: 'Enter your full name',
                prefixIcon: Icons.person_outline,
              ),
              UIHelper.verticalSpace(20.h),

              ///Label : Email
              _buildLabel('Email'),
              UIHelper.verticalSpace(8.h),

              ///Field : Email
              _buildTextField(
                controller: controller.emailController,
                hint: 'Enter your email',
                prefixIcon: Icons.email_outlined,
                keyboardType: TextInputType.emailAddress,
              ),
              UIHelper.verticalSpace(20.h),

              ///Label : Password
              _buildLabel('Password'),
              UIHelper.verticalSpace(8.h),

              ///Field : password
              Obx(
                () => _buildTextField(
                  controller: controller.passwordController,
                  hint: 'Minimum 6 characters',
                  prefixIcon: Icons.lock_outline,
                  obscure: controller.obscurePassword.value,
                  suffixIcon: IconButton(
                    onPressed: controller.togglePasswordVisibility,
                    icon: Icon(
                      controller.obscurePassword.value
                          ? Icons.visibility_off
                          : Icons.visibility,
                    ),
                  ),
                ),
              ),

              UIHelper.verticalSpace(20.h),

              ///Label : Confirm Password
              _buildLabel('Confirm Password'),
              UIHelper.verticalSpace(8.h),

              ///Field : Confirm Password
              Obx(
                () => _buildTextField(
                  controller: controller.confirmPasswordController,
                  hint: 'Re-enter your password',
                  prefixIcon: Icons.lock_outline,
                  obscure: controller.obscureConfirmPassword.value,
                  suffixIcon: IconButton(
                    onPressed: controller.toggleConfirmPasswordVisibility,
                    icon: Icon(
                      controller.obscureConfirmPassword.value
                          ? Icons.visibility_off
                          : Icons.visibility,
                    ),
                  ),
                ),
              ),

              UIHelper.verticalSpace(32.h),

              /// Sign up button
              Obx(
                () => CustomElevatedButton(
                  buttonColor: Colors.teal,
                  isLoading: controller.isLoading.value,
                  isDisabled: controller.isLoading.value,
                  buttonTitle: 'Sign Up',
                  onTap: controller.signUp,
                ),
              ),

              UIHelper.verticalSpace(20.h),

              //// Already have an account -> sign in
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Already have an account? ',
                    style: TextFontStyle.headline15w500c989898StylePoppins,
                  ),
                  GestureDetector(
                    onTap: () => Get.back(),
                    child: Text(
                      'Sign In',
                      style: TextFontStyle.headline15w500TealStylePoppins,
                    ),
                  ),
                ],
              ),

              UIHelper.verticalSpace(20.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required IconData prefixIcon,
    bool obscure = false,
    Widget? suffixIcon,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscure,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        hintText: hint,
        prefixIcon: Icon(prefixIcon),
        suffixIcon: suffixIcon,
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
