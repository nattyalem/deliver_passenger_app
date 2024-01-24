import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:koooly_user/constants/style_constants.dart';
import 'package:koooly_user/modules/end_trip/end_trip_controller.dart';
import 'package:koooly_user/routes/app_pages.dart';

class EndTripView extends GetView<EndTripController> {
  const EndTripView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const SizedBox.shrink(),
        backgroundColor: Color(0xffFE620D),
        title: Text(
          'Koooly',
          style: roboto50020.copyWith(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 30.w),
        child: Column(
          children: [
            SizedBox(height: 100.h),
            Image.asset('assets/images/logo.png', height: 150.h),
            SizedBox(height: 25.h),
            Text(controller.totalPrice,
                style: roboto60060.copyWith(color: Color(0xffFE620D))),
            Text('ETB', style: roboto50020),
            SizedBox(height: 25.h),
            MaterialButton(
              elevation: 0,
              height: 40.h,
              minWidth: Get.width,
              onPressed: () {
                Get.offAllNamed(Routes.home);
              },
              shape: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20.r),
                  borderSide: BorderSide.none),
              color: Color(0xffFE620D),
              child: Text('END TRIP',
                  style: roboto50012.copyWith(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}
