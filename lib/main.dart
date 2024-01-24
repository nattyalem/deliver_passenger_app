import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:koooly_user/constants/data_constants.dart';
import 'package:koooly_user/language/app_translation.dart';
import 'package:koooly_user/routes/app_pages.dart';
import 'package:koooly_user/services/route_service.dart';
import 'package:koooly_user/services/service_methods.dart';
import 'package:google_maps_flutter_android/google_maps_flutter_android.dart';
import 'package:google_maps_flutter_platform_interface/google_maps_flutter_platform_interface.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  pushNotificationService.handleForgroundByLocalNotification(message);
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await ServiceMethods.getCurrentOnlineUserInfo();
  if (firebaseUser != null) {
    pushNotificationService.initialize();
  }
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  final GoogleMapsFlutterPlatform mapsImplementation =
      GoogleMapsFlutterPlatform.instance;
  if (mapsImplementation is GoogleMapsFlutterAndroid) {
    mapsImplementation.useAndroidViewSurface = false;
  }
  await GetStorage.init();
  Get.put(RouteService());
  if (box.read('language') != null) {
    AppTranslation.locale = Locale(box.read('language').split(',').first,
        box.read('language').split(',').last);
  }
  runApp(const MyApp());
}

// Future<void> backGroundHandler(RemoteMessage message)async {}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        designSize: const Size(360, 690),
        minTextAdapt: true,
        builder: (context, child) {
          return GetMaterialApp(
            title: 'Koooly',
            theme: ThemeData(
              primarySwatch: const MaterialColor(0XFFFE620D, {
                50: Color.fromRGBO(254, 98, 13, .1),
                100: Color.fromRGBO(254, 98, 13, .2),
                200: Color.fromRGBO(254, 98, 13, .3),
                300: Color.fromRGBO(254, 98, 13, .4),
                400: Color.fromRGBO(254, 98, 13, .5),
                500: Color.fromRGBO(254, 98, 13, .6),
                600: Color.fromRGBO(254, 98, 13, .7),
                700: Color.fromRGBO(254, 98, 13, .8),
                800: Color.fromRGBO(254, 98, 13, .9),
                900: Color.fromRGBO(254, 98, 13, 1),
              }),
              colorScheme: ColorScheme.fromSeed(seedColor: Color(0xffFE620D)),
              useMaterial3: true,
            ),
            debugShowCheckedModeBanner: false,
            locale: AppTranslation.locale,
            translations: AppTranslation(),
            initialRoute: AppPages.initial,
            getPages: AppPages.routes,
          );
        });
  }
}
