import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:koooly_user/constants/data_constants.dart';
import 'package:koooly_user/constants/style_constants.dart';
import 'package:koooly_user/models/car_types.dart';
import 'package:koooly_user/modules/select_car/select_car_controller.dart';
import 'package:koooly_user/routes/app_pages.dart';
import 'package:url_launcher/url_launcher.dart';

class SelectCarView extends GetView<SelectCarController> {
  const SelectCarView({super.key});

  @override
  Widget build(BuildContext context) {
    controller.createIconMarker(context);

    return Scaffold(
      body: Stack(
        children: [
          Obx(() => GoogleMap(
              initialCameraPosition: addisAbabaCenter,
              mapType: MapType.normal,
              zoomGesturesEnabled: true,
              polylines: controller.polyLineSet.value,
              zoomControlsEnabled: false,
              onMapCreated: (GoogleMapController con) async {
                controller.mapController.complete(con);
                controller.googleMapController = con;
                controller.getRideLiveLocationUpdate();
              },
              markers: controller.markers.value,
              circles: controller.waitingRequest.value
                  ? Set.from(controller.circles.value
                    ..add(Circle(
                        fillColor: Color(0xffFE620D).withOpacity(.2),
                        center: LatLng(
                            controller.routeService.pickUpLocation!.latitude!,
                            controller.routeService.pickUpLocation!.longitude!),
                        radius: controller.circleRadius.value,
                        strokeWidth: 2,
                        strokeColor: Color(0xffFE620D).withOpacity(.5),
                        circleId: const CircleId('pickUpId'))))
                  : Set.from(controller.circles.value))),
          Container(
            margin: EdgeInsets.only(left: 30.w, right: 30.w, top: 50.h),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15.r),
                boxShadow: [
                  BoxShadow(
                      color: Colors.grey.shade300,
                      blurRadius: 3.r,
                      spreadRadius: 3.r)
                ]),
            child: Row(
              children: [
                IconButton(
                    onPressed: () {
                      if (!controller.displayingDriverDetail.value) {
                        Get.back();
                      }
                    },
                    icon: const Icon(Icons.arrow_back)),
                Expanded(
                  child: InkWell(
                    onTap: () {
                      if (!controller.displayingDriverDetail.value) {
                        Get.offAndToNamed(Routes.searchPlaces);
                      }
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(5.r)),
                      padding:
                          EdgeInsets.symmetric(horizontal: 5.w, vertical: 5.h),
                      child: Text(
                        controller.routeService.dropOffLocation!.placeName
                            .toString(),
                        style: roboto60018,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 20.w)
              ],
            ),
          ),
          Obx(() => !controller.waitingRequest.value
              ? Align(
                  alignment: Alignment.bottomCenter,
                  child: DraggableScrollableSheet(
                    minChildSize: 0.37,
                    maxChildSize: 0.37,
                    initialChildSize: 0.37,
                    builder: (BuildContext context,
                        ScrollController scrollController) {
                      return Container(
                        decoration: BoxDecoration(
                            color: Color(0xffFE620D).withOpacity(.5),
                            borderRadius: BorderRadius.vertical(
                                top: Radius.circular(15.r))),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              '',
                            ),
                            Expanded(
                              child: Container(
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.vertical(
                                          top: Radius.circular(15.r))),
                                  child: Column(
                                    children: [
                                      SizedBox(height: 5.h),
                                      Container(
                                        width: 80.w,
                                        height: 5.h,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(5.r),
                                            color: Theme.of(context)
                                                .primaryColorLight),
                                      ),
                                      Expanded(
                                          child: ListView.builder(
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        itemCount: CarTypes.carList.length,
                                        controller: scrollController,
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 20.w),
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          CarTypes carType =
                                              CarTypes.carList[index];
                                          return Padding(
                                            padding: EdgeInsets.symmetric(
                                                vertical: 5.h),
                                            child: Material(
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(5.r),
                                                child: Obx(
                                                  () => ListTile(
                                                    tileColor: controller
                                                                .selectedCar
                                                                .value ==
                                                            carType
                                                        ? Color(0xffFE620D)
                                                        : Colors.grey.shade100,
                                                    onTap: () {
                                                      controller.selectedCar
                                                          .value = carType;
                                                    },
                                                    title: Text(
                                                        carType.vehicleType.tr,
                                                        style: roboto60018.copyWith(
                                                            color: controller
                                                                        .selectedCar
                                                                        .value ==
                                                                    carType
                                                                ? Colors.white
                                                                : Colors
                                                                    .black)),
                                                    leading: Image.asset(
                                                        carType.image,
                                                        height: 20.h),
                                                    trailing: Column(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      children: [
                                                        Text(
                                                            'ETB ~ ${controller.faresList[index]}',
                                                            style: roboto60018.copyWith(
                                                                color: controller
                                                                            .selectedCar
                                                                            .value ==
                                                                        carType
                                                                    ? Colors
                                                                        .white
                                                                    : Colors
                                                                        .black)),
                                                        Text(
                                                            'KM ~ ${controller.distanceList[index]}',
                                                            style: roboto50012.copyWith(
                                                                color: controller
                                                                            .selectedCar
                                                                            .value ==
                                                                        carType
                                                                    ? Colors
                                                                        .white
                                                                    : Colors
                                                                        .black)),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          );
                                        },
                                      )),
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 20.w, vertical: 10.h),
                                        child: Row(
                                          children: [
                                            Expanded(
                                                child: Obx(
                                              () => MaterialButton(
                                                onPressed: () async {
                                                  controller.waitingRequest
                                                      .value = true;
                                                  await controller
                                                      .saveRideRequest();
                                                  await controller
                                                      .searchNearestDriver();
                                                },
                                                color: Color(0xffFE620D),
                                                shape: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20.r),
                                                    borderSide:
                                                        const BorderSide(
                                                            color: Colors
                                                                .transparent)),
                                                padding: EdgeInsets.symmetric(
                                                    vertical: 7.h),
                                                child: Text(
                                                    '${'select'.tr} ${controller.selectedCar.value.vehicleType}',
                                                    style: roboto60018.copyWith(
                                                        color: Colors.white)),
                                              ),
                                            )),
                                            // SizedBox(width: 15.w),
                                            // GestureDetector(
                                            //   onTap: () async {
                                            //     DateTime? pickupDate =
                                            //     await showDatePicker(
                                            //         context: context,
                                            //         initialDate:
                                            //         DateTime.now(),
                                            //         firstDate:
                                            //         DateTime.now(),
                                            //         lastDate: DateTime.now()
                                            //             .add(const Duration(
                                            //             days: 5)));
                                            //     if (pickupDate != null) {
                                            //       TimeOfDay? pickupTime =
                                            //       await showTimePicker(
                                            //           context: context,
                                            //           initialTime:
                                            //           TimeOfDay.now());
                                            //       if (pickupTime != null) {
                                            //         int minutes = pickupTime!
                                            //             .minute +
                                            //             (pickupTime.hour * 60);
                                            //         pickupDate = pickupDate.add(
                                            //             Duration(
                                            //                 minutes: minutes));
                                            //         controller.pickupTime =
                                            //             pickupDate;
                                            //         controller.waitingRequest
                                            //             .value = true;
                                            //         await controller
                                            //             .saveRideRequest();
                                            //         await controller
                                            //             .searchNearestDriver();
                                            //       }
                                            //     }
                                            //   },
                                            //   child: Container(
                                            //       padding: EdgeInsets.symmetric(
                                            //           vertical: 7.h,
                                            //           horizontal: 10.w),
                                            //       decoration: BoxDecoration(
                                            //           color: Color(0xffFE620D),
                                            //           borderRadius:
                                            //           BorderRadius.circular(
                                            //               5.r)),
                                            //       child: const Icon(
                                            //           Icons.schedule,
                                            //           color: Colors.white)),
                                            // )
                                          ],
                                        ),
                                      )
                                    ],
                                  )),
                            ),
                          ],
                        ),
                      );
                    },
                  ))
              : !controller.displayingDriverDetail.value
                  ? Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        height: 100.h,
                        decoration: BoxDecoration(
                            color: Color(0xffFE620D),
                            borderRadius: BorderRadius.vertical(
                                top: Radius.circular(15.r))),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              'Searching',
                              textAlign: TextAlign.center,
                              style: roboto50015.copyWith(color: Colors.white),
                            ),
                            Expanded(
                                child: Container(
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.vertical(
                                            top: Radius.circular(15.r))),
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 15.w),
                                    child: Column(
                                      children: [
                                        Align(
                                          alignment: Alignment.centerRight,
                                          child: MaterialButton(
                                            elevation: 0,
                                            onPressed: () {
                                              controller
                                                  .showCancelDialog(context);
                                            },
                                            child: Text(
                                              'cancel',
                                              style: roboto50015.copyWith(
                                                  color: Colors.white),
                                            ),
                                            height: 13.h,
                                            splashColor: Colors.blueAccent,
                                            color: Color(0xffFE620D),
                                            shape: OutlineInputBorder(
                                              borderSide: const BorderSide(
                                                  width: 0,
                                                  color: Color(0xffFE620D)),
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(20.r),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                            child: Text(
                                          'Looking for available drivers, please wait...',
                                          maxLines: 1,
                                          style: roboto60014.copyWith(
                                              color: Color(0xffFE620D)),
                                        )),
                                      ],
                                    )))
                          ],
                        ),
                      ),
                    )

                  // Container(
                  //             width: Get.width,
                  //             height: Get.height,
                  //             color: Colors.white70,
                  //             child: Column(
                  //               mainAxisAlignment: MainAxisAlignment.center,
                  //               children: [
                  //                 Stack(
                  //                   alignment: Alignment.center,
                  //                   children: [
                  //                     SizedBox(
                  //                         height: 200.r,
                  //                         width: 200.r,
                  //                         child: Obx(
                  //                             ()=> CircularProgressIndicator(
                  //                               strokeWidth: 2.r,
                  //                               value: (30-controller.driverRequestTimeOut.value)/30
                  //                           ),
                  //                         )
                  //                     ),
                  //                     Padding(
                  //                         padding:
                  //                             EdgeInsets.symmetric(horizontal: 45.w),
                  //                         child: Text('waiting_drivers'.tr,
                  //                             style: roboto60020.copyWith(color: Colors.grey),
                  //                             textAlign: TextAlign.center)),
                  //                   ],
                  //                 )
                  //               ],
                  //             ),
                  //           )
                  : Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        height: 150.h,
                        decoration: BoxDecoration(
                            color: Color(0xffFE620D),
                            borderRadius: BorderRadius.vertical(
                                top: Radius.circular(15.r))),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Obx(
                              () => Text(
                                controller.driverMessage.value,
                                textAlign: TextAlign.center,
                                style:
                                    roboto50015.copyWith(color: Colors.white),
                              ),
                            ),
                            Expanded(
                                child: Container(
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.vertical(
                                      top: Radius.circular(15.r))),
                              padding: EdgeInsets.symmetric(horizontal: 15.w),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Container(
                                    height: 30.h,
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 15.w),
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            color: Color(0xffFE620D)),
                                        borderRadius:
                                            BorderRadius.circular(20.r)),
                                    child: Row(
                                      children: [
                                        Text(
                                          'Car Model:',
                                          textAlign: TextAlign.center,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: roboto50015,
                                        ),
                                        SizedBox(width: 10.w),
                                        Text(
                                          controller.carModel,
                                          textAlign: TextAlign.center,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: roboto60018,
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    height: 30.h,
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 15.w),
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            color: Color(0xffFE620D)),
                                        borderRadius:
                                            BorderRadius.circular(20.r)),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Expanded(
                                          child: Row(
                                            children: [
                                              Text(
                                                'Plate:',
                                                textAlign: TextAlign.center,
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                style: roboto50015,
                                              ),
                                              Expanded(
                                                child: Text(
                                                  controller.carPlate,
                                                  textAlign: TextAlign.center,
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: roboto60018,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Expanded(
                                          child: Row(
                                            children: [
                                              Text(
                                                'Color:',
                                                textAlign: TextAlign.center,
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                style: roboto50015,
                                              ),
                                              Expanded(
                                                child: Text(
                                                  controller.carColor,
                                                  textAlign: TextAlign.center,
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: roboto60018,
                                                ),
                                              ),
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  Container(
                                    height: 30.h,
                                    padding: EdgeInsets.only(left: 15.w),
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            color: Color(0xffFE620D)),
                                        borderRadius:
                                            BorderRadius.circular(20.r)),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Expanded(
                                          child: Row(
                                            children: [
                                              Text(
                                                'Name:',
                                                textAlign: TextAlign.center,
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                style: roboto50015,
                                              ),
                                              Expanded(
                                                child: Text(
                                                  controller.driverName,
                                                  textAlign: TextAlign.center,
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: roboto60018,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Expanded(
                                          child: MaterialButton(
                                            onPressed: () async {
                                              if (!await launch(
                                                  "tel:${controller.driverPhone}")) {
                                                throw 'Could not launch';
                                              }
                                            },
                                            elevation: 0,
                                            color: Color(0xffFE620D),
                                            shape: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(20.r),
                                                borderSide: BorderSide.none),
                                            child: Row(
                                              children: [
                                                Expanded(
                                                  child: Text(
                                                    controller.driverPhone,
                                                    textAlign: TextAlign.center,
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: roboto50020.copyWith(
                                                        color: Colors.white),
                                                  ),
                                                ),
                                                const Icon(
                                                  Icons.phone,
                                                  color: Colors.green,
                                                )
                                              ],
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ))
                          ],
                        ),
                      ),
                    ))
        ],
      ),
    );
  }
}
