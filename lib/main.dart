import 'package:dio_practice_project/bindings/controllers_binding.dart';
import 'package:dio_practice_project/core/di/injection_container.dart';
import 'package:dio_practice_project/core/utils/helper_methods.dart';
import 'package:dio_practice_project/loading_screen.dart';
import 'package:dio_practice_project/localization/presentation/language_preference.dart';
import 'package:dio_practice_project/localization/presentation/languages.dart';
import 'package:dio_practice_project/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  await diSetup();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    configureSystemUI();
    initDefaultStorageValues();
    return const UtilScreenMobile();
  }
}

class UtilScreenMobile extends StatelessWidget {
  const UtilScreenMobile({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(440, 956),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (_, child) {
        return PopScope(
          canPop: false,
          onPopInvokedWithResult: (bool didPop, _) async {
            showMaterialDialog(context);
          },
          child: GetMaterialApp(
            debugShowCheckedModeBanner: false,
            translations: Languages(),
            locale: LanguagePreference.getSavedLocale(),
            fallbackLocale: const Locale('en', 'US'),
            builder: (context, widget) {
              if (Get.locale != null) {
                LanguagePreference.saveLocale(Get.locale!);
              }
              return MediaQuery(
                data: MediaQuery.of(context),
                child: widget!,
              );
            },
            getPages: Routes.appRoutes,
            initialBinding: ControllerBindings(),
            home: const Loading(),
          ),
        );
      },
    );
  }
}
