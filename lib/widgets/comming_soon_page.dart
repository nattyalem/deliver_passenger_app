import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:koooly_user/constants/style_constants.dart';

class ComingSoonPage extends StatelessWidget {
  const ComingSoonPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xffFE620D),
        leading: SizedBox.shrink(),
        title: Text(
          'Koooly',
          style: roboto50020.copyWith(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 30.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                Opacity(
                    opacity: .1,
                    child:
                        Image.asset('assets/images/logo.png', height: 150.h)),
                Text('Coming Soon',
                    style: roboto50040.copyWith(color: Color(0xffFE620D)))
              ],
            ),
            SizedBox(height: 50.h),
            MaterialButton(
              elevation: 0,
              height: 40.h,
              minWidth: Get.width,
              onPressed: () {
                Get.back();
              },
              shape: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20.r),
                  borderSide: BorderSide.none),
              color: Colors.green,
              child: Text('BACK',
                  style: roboto50012.copyWith(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}
