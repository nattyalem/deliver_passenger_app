import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:koooly_user/modules/home/home_controller.dart';
import 'package:koooly_user/routes/app_pages.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../constants/style_constants.dart';

class DrawerListController extends GetxController {
  List<Map<String, dynamic>> drawerList = [];

  @override
  onInit() {
    super.onInit();
    drawerList = [
      // {
      //   'title': 'languages',
      //   'icon': Icons.language,
      //   'onTap': () {
      //     Get.defaultDialog(
      //         title: 'languages'.tr,
      //         middleText: 'chooseLanguage'.tr,
      //         middleTextStyle: TextStyle(color: Color(0xffFE620D)),
      //         titleStyle: TextStyle(color: Color(0xffFE620D)),
      //         textCancel: 'English',
      //         textConfirm: 'አማርኛ',
      //         onCancel: () {
      //           box.write('language', 'en,US');
      //           AppTranslation.locale = Locale(
      //               box.read('language').split(',').first,
      //               box.read('language').split(',').last);
      //           print(AppTranslation.locale);
      //           Get.updateLocale(AppTranslation.locale);
      //         },
      //         onConfirm: () {
      //           box.write('language', 'am,ET');
      //           AppTranslation.locale = Locale(
      //               box.read('language').split(',').first,
      //               box.read('language').split(',').last);
      //           print(AppTranslation.locale);
      //           Get.updateLocale(AppTranslation.locale);
      //           Get.back();
      //         },
      //         cancelTextColor: Color(0xffFE620D),
      //         buttonColor: Color(0xffFE620D),
      //         confirmTextColor: Colors.white);
      //   }
      // },
      {
        'title': 'history',
        'icon': Icons.history,
        'onTap': () {
          Get.offAndToNamed(Routes.history);
        }
      },
      {
        'title': 'products',
        'icon': Icons.shopping_cart,
        'onTap': () async {
          if (!await launchUrl(
              Uri.parse("https://koooly.com/products/index.php")))
            throw 'Could not launch';
        }
      },
      // {
      //   'title': 'miles',
      //   'icon': Icons.card_giftcard,
      //   'onTap': () {
      //     Get.offAndToNamed(Routes.miles);
      //   }
      // },
      // {'title': 'pre_order', 'icon': Icons.schedule, 'onTap': () {
      //   Get.offAndToNamed(Routes.preOrders);
      // }},
      // {'title': 'order_for_others', 'icon': Icons.person_add, 'onTap': () {
      //   Get.offAndToNamed(Routes.searchPlaces, arguments: {
      //     'userPhone': 'userPhone'
      //   });
      // }},
      // {
      //   'title': 'corporate_service',
      //   'icon': Icons.corporate_fare,
      //   'onTap': () {
      //     checkIfPhoneIsInCorporate();
      //   }
      // },
      {
        'title': 'support',
        'icon': Icons.help_outline,
        'onTap': () async {
          if (!await launchUrl(Uri.parse("https://koooly.com/")))
            throw 'Could not launch';
        }
      },
      {
        'title': 'about',
        'icon': Icons.info,
        'onTap': () async {
          if (!await launchUrl(Uri.parse("https://koooly.com/")))
            throw 'Could not launch';
        }
      },
      {
        'title': 'logout',
        'icon': Icons.logout,
        'onTap': () {
          FirebaseAuth.instance.signOut();
          Get.offAllNamed(Routes.login);
        }
      },
    ];
  }

  static languageOnTap() {
    Get.defaultDialog(
      title: 'languages'.tr,
      middleText: 'chooseLanguage'.tr,
      middleTextStyle: roboto50015,
      titleStyle: roboto50015,
      textCancel: 'English',
      textConfirm: 'አማርኛ',
      onCancel: () {
        // GetStorage().write('language', 'en,US');
        // AppTranslation.locale = Locale(
        //     GetStorage()
        //         .read('language')
        //         .split(',')
        //         .first,
        //     GetStorage()
        //         .read('language')
        //         .split(',')
        //         .last);
        // Get.updateLocale(AppTranslation.locale);
      },
      onConfirm: () {
        // GetStorage().write('language', 'am,ET');
        // AppTranslation.locale = Locale(
        //     GetStorage()
        //         .read('language')
        //         .split(',')
        //         .first,
        //     GetStorage()
        //         .read('language')
        //         .split(',')
        //         .last);
        // Get.updateLocale(AppTranslation.locale);
        // Navigator.pop(context);
      },
      // cancelTextColor: green,
      // buttonColor: green,
      // confirmTextColor: white
    );
  }

  static checkIfPhoneIsInCorporate() {
    final homeController = Get.find<HomeController>();
    homeController.checkIfPhoneIsInCorporate();
    homeController.closeDrawer();
  }
}
