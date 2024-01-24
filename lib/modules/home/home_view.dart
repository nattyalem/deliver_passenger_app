import 'package:flutter/material.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:koooly_user/constants/data_constants.dart';
import 'package:koooly_user/constants/style_constants.dart';
import 'package:koooly_user/modules/home/home_controller.dart';
import 'package:koooly_user/routes/app_pages.dart';
import 'package:koooly_user/widgets/drawer/drawer_list_view.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    controller.createIconMarker(context);
    return Scaffold(
      key: controller.scaffoldKey,
      floatingActionButtonLocation: ExpandableFab.location,
      floatingActionButton: Padding(
        padding: EdgeInsets.only(top: 100.h, right: 20.w),
        child: Align(
          alignment: Alignment.topRight,
          child: FloatingActionButton.small(
            foregroundColor: Colors.white,
            backgroundColor: Color(0xffFE620D),
            tooltip: 'order_for_others'.tr,
            shape: CircleBorder(),
            heroTag: null,
            child: const Icon(Icons.person_add),
            onPressed: () {
              Get.toNamed(Routes.searchPlaces,
                  arguments: {'userPhone': 'userPhone'});
            },
          ),
        ),
      ),
      drawer: DrawerListView(),
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Color(0xffFE620D),
        title: Text('Koooly', style: roboto50020.copyWith(color: Colors.white)),
        centerTitle: true,
      ),
      body: WillPopScope(
        onWillPop: () {
          if (controller.scaffoldKey.currentState!.isDrawerOpen) {
            Navigator.pop(context);
            return Future.value(false);
          }
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
        child: Stack(
          children: [
            Obx(() => GoogleMap(
                  initialCameraPosition: addisAbabaCenter,
                  mapType: MapType.normal,
                  zoomGesturesEnabled: true,
                  zoomControlsEnabled: false,
                  onMapCreated: (GoogleMapController con) async {
                    controller.controller.complete(con);
                    controller.googleMapController = con;
                    await controller.markPosition();
                  },
                  markers: controller.markers.value,
                  circles: controller.circles.value,
                )),
            // Align(
            //   alignment: Alignment.topCenter,
            //   child: ExpandableFab(
            //     child: Text('dsf'),
            //     type: ExpandableFabType.left,
            //     children: [
            //       FloatingActionButton.small(
            //         heroTag: null,
            //         child: const Icon(Icons.edit),
            //         onPressed: () {},
            //       ),
            //       FloatingActionButton.small(
            //         heroTag: null,
            //         child: const Icon(Icons.search),
            //         onPressed: () {},
            //       ),
            //     ],
            //   ),
            // ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Obx(
                () => Container(
                  decoration: BoxDecoration(
                      color: controller.isInCorporateMode.value
                          ? Colors.green
                          : Color(0xffFE620D).withOpacity(.5),
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(15.r))),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '',
                        // style: roboto50015.copyWith(color: Colors.white),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 15.w),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.vertical(
                                top: Radius.circular(15.r))),
                        child: Column(
                          children: [
                            SizedBox(height: 5.h),
                            Container(
                              width: 70.w,
                              height: 4.h,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5.r),
                                  color: Theme.of(context).primaryColorLight),
                            ),
                            SizedBox(height: 10.h),
                            MaterialButton(
                              onPressed: () {
                                controller.goToSearch();
                              },
                              minWidth: Get.width,
                              color: Color(0xffFE620D),
                              padding: EdgeInsets.symmetric(
                                  vertical: 3.h, horizontal: 10.w),
                              elevation: 0,
                              splashColor: Color(0xffFE620D),
                              shape: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      color: Colors.transparent),
                                  borderRadius: BorderRadius.circular(5.r)),
                              child: Padding(
                                  padding: EdgeInsets.symmetric(vertical: 4.h),
                                  child: Text('where_to'.tr,
                                      style: roboto50015.copyWith(
                                          color: Colors.white))),
                            ),
                            MaterialButton(
                              onPressed: () async {
                                if (!await launchUrl(Uri.parse(
                                    "https://koooly.com/products/index.php")))
                                  throw 'Could not launch';
                              },
                              minWidth: Get.width,
                              color: Color(0xffFE620D),
                              padding: EdgeInsets.symmetric(
                                  vertical: 3.h, horizontal: 10.w),
                              elevation: 0,
                              splashColor: Color(0xffFE620D),
                              shape: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      color: Colors.transparent),
                                  borderRadius: BorderRadius.circular(5.r)),
                              child: Padding(
                                  padding: EdgeInsets.symmetric(vertical: 4.h),
                                  child: Text('products'.tr,
                                      style: roboto50015.copyWith(
                                          color: Colors.white))),
                            ),

                            // SizedBox(height: 10.h),
                            // LocationDisplay(
                            //     prediction: PlacePredictions(
                            //         mainText: 'main',
                            //         placeId: 'placeid',
                            //         secondaryText: 'secon')),
                            // SizedBox(height: 8.h),
                            // LocationDisplay(
                            //     prediction: PlacePredictions(
                            //         mainText: 'main',
                            //         placeId: 'placeid',
                            //         secondaryText: 'secon')),
                            // SizedBox(height: 8.h),
                            // LocationDisplay(
                            //     prediction: PlacePredictions(
                            //         mainText: 'main',
                            //         placeId: 'placeid',
                            //         secondaryText: 'secon')),
                            SizedBox(height: 20.h),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            // Container(
            //   margin: EdgeInsets.only(top: 30.h, left: 20.w),
            //   decoration: BoxDecoration(boxShadow: [
            //     BoxShadow(color: Color(0xffFE620D), blurRadius: 2.r, spreadRadius: 2.r)
            //   ], color: Colors.white, shape: BoxShape.circle),
            //   child: IconButton(
            //     onPressed: controller.openDrawer,
            //     icon: const Icon(Icons.menu, color: Colors.black),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
