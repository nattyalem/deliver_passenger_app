import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:koooly_user/constants/data_constants.dart';
import 'package:koooly_user/constants/style_constants.dart';
import 'package:koooly_user/models/ride_model.dart';
import 'package:koooly_user/modules/history/history_controller.dart';

class HistoryView extends GetView<HistoryController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios, color: Colors.white),
            onPressed: () {
              Get.back();
            },
          ),
          backgroundColor: Color(0xffFE620D),
          title: Text('Ride History'.tr,
              style: roboto50015.copyWith(color: Colors.white)),
          centerTitle: true,
        ),
        body: Obx(
          () => controller.loading.value
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      LottieBuilder.asset('assets/lotties/loading.json'),
                      Text('Loading...',
                          style: roboto60014.copyWith(color: Color(0xffFE620D)))
                    ],
                  ),
                )
              : controller.rideLists.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          LottieBuilder.asset('assets/lotties/empty.json'),
                          Text('found nothing...',
                              style: roboto60014.copyWith(
                                  color: Color(0xffFE620D))),
                          SizedBox(height: 20.h),
                          MaterialButton(
                            elevation: 0,
                            height: 35.h,
                            minWidth: 150.w,
                            onPressed: () {
                              Get.back();
                            },
                            shape: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20.r),
                                borderSide: BorderSide.none),
                            color: Colors.green,
                            child: Text('BACK',
                                style:
                                    roboto50012.copyWith(color: Colors.white)),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      itemCount: controller.rideLists.length,
                      padding: EdgeInsets.symmetric(horizontal: 25.w),
                      itemBuilder: (context, index) {
                        RideModel ride = controller.rideLists[index];
                        return Column(
                          children: [
                            SizedBox(height: 10.h),
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    'From',
                                    textAlign: TextAlign.center,
                                    style: roboto60014.copyWith(
                                        color: Colors.grey.shade400),
                                  ),
                                ),
                                Expanded(
                                  flex: 3,
                                  child: Text(ride.pickupAddress.toString(),
                                      maxLines: 2,
                                      textAlign: TextAlign.start,
                                      overflow: TextOverflow.ellipsis,
                                      style: roboto60014),
                                ),
                              ],
                            ),
                            SizedBox(height: 5.h),
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    'To',
                                    textAlign: TextAlign.center,
                                    style: roboto60014.copyWith(
                                        color: Colors.grey.shade400),
                                  ),
                                ),
                                Expanded(
                                  flex: 3,
                                  child: Text(ride.dropOffAddress.toString(),
                                      maxLines: 2,
                                      textAlign: TextAlign.start,
                                      overflow: TextOverflow.ellipsis,
                                      style: roboto60014),
                                ),
                              ],
                            ),
                            SizedBox(height: 5.h),
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    'Time',
                                    textAlign: TextAlign.center,
                                    style: roboto60014.copyWith(
                                        color: Colors.grey.shade400),
                                  ),
                                ),
                                Expanded(
                                  flex: 3,
                                  child: Text(
                                      timeFormatter.format(DateTime.parse(
                                          ride.createdAt.toString())),
                                      maxLines: 2,
                                      textAlign: TextAlign.start,
                                      overflow: TextOverflow.ellipsis,
                                      style: roboto60014),
                                ),
                              ],
                            ),
                            SizedBox(height: 5.h),
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    'Status',
                                    textAlign: TextAlign.center,
                                    style: roboto60014.copyWith(
                                        color: Colors.grey.shade400),
                                  ),
                                ),
                                Expanded(
                                  flex: 3,
                                  child: Text(ride.status.toString(),
                                      maxLines: 2,
                                      textAlign: TextAlign.start,
                                      overflow: TextOverflow.ellipsis,
                                      style: roboto60014),
                                ),
                              ],
                            ),
                            Divider()
                          ],
                        );
                      },
                    ),
        ));
  }
}
