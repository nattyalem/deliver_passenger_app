import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:koooly_user/constants/data_constants.dart';
import 'package:koooly_user/constants/style_constants.dart';
import 'package:koooly_user/widgets/drawer/drawer_list_controller.dart';

class DrawerListView extends StatelessWidget {
  DrawerListView({super.key});

  final controller = Get.put(DrawerListController());

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Material(
        color: Colors.white,
        child: Column(
          children: [
            Container(
              color: Color(0xffFE620D),
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 50.w),
              child: Column(
                children: [
                  SizedBox(height: 100.h),
                  CircleAvatar(
                      backgroundImage: AssetImage('assets/images/logo.png'),
                      radius: 30.r),
                  SizedBox(height: 10.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        userCurrentInfo!.name.toString(),
                        style: roboto50015.copyWith(color: Colors.white),
                        maxLines: 1,
                      ),
                      SizedBox(width: 2.w),
                      Icon(Icons.check_circle, color: Colors.white)
                    ],
                  ),
                  SizedBox(height: 10.h)
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                  itemCount: controller.drawerList.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      onTap: controller.drawerList[index]['onTap'],
                      leading: Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 2.w, vertical: 2.h),
                          decoration: BoxDecoration(
                              color: Color(0xffFE620D),
                              borderRadius: BorderRadius.circular(5.r)),
                          child: Icon(
                            controller.drawerList[index]['icon'],
                            color: Colors.white,
                          )),
                      title: Text(
                        '${controller.drawerList[index]['title']}'.tr,
                        style: TextStyle(
                            color: Color(0xffFE620D),
                            fontWeight: FontWeight.bold),
                      ),
                    );
                  }),
            )
          ],
        ),
      ),
    );
  }
}
