import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:dio_practice_project/core/constants/app_constants.dart';
import 'package:dio_practice_project/core/di/injection_container.dart';
import 'package:dio_practice_project/core/styles/text_styles.dart';
import 'package:dio_practice_project/gen/colors.gen.dart';
import 'package:dio_practice_project/shared/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

void initDefaultStorageValues() {
  appData.writeIfNull(kKeyfirstTime, true);
  appData.writeIfNull(kKeySignUpToken, '');
  appData.writeIfNull(kKeyForgotPasswordToken, '');
  if (!appData.hasData(kKeyAccessToken)) {
    appData.writeIfNull(kKeyIsLoggedIn, false);
  }
}

Future<void> initDeviceId() async {
  final deviceInfo = DeviceInfoPlugin();
  if (Platform.isIOS) {
    final iosInfo = await deviceInfo.iosInfo;
    appData.writeIfNull(kKeyDeviceID, iosInfo.identifierForVendor);
  } else if (Platform.isAndroid) {
    final androidInfo = await deviceInfo.androidInfo;
    appData.writeIfNull(kKeyDeviceID, androidInfo.id);
  }
}

void setInitialLanguagePreference() {
  appData.writeIfNull(kKeyEnglish, true);
  appData.writeIfNull(kKeySouthKorean, false);
}

void showMaterialDialog(BuildContext context) {
  showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(
        'Do you want to exit the app?',
        textAlign: TextAlign.center,
        style: TextFontStyle.headline12w500cfefefeStylePoppins,
      ),
      actions: <Widget>[
        CustomButton(
          text: 'No',
          onTap: () => Navigator.of(context).pop(false),
          height: 30.sp,
          minWidth: .3.sw,
          borderRadius: 30.r,
          color: AppColors.cF0F0F0,
          textStyle: TextFontStyle.headline12w500cfefefeStylePoppins,
        ),
        CustomButton(
          text: 'Yes',
          onTap: () {
            if (Platform.isAndroid) {
              SystemNavigator.pop();
            } else if (Platform.isIOS) {
              exit(0);
            }
          },
          height: 30.sp,
          minWidth: .3.sw,
          borderRadius: 30.r,
          color: AppColors.cb20000,
          textStyle: TextFontStyle.headline12w500cfefefeStylePoppins,
        ),
      ],
    ),
  );
}

void configureSystemUI() {
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Color.fromARGB(80, 0, 0, 0),
      statusBarIconBrightness: Brightness.light,
    ),
  );

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
}
