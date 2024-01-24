import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:koooly_user/constants/data_constants.dart';
import 'package:koooly_user/routes/app_pages.dart';

class OTPController extends GetxController {
  late String phoneNumber;
  String? userName;
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  String? verificationCode;

  Timer? timer;
  RxInt timeOutSec = 120.obs;
  RxInt inverseTime = 0.obs;
  RxDouble progressValue = 0.0.obs;
  RxBool resend = false.obs;

  String? fireBaseId;

  late TextEditingController pinPutController;

  @override
  void onInit() {
    super.onInit();
    phoneNumber = Get.arguments['phoneNumber'];
    pinPutController = TextEditingController();
    userName = Get.arguments['userName'];
    verifyPhone();
    countDown();
  }

  @override
  dispose() {
    super.dispose();
    pinPutController.dispose();
  }

  verifyPhone() async {
    await firebaseAuth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) {},
        verificationFailed: (FirebaseAuthException e) {
          print('failed\n');
          print(e.message);
        },
        codeSent: (String verificationID, int? resendToken) {
          print('sent\n');
          verificationCode = verificationID;
        },
        codeAutoRetrievalTimeout: (String verificationID) {
          print('timeout\n');
          verificationCode = verificationID;
        },
        timeout: const Duration(seconds: 120));
  }

  countDown() {
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (timeOutSec.value == 0) {
        resend.value = true;
        timer.cancel();
      } else {
        timeOutSec.value--;
        inverseTime.value++;
        progressValue.value = inverseTime / 120;
      }
    });
  }

  void onPinPutCompleted() async {
    try {
      await FirebaseAuth.instance
          .signInWithCredential(PhoneAuthProvider.credential(
              verificationId: verificationCode!,
              smsCode: pinPutController.text))
          .then((value) async {
        if (value.user != null) {
          fireBaseId = value.user!.uid;
          firebaseUser = FirebaseAuth.instance.currentUser;
          await pushNotificationService.initialize();

          if (userName != null) {
            // EasyLoading.show(maskType: EasyLoadingMaskType.black);
            Map userMapData = {'name': userName, 'phone': phoneNumber};
            userRef.child(value.user!.uid).set(userMapData);
            Get.offAllNamed(Routes.home);
          } else {
            // EasyLoading.show(maskType: EasyLoadingMaskType.black);
            userRef.child(fireBaseId!).once().then((value) async {
              Map result = value.snapshot.value! as Map;
              if (result['name'] == null) {
                Get.offAllNamed(Routes.signup, arguments: {
                  'firebaseId': fireBaseId,
                  'phoneNumber': phoneNumber,
                });
              } else {
                Get.offAllNamed(Routes.home);
              }
            });
          }
        }
      });
    } catch (e) {
      Get.snackbar('Koooly', 'Invalid Otp'.tr,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Color(0xffFE620D).withOpacity(.8));
    }
  }
}
