import 'package:app_settings/app_settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:koooly_user/constants/style_constants.dart';
import 'package:koooly_user/models/location_status.dart';
import 'package:koooly_user/modules/connection_checker/connection_checker_controller.dart';

class ConnectionCheckerView extends GetView<ConnectionCheckerController> {
  const ConnectionCheckerView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffFE620D),
      body: SizedBox(
        width: Get.width,
        child: Stack(
          children: [
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 100.h),
                    child: Image.asset('assets/images/logo.png', height: 150.h),
                  ),
                  SizedBox(height: 180.h),
                  Column(
                    children: [
                      const CircularProgressIndicator(
                          backgroundColor: Colors.white54),
                      SizedBox(height: 15.h),
                      Text('Connecting...',
                          style: roboto50010.copyWith(color: Colors.white))
                    ],
                  ),
                ],
              ),
            ),
            Obx(
              () => Visibility(
                visible: controller.locationStatus.value ==
                    LocationStatus.notEnabled,
                child: Align(
                    alignment: Alignment.bottomCenter,
                    child: DraggableScrollableSheet(
                      minChildSize: 0.4,
                      maxChildSize: 0.4,
                      initialChildSize: 0.4,
                      builder: (BuildContext context,
                          ScrollController scrollController) {
                        return Container(
                          color: Colors.white,
                          padding: EdgeInsets.symmetric(horizontal: 50.w),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: 80.w,
                                height: 5.h,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5.r),
                                    color: Theme.of(context).primaryColorLight),
                              ),
                              SizedBox(height: 20.h),
                              Container(
                                  padding: EdgeInsets.all(10.r),
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                          color: Theme.of(context)
                                              .primaryColorLight,
                                          width: 3.r)),
                                  child: Icon(
                                    Icons.not_listed_location,
                                    color: Theme.of(context).primaryColorLight,
                                    size: 60.h,
                                  )),
                              SizedBox(height: 10.h),
                              Text('please_get_location'.tr,
                                  style: roboto50012,
                                  textAlign: TextAlign.center),
                              SizedBox(height: 10.h),
                              MaterialButton(
                                onPressed: () async {
                                  await controller.checkLocationIsEnabled();
                                  if (controller.locationStatus.value ==
                                      LocationStatus.enabled) {
                                    controller.determinePosition();
                                  }
                                },
                                minWidth: Get.width,
                                height: 33.h,
                                splashColor: Colors.blueAccent,
                                color: Color(0xffFE620D),
                                shape: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      width: 0, color: Color(0xffFE620D)),
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(20.r),
                                  ),
                                ),
                                child: Text(
                                  "enable_location".tr,
                                  style:
                                      roboto50015.copyWith(color: Colors.white),
                                ),
                              ),
                              SizedBox(height: 15.h),
                            ],
                          ),
                        );
                      },
                    )),
              ),
            ),
            Obx(
              () => Visibility(
                visible:
                    controller.locationStatus.value == LocationStatus.denied,
                child: Align(
                    alignment: Alignment.bottomCenter,
                    child: DraggableScrollableSheet(
                      minChildSize: 0.4,
                      maxChildSize: 0.4,
                      initialChildSize: 0.4,
                      builder: (BuildContext context,
                          ScrollController scrollController) {
                        return Container(
                          color: Colors.white,
                          padding: EdgeInsets.symmetric(horizontal: 50.w),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: 80.w,
                                height: 5.h,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5.r),
                                    color: Theme.of(context).primaryColorLight),
                              ),
                              SizedBox(height: 20.h),
                              Container(
                                  padding: EdgeInsets.all(10.r),
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                          color: Theme.of(context)
                                              .primaryColorLight,
                                          width: 3.r)),
                                  child: Icon(
                                    Icons.not_listed_location,
                                    color: Theme.of(context).primaryColorLight,
                                    size: 60.h,
                                  )),
                              SizedBox(height: 10.h),
                              Text('permit_location'.tr,
                                  style: roboto50012,
                                  textAlign: TextAlign.center),
                              SizedBox(height: 10.h),
                              MaterialButton(
                                onPressed: () {
                                  AppSettings.openAppSettings();
                                },
                                minWidth: Get.width,
                                height: 33.h,
                                splashColor: Colors.blueAccent,
                                color: Color(0xffFE620D),
                                shape: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      width: 0, color: Color(0xffFE620D)),
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(20.r),
                                  ),
                                ),
                                child: Text(
                                  "goto_settings".tr,
                                  style:
                                      roboto50015.copyWith(color: Colors.white),
                                ),
                              ),
                              TextButton(
                                  onPressed: () async {
                                    await controller.checkLocationIsEnabled();
                                    if (controller.locationStatus.value ==
                                        LocationStatus.enabled) {
                                      controller.determinePosition();
                                    }
                                  },
                                  child:
                                      Text('try_again'.tr, style: roboto50012)),
                              SizedBox(height: 15.h),
                            ],
                          ),
                        );
                      },
                    )),
              ),
            ),
          ],
        ),
      ),
    );
  }

// void showModalSheet(BuildContext context) {
//   showModalBottomSheet(
//     context: context,
//     isDismissible: true,
//     builder: (context) {
//       return WillPopScope(
//           onWillPop: () {
//             return Future.value(true);
//           },
//           child: Padding(
//             padding: EdgeInsets.symmetric(horizontal: 50.w),
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 Container(
//                   width: 80.w,
//                   height: 5.h,
//                   decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(5.r),
//                       color: Theme.of(context).primaryColorLight),
//                 ),
//                 SizedBox(height: 20.h),
//                 Container(
//                     padding: EdgeInsets.all(10.r),
//                     decoration: BoxDecoration(
//                         shape: BoxShape.circle,
//                         border: Border.all(
//                             color: Theme.of(context).primaryColorLight,
//                             width: 3.r)),
//                     child: Icon(
//                       Icons.not_listed_location,
//                       color: Theme.of(context).primaryColorLight,
//                       size: 60.h,
//                     )),
//                 SizedBox(height: 10.h),
//                 Text('please_get_location'.tr,
//                     style: roboto50012, textAlign: TextAlign.center),
//                 SizedBox(height: 10.h),
//                 MaterialButton(
//                   onPressed: () async {
//                     bool isLocationGranted =
//                     await controller.markPosition();
//                     if (!isLocationGranted) {
//                       Fluttertoast.showToast(
//                           msg: 'go_to_settings'.tr,
//                           toastLength: Toast.LENGTH_SHORT,
//                           gravity: ToastGravity.BOTTOM,
//                           timeInSecForIosWeb: 1,
//                           backgroundColor: Colors.black,
//                           textColor: Colors.white,
//                           fontSize: 8.sp);
//                     }
//                   },
//                   minWidth: Get.width,
//                   height: 33.h,
//                   splashColor: Colors.blueAccent,
//                   color: Color(0xffFE620D),
//                   shape: OutlineInputBorder(
//                     borderSide: const BorderSide(width: 0, color: Color(0xffFE620D)),
//                     borderRadius: BorderRadius.all(
//                       Radius.circular(20.r),
//                     ),
//                   ),
//                   child: Text(
//                     "enable_location".tr,
//                     style: roboto50015.copyWith(color: Colors.white),
//                   ),
//                 ),
//                 SizedBox(height: 15.h),
//               ],
//             ),
//           ));
//     },
//   );
// }
}
