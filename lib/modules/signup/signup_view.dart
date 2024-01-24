import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:koooly_user/constants/style_constants.dart';
import 'package:koooly_user/modules/signup/signup_controller.dart';

class SignUpView extends GetView<SignUpController> {
  const SignUpView({super.key});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () {
          DateTime now = DateTime.now();

          if (controller.currentBackPressTime == null ||
              now.difference(controller.currentBackPressTime!) >
                  const Duration(seconds: 2)) {
            controller.currentBackPressTime = now;
            Fluttertoast.showToast(
                msg: 'to_exit'.tr,
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.black,
                fontSize: 16.0);
            return Future.value(false);
          } else {
            return Future.value(true);
          }
        },
        child: Scaffold(
          body: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 20.h),
            child: Column(
              children: [
                SizedBox(height: 150.h),
                Image.asset('assets/images/logo.png', height: 100.h),
                SizedBox(height: 30.h),
                Visibility(
                  visible: controller.phoneNumber == null,
                  child: SizedBox(
                    height: 35.h,
                    child: TextFormField(
                        controller: controller.phoneController,
                        style: roboto60018,
                        keyboardType: TextInputType.phone,
                        textInputAction: TextInputAction.next,
                        decoration: InputDecoration(
                          hintText: 'phone_number'.tr,
                          fillColor: Colors.grey.shade200,
                          filled: true,
                          hintStyle: roboto50015.copyWith(color: Colors.grey),
                          contentPadding: EdgeInsets.only(
                              left: 10.w, right: 0, bottom: 10.h),
                          border: const OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.transparent)),
                          enabledBorder: const OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.transparent)),
                          focusedBorder: const OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.transparent)),
                          suffix: IconButton(
                            icon: Icon(Icons.clear,
                                color: Colors.black12, size: 15.r),
                            onPressed: () {
                              controller.phoneController.clear();
                            },
                          ),
                        )),
                  ),
                ),
                SizedBox(height: 30.h),
                SizedBox(
                  height: 35.h,
                  child: TextFormField(
                      controller: controller.nameController,
                      style: roboto60018,
                      keyboardType: TextInputType.name,
                      decoration: InputDecoration(
                        hintText: 'name'.tr,
                        fillColor: Colors.grey.shade200,
                        filled: true,
                        hintStyle: roboto50015.copyWith(color: Colors.grey),
                        contentPadding:
                            EdgeInsets.only(left: 10.w, right: 0, bottom: 10.h),
                        border: const OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.transparent)),
                        enabledBorder: const OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.transparent)),
                        focusedBorder: const OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.transparent)),
                        suffix: IconButton(
                          icon: Icon(Icons.clear,
                              color: Colors.black12, size: 15.r),
                          onPressed: () {
                            controller.phoneController.clear();
                          },
                        ),
                      )),
                ),
                SizedBox(height: 30.h),
                Align(
                  alignment: Alignment.centerRight,
                  child: FloatingActionButton(
                    onPressed: () {
                      controller.onFormSubmitted();
                    },
                    backgroundColor: Color(0xffFE620D),
                    elevation: 0,
                    shape: const CircleBorder(),
                    child: const Icon(Icons.arrow_forward, color: Colors.white),
                  ),
                ),
                SizedBox(height: 20.h),
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.center,
                //   children: [
                //     Text('have_acct'.tr,
                //         style: roboto50012),
                //     SizedBox(
                //       width: 15.w
                //     ),
                //     SizedBox(
                //       width:80.w,
                //       child: MaterialButton(
                //         height: 23.h,
                //         padding: EdgeInsets.all(0),
                //         onPressed: () {
                //          Get.offAndToNamed(Routes.login);
                //         },
                //         splashColor: Color(0xffFE620D)Accent,
                //         elevation: 2,
                //         shape: OutlineInputBorder(
                //           borderSide: BorderSide(
                //             color: Color(0xffFE620D),
                //             width: .5.h,
                //           ),
                //           borderRadius: BorderRadius.all(
                //             Radius.circular(
                //               3.r
                //             ),
                //           ),
                //         ),
                //         child: Text(
                //           'login'.tr,
                //           style: roboto50015.copyWith(color: Color(0xffFE620D))
                //         ),
                //       ),
                //     ),
                //   ],
                // ),
              ],
            ),
          ),
        ));
  }
}
