import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:koooly_user/constants/data_constants.dart';
import 'package:koooly_user/routes/app_pages.dart';

class SignUpController extends GetxController {
  late TextEditingController phoneController;
  late TextEditingController nameController;
  String? fireBaseId;
  String? phoneNumber;
  DateTime? currentBackPressTime;

  @override
  void onInit() {
    phoneController = TextEditingController();
    nameController = TextEditingController();
    if (Get.arguments != null) {
      fireBaseId = Get.arguments['firebaseId'];
      phoneNumber = Get.arguments['phoneNumber'];
    }
    super.onInit();
  }

  @override
  void onClose() {
    phoneController.dispose();
    nameController.dispose();
    super.onClose();
  }

  onFormSubmitted() {
    if (fireBaseId != null) {
      // EasyLoading.show(maskType: EasyLoadingMaskType.black);
      Map userMapData = {
        'name': nameController.text,
        'phone': phoneNumber,
        'miles': 0
      };
      userRef.child(fireBaseId!).set(userMapData);
      // EasyLoading.dismiss();
      Get.offAllNamed(Routes.home);
    } else {
      if (phoneNumber == null) {
        Get.snackbar('Koooly', 'Please Enter Phone Number'.tr,
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Color(0xffFE620D).withOpacity(.8));
      } else if (phoneNumber!.length != 13 && phoneNumber!.length != 10) {
        Get.snackbar('Koooly', 'Invalid Phone Number'.tr,
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Color(0xffFE620D).withOpacity(.8));
      } else {
        if (phoneNumber!.length == 10) {
          phoneNumber = '+251' + phoneNumber!.substring(1);
        }
        Get.offAllNamed(Routes.otp, arguments: {
          'phoneNumber': phoneNumber!,
          'userName': nameController.text,
        });
      }
    }
  }
}
