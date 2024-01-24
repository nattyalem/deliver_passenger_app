import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:koooly_user/routes/app_pages.dart';

class LoginController extends GetxController {
  DateTime? currentBackPressTime;

  late TextEditingController phoneController;

  @override
  void onInit() {
    phoneController = TextEditingController();
    super.onInit();
  }

  @override
  void dispose() {
    phoneController.dispose();
    super.dispose();
  }

  validatePhone() {
    String phoneNumber = phoneController.text;

    if (phoneNumber.length != 13 && phoneNumber.length != 10) {
      Get.snackbar('Koooly', 'notCorrectPhone'.tr,
          snackPosition: SnackPosition.BOTTOM,
          colorText: Colors.white,
          backgroundColor: Color(0xffFE620D).withOpacity(.8));
    } else {
      if (phoneNumber.startsWith('0')) {
        phoneNumber = '+251${phoneNumber.substring(1)}';
      }
      Get.toNamed(Routes.otp, arguments: {'phoneNumber': phoneNumber});
    }
  }
}
