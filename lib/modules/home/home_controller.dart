import 'dart:async';
import 'dart:math';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:koooly_user/constants/data_constants.dart';
import 'package:koooly_user/models/car_types.dart';
import 'package:koooly_user/models/nearby_available_drivers.dart';
import 'package:koooly_user/routes/app_pages.dart';
import 'package:koooly_user/services/route_service.dart';
import 'package:koooly_user/services/service_methods.dart';

class HomeController extends GetxController {
  DateTime? currentBackPressTime;

  RxSet<Marker> markers = <Marker>{}.obs;
  RxSet<Circle> circles = <Circle>{}.obs;

  final Completer<GoogleMapController> controller = Completer();
  GoogleMapController? googleMapController;
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final RouteService routeService = Get.find<RouteService>();

  LatLng? currentPosition;

  BitmapDescriptor? nearbyIcon;
  RxBool isInCorporateMode = false.obs;

  @override
  void onInit() async {
    super.onInit();
    ServiceMethods.getCurrentOnlineUserInfo();
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
    fetchCarTypes();
  }

  void openDrawer() {
    scaffoldKey.currentState!.openDrawer();
  }

  void closeDrawer() {
    scaffoldKey.currentState!.closeDrawer();
  }

  Future<bool> markPosition() async {
    currentPosition = LatLng(routeService.currentLocation!.latitude!,
        routeService.currentLocation!.longitude!);
    LatLng latLngPosition =
        LatLng(currentPosition!.latitude, currentPosition!.longitude);
    CameraPosition cameraPosition = CameraPosition(
      target: latLngPosition,
      zoom: 14.4746,
    );
    Marker homeMarker = Marker(
      icon: BitmapDescriptor.defaultMarker,
      markerId: const MarkerId('Home'),
      position: latLngPosition,
      infoWindow: const InfoWindow(
        title: "Current Location",
      ),
    );
    Circle homeCircle = Circle(
        fillColor: Color(0xffFE620D).withOpacity(.2),
        center: latLngPosition,
        radius: 1000,
        strokeColor: Color(0xffFE620D).withOpacity(.5),
        strokeWidth: 2,
        circleId: const CircleId('Home'));

    googleMapController!
        .animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
    ServiceMethods.initGeofireListener();
    updateAvailableDriversOnMap();
    markers.add(homeMarker);
    circles.add(homeCircle);
    return true;
  }

  goToSearch() {
    routeService.pickUpLocation = routeService.currentLocation;
    Get.toNamed(Routes.searchPlaces);
  }

  void updateAvailableDriversOnMap() {
    markers.clear();

    Set<Marker> tMarkers = <Marker>{};
    for (NearByAvailableDrivers driver in nearByAvailableDriversList) {
      Marker marker = Marker(
          markerId: MarkerId('driver${driver.key}'),
          position: LatLng(driver.latitude, driver.longitude),
          icon: nearbyIcon!,
          rotation: Random().nextInt(360).toDouble());
      tMarkers.add(marker);
    }

    Marker homeMarker = Marker(
      icon: BitmapDescriptor.defaultMarker,
      markerId: const MarkerId('Home'),
      position: currentPosition!,
      infoWindow: const InfoWindow(
        title: "Current Location",
      ),
    );
    Circle carCircle = Circle(
        fillColor: Colors.yellow,
        center: currentPosition!,
        radius: 50.0,
        strokeColor: Colors.yellowAccent,
        circleId: const CircleId('Home'));

    markers.value = tMarkers;
    markers.add(homeMarker);
    circles.add(carCircle);
  }

  void createIconMarker(context) async {
    if (nearbyIcon == null) {
      ImageConfiguration imageConfiguration =
          createLocalImageConfiguration(context, size: const Size(.2, .2));
      nearbyIcon = await BitmapDescriptor.fromAssetImage(
          imageConfiguration, 'assets/images/min_red_car_for_map.png');
    }
  }

  void checkIfPhoneIsInCorporate() {
    if (isInCorporateMode.value) {
      isInCorporateMode.value = false;
      routeService.isInCorporateMode = false;
      Get.snackbar('Koooly', 'Corporate Mode Turned Off',
          snackPosition: SnackPosition.BOTTOM,
          colorText: Colors.white,
          backgroundColor: Color(0xffFE620D).withOpacity(.8));
      return;
    }
    if (userCurrentInfo!.corporateId != null &&
        userCurrentInfo!.corporateId != '') {
      corporateRef.child(userCurrentInfo!.corporateId!).once().then((value) {
        if (value.snapshot.value != null) {
          isInCorporateMode.value = true;
          routeService.isInCorporateMode = true;
          Get.snackbar('Koooly', 'Corporate Mode Turned On',
              snackPosition: SnackPosition.BOTTOM,
              colorText: Colors.white,
              backgroundColor: Colors.green.withOpacity(.8));
        } else {
          Get.snackbar('Koooly',
              'Your corporate has been removed, Can\'t be in Corporate Mode'.tr,
              snackPosition: SnackPosition.BOTTOM,
              colorText: Colors.white,
              backgroundColor: Color(0xffFE620D).withOpacity(.8));
        }
      });
    } else {
      Get.snackbar('Koooly', 'Your phone is not registered in any corporate'.tr,
          snackPosition: SnackPosition.BOTTOM,
          colorText: Colors.white,
          backgroundColor: Color(0xffFE620D).withOpacity(.8));
    }
  }

  void fetchCarTypes() {
    carTypesRef.once().then((value) {
      Map<dynamic, dynamic> data =
          value.snapshot.value as Map<dynamic, dynamic>;
      data.forEach((key, val) {
        print(key);
        Map<dynamic, dynamic> formattedMap = val as Map;
        CarTypes.carList.add(CarTypes(
            vehicleType: formattedMap['vehicleType'],
            percentageCut: formattedMap['percentageCut'],
            pricePerKm: formattedMap['pricePerKm'],
            startingPrice: formattedMap['startingPrice'],
            image:
                'assets/images/${formattedMap['vehicleType'].toString().toLowerCase()}.png'));
      });
    });
  }
}
