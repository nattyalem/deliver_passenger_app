import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:koooly_user/constants/style_constants.dart';
import 'package:koooly_user/modules/otp/otp_controller.dart';
import 'package:koooly_user/routes/app_pages.dart';
import 'package:pinput/pinput.dart';

class OTPView extends GetView<OTPController> {
  const OTPView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        leading: const SizedBox.shrink(),
        bottom: PreferredSize(
          preferredSize: const Size(0, 0),
          child: LinearProgressIndicator(
            minHeight: 1.h,
            value: null,
            backgroundColor: Colors.deepOrange,
            valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 35.w),
        child: Column(
          children: [
            SizedBox(height: 50.h),
            Text('Verification', style: roboto60020),
            SizedBox(height: 25.h),
            Text(
              'Enter the code that was sent to the number',
              style: roboto50015,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 5.h),
            Text(
              controller.phoneNumber,
              style: roboto60018.copyWith(color: Colors.grey),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 5.h),
            Pinput(
              length: 6,
              controller: controller.pinPutController,
              onCompleted: (value) {
                controller.onPinPutCompleted();
              },
            ),
            SizedBox(height: 60.h),
            Obx(
              () => !controller.resend.value
                  ? Column(
                      children: [
                        LinearProgressIndicator(
                          value: controller.progressValue.value,
                          valueColor: const AlwaysStoppedAnimation<Color>(
                              Color(0xffFE620D)),
                        ),
                        Row(
                          children: [
                            RichText(
                              textAlign: TextAlign.center,
                              text: TextSpan(
                                  children: <TextSpan>[
                                    TextSpan(
                                      text: 'receive in ',
                                    ),
                                    TextSpan(
                                        text: controller.timeOutSec.toString()),
                                    TextSpan(text: ' seconds'),
                                  ],
                                  style: roboto50012.copyWith(
                                      color: Color(0xffFE620D))),
                            ),
                          ],
                        ),
                      ],
                    )
                  : Column(
                      children: [
                        Text(
                            'You haven\'t received the code yet?\ntap resend button to try again',
                            textAlign: TextAlign.center,
                            style:
                                roboto50012.copyWith(color: Color(0xffFE620D))),
                        SizedBox(
                          height: 1.h,
                        ),
                        ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                primary: Color(0xffFE620D),
                                elevation: 0.0,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(3.r)))),
                            onPressed: () {
                              controller.resend.value = false;
                              controller.timeOutSec.value = 120;
                              controller.inverseTime.value = 0;
                              controller.progressValue.value = 0;
                              controller.verifyPhone();
                              controller.countDown();
                            },
                            child: const Text(
                              'Resend',
                              style: TextStyle(color: Colors.white),
                            )),
                      ],
                    ),
            ),
            SizedBox(
              height: 30.h,
            ),
            InkWell(
                onTap: () {
                  Get.offAndToNamed(Routes.login);
                },
                child: RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(children: <TextSpan>[
                    TextSpan(
                        text: 'Wrong phone number? ',
                        style: roboto50012.copyWith(color: Color(0xffFE620D))),
                    TextSpan(
                        text: 'Try again',
                        style: roboto50012.copyWith(
                            color: Color(0xffFE620D),
                            decoration: TextDecoration.underline,
                            fontWeight: FontWeight.w800)),
                  ]),
                ))
          ],
        ),
      ),
    );
  }
}
