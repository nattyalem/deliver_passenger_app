import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:koooly_user/constants/style_constants.dart';
import 'package:koooly_user/modules/search_places/search_places_controller.dart';
import 'package:koooly_user/routes/app_pages.dart';
import 'package:koooly_user/widgets/location_display.dart';
import 'package:pinput/pinput.dart';

class SearchPlacesView extends GetView<SearchPlacesController> {
  const SearchPlacesView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              Get.back();
            }),
        title: Text(
            controller.userPhone == null
                ? 'enter_destination'.tr
                : 'order_for_others'.tr,
            style: roboto60018.copyWith(color: Colors.white)),
        backgroundColor: Color(0xffFE620D),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(width: 15.w),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(height: 20.h),
                  Visibility(
                    visible: controller.userPhone != null,
                    child: Column(
                      children: [
                        Icon(Icons.phone, size: 10.h, color: Colors.green),
                        Container(color: Colors.grey, width: 1.w, height: 35.h),
                      ],
                    ),
                  ),
                  Icon(Icons.location_on, size: 10.h, color: Color(0xffFE620D)),
                  Container(color: Colors.grey, width: 1.w, height: 35.h),
                  Icon(Icons.location_on, size: 10.h, color: Colors.blue),
                ],
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(right: 40.w, left: 10.w),
                  child: Column(
                    children: [
                      SizedBox(height: 10.5.h),
                      Visibility(
                        visible: controller.userPhone != null,
                        child: SizedBox(
                          height: 30.h,
                          child: TextFormField(
                              controller: controller.phoneController,
                              focusNode: controller.phoneFocus,
                              style: roboto60018,
                              autofocus: true,
                              keyboardType: TextInputType.phone,
                              maxLength: 10,
                              buildCounter: (context,
                                      {required currentLength,
                                      required isFocused,
                                      maxLength}) =>
                                  null,
                              decoration: InputDecoration(
                                hintText: 'phone_number'.tr,
                                fillColor: Colors.grey.shade200,
                                filled: true,
                                hintStyle:
                                    roboto60018.copyWith(color: Colors.grey),
                                contentPadding: EdgeInsets.only(
                                    left: 10.w, right: 0, bottom: 10.h),
                                border: const OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.transparent)),
                                enabledBorder: const OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.transparent)),
                                disabledBorder: const OutlineInputBorder(
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
                      SizedBox(height: 10.h),
                      SizedBox(
                        height: 30.h,
                        child: TextFormField(
                          controller: controller.pickUpController,
                          focusNode: controller.pickupFocus,
                          style: roboto60018,
                          decoration: InputDecoration(
                            hintText: 'enter_pickup'.tr,
                            fillColor: Colors.grey.shade200,
                            filled: true,
                            hintStyle: roboto60018.copyWith(color: Colors.grey),
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
                                controller.pickUpController.clear();
                              },
                            ),
                          ),
                          onChanged: (value) {
                            controller.searchPlaces(value);
                          },
                        ),
                      ),
                      SizedBox(height: 10.h),
                      SizedBox(
                        height: 30.h,
                        child: TextFormField(
                          controller: controller.dropOffController,
                          focusNode: controller.dropFocus,
                          autofocus: true,
                          style: roboto60018,
                          decoration: InputDecoration(
                            hintText: 'enter_dropoff'.tr,
                            fillColor: Colors.grey.shade200,
                            filled: true,
                            hintStyle: roboto60018.copyWith(color: Colors.grey),
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
                                controller.dropOffController.clear();
                              },
                            ),
                          ),
                          onChanged: (value) {
                            controller.searchPlaces(value);
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 10.h),
          Divider(color: Colors.grey.shade200, endIndent: 50.w, indent: 50.w),
          Obx(() => controller.placePredictionList.isNotEmpty
              ? Expanded(
                  child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10.w),
                  child: ListView.builder(
                      itemCount: controller.placePredictionList.length,
                      itemBuilder: (context, index) {
                        return InkWell(
                          onTap: () async {
                            if (controller.pickupFocus.hasFocus) {
                              controller.pickUpController.text = controller
                                  .placePredictionList[index].mainText!;
                              await controller.getPlaceAddressDetails(
                                  controller.placePredictionList[index].placeId,
                                  false);
                              controller.placePredictionList.clear();
                              FocusScope.of(context)
                                  .requestFocus(controller.dropFocus);
                            } else {
                              if (controller.pickUpController.text.isEmpty) {
                                Fluttertoast.showToast(
                                    msg: 'enter_pickup_place'.tr,
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.BOTTOM,
                                    timeInSecForIosWeb: 1,
                                    backgroundColor: Colors.black,
                                    textColor: Colors.white,
                                    fontSize: 8.sp);
                                return;
                              }

                              if (controller.userPhone != null &&
                                  controller.phoneController.length < 10) {
                                Fluttertoast.showToast(
                                    msg: 'Enter Correct Phone Number'.tr,
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.BOTTOM,
                                    timeInSecForIosWeb: 1,
                                    backgroundColor: Colors.black,
                                    textColor: Colors.white,
                                    fontSize: 8.sp);
                                return;
                              }

                              bool placeFound =
                                  await controller.getPlaceAddressDetails(
                                      controller
                                          .placePredictionList[index].placeId,
                                      true);
                              if (placeFound) {
                                // FocusScope.of(context).unfocus();
                                Get.offAndToNamed(Routes.selectCars,
                                    arguments: controller.userPhone != null
                                        ? {
                                            'userPhone':
                                                controller.phoneController.text
                                          }
                                        : null);
                              } else {
                                Fluttertoast.showToast(
                                    msg: 'no_connection'.tr,
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.BOTTOM,
                                    timeInSecForIosWeb: 1,
                                    backgroundColor: Colors.black,
                                    textColor: Colors.white,
                                    fontSize: 8.sp);
                              }
                            }
                          },
                          child: Padding(
                              padding: EdgeInsets.symmetric(vertical: 5.h),
                              child: LocationDisplay(
                                  prediction:
                                      controller.placePredictionList[index])),
                        );
                      }),
                ))
              : const SizedBox.shrink())
        ],
      ),
    );
  }
}
