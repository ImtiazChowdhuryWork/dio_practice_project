import 'package:dio_practice_project/bindings/controllers_binding.dart';
import 'package:dio_practice_project/helper/di.dart';
import 'package:dio_practice_project/helper/helper_methods.dart';
import 'package:dio_practice_project/helper/register_provider.dart';
import 'package:dio_practice_project/loading_screen.dart';
import 'package:dio_practice_project/localization/presentation/language_preference.dart';
import 'package:dio_practice_project/localization/presentation/languages.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:get_storage/get_storage.dart';
import 'package:provider/provider.dart';

import 'routes/routes.dart';


void main()async{
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init(); // ✅ Initialize storage
  await diSetup();
  runApp( const MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    rotation();
    setInitValue();
    return MultiProvider(
      providers: providers,
      child: LayoutBuilder(
        builder: (context, constraints){
          return const UtilScreenMobile();
        },
        ),
    );
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
      builder: (_,child){
        return PopScope(
          canPop: false,
          onPopInvokedWithResult: (bool didPop, _) async {
            showMaterialDialog(context);
          },
          child: GetMaterialApp(
            debugShowCheckedModeBanner: false,

            // 🌍 Translation Setup
            translations: Languages(),

            // ✅ Load saved locale from persistent storage
            locale: LanguagePreference.getSavedLocale(),
            fallbackLocale: const Locale('en', 'US'),


            // ✅ Save locale when it changes (persists across app restarts)
            builder: (context, widget) {
              // Listen to locale changes and save to storage
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
            // home: const HomeScreen(),
          ),
          );
      },
    );
  }
}