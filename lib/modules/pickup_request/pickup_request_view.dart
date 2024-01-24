import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:koooly_user/constants/data_constants.dart';
import 'package:koooly_user/constants/style_constants.dart';
import 'package:koooly_user/modules/pickup_request/pickup_request_controller.dart';
import 'package:url_launcher/url_launcher.dart';

class PickupRequestView extends GetView<PickupRequestController> {
  const PickupRequestView({super.key});

  @override
  Widget build(BuildContext context) {
    controller.createMarkerIcon(context);

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
                textColor: Colors.white,
                fontSize: 8.sp);
            return Future.value(false);
          } else {
            return Future.value(true);
          }
        },
        child: Scaffold(
            appBar: AppBar(
              backgroundColor: Color(0xffFE620D),
              leading: SizedBox.shrink(),
              centerTitle: true,
              title: Text(
                'Koooly',
                style: roboto50020.copyWith(color: Colors.white),
              ),
            ),
            body: Column(
              children: [
                Expanded(
                  child: Obx(
                    () => GoogleMap(
                      mapType: MapType.normal,
                      initialCameraPosition: addisAbabaCenter,
                      zoomGesturesEnabled: true,
                      onMapCreated: (GoogleMapController con) async {
                        controller.controller.complete(con);
                        controller.newRideGoogleMapController = con;
                        await controller.getPlaceDirection(
                            controller.currentPosition,
                            controller.rideDetails.pickup);
                        controller.getRideLiveLocationUpdate();
                      },
                      markers: controller.markers.value,
                      circles: controller.circles.value,
                      polylines: controller.polyLineSet.value,
                    ),
                  ),
                ),
              ],
            ),
            bottomSheet: Container(
              height: 150.h,
              padding: EdgeInsets.symmetric(horizontal: 15.w),
              decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                        color: Color(0xffFE620D),
                        blurRadius: 5.r,
                        spreadRadius: 5.r)
                  ],
                  color: Colors.white,
                  borderRadius:
                      BorderRadius.vertical(top: Radius.circular(15.r))),
              child: Column(
                children: [
                  SizedBox(height: 5.h),
                  Center(
                    child: Obx(() => Text(
                        '(You will arrive in) ${controller.durationRide.value}')),
                  ),
                  SizedBox(height: 15.h),
                  Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20.r),
                        border: Border.all(color: Color(0xffFE620D))),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        SizedBox(width: 15.h),
                        Expanded(
                          child: Text.rich(
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              TextSpan(children: [
                                TextSpan(
                                  text: 'Rider Name: ',
                                  style: roboto50012.copyWith(
                                      color: Color(0xffFE620D)),
                                ),
                                TextSpan(
                                  text: controller.rideDetails.riderName,
                                  style: roboto50012.copyWith(
                                      color: Color(0xffFE620D)),
                                )
                              ])),
                        ),
                        Expanded(
                          child: MaterialButton(
                              elevation: 0,
                              color: Color(0xffFE620D),
                              shape: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20.r),
                                  borderSide: BorderSide.none),
                              onPressed: () async {
                                if (!await launch(
                                    "tel:${controller.rideDetails.riderPhone}"))
                                  throw 'Could not launch';
                              },
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.phone,
                                    color: Colors.white,
                                  ),
                                  Text('  ' + controller.rideDetails.riderPhone,
                                      style: roboto50012.copyWith(
                                          color: Colors.white))
                                ],
                              )),
                        ),
                        SizedBox(width: 10.h),
                      ],
                    ),
                  ),
                  SizedBox(height: 15.h)
                ],
              ),
            )));
  }

// void showEndDialog(Context context) {
//   showDialog(
//     context: context,
//     builder: (context) {
//       return WillPopScope(
//         onWillPop: () {
//           return Future.value(false);
//         },
//         child: AlertDialog(
//           title: Center(child: Text('Total Payment')),
//           content: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Text(
//                 fareAmount.toString(),
//                 style: TextStyle(color: Colors.blue, fontSize: _height * 10),
//               ),
//               Text('ETB',
//                   style: TextStyle(
//                     color: Colors.blue,
//                   ))
//             ],
//           ),
//           actions: [
//             Center(
//                 child: ElevatedButton(
//                     style: ElevatedButton.styleFrom(
//                         padding:
//                         EdgeInsets.symmetric(horizontal: _width * 10)),
//                     onPressed: () {
//                       Navigator.pop(context);
//                       Navigator.pop(context);
//                       ServiceMethods.enableHomeLiveLocationUpdates();
//                     },
//                     child: Text('Collect')))
//           ],
//         ),
//       );
//     },
//   );
// }
}
