import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:surajashray/features/health/health_dashboard.dart';
import 'package:surajashray/features/home/screen/home_screen.dart';
import 'package:surajashray/routes/app_routes.dart';
import 'package:surajashray/core/localization/localization_service.dart';
import 'core/bindings/controller_binder.dart';
import 'core/utils/theme/theme.dart';

class Surajashray extends StatelessWidget {
  const Surajashray({super.key});

  @override
  Widget build(BuildContext context) {
    //Set the fit size (Find your UI design, look at the dimensions of the device screen and fill it in,unit in dp)
    return ScreenUtilInit(
      designSize: const Size(
        375,
        812,
      ), // iPhone dimensions matching Figma design
      minTextAdapt: true,
      splitScreenMode: true,
      // Use builder only if you need to use library outside ScreenUtilInit context
      builder: (_, child) {
        return GetMaterialApp(
          debugShowCheckedModeBanner: false,
          initialRoute: AppRoute.getSplashScreen(),
          getPages: AppRoute.routes,
          initialBinding: ControllerBinder(),
          themeMode: ThemeMode.system,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          // Localization setup
          translations: LocalizationService(),
          locale: Get.locale ?? LocalizationService.fallbackLocale,
          fallbackLocale: LocalizationService.fallbackLocale,
          // home: HomeScreen(),
        );
      },
    );
  }
}
