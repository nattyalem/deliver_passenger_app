import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:koooly_user/models/location_status.dart';

import 'package:location/location.dart';
import 'package:koooly_user/routes/app_pages.dart';
import 'package:koooly_user/services/route_service.dart';
import 'package:koooly_user/services/service_methods.dart';
import 'package:simple_connection_checker/simple_connection_checker.dart';

class ConnectionCheckerController extends GetxController
    with GetSingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    duration: const Duration(seconds: 2),
    vsync: this,
  )..repeat(reverse: true);
  late final Animation<Offset> offsetAnimation = Tween<Offset>(
    begin: Offset.zero,
    end: const Offset(-1.5, 0.0),
  ).animate(CurvedAnimation(
    parent: _controller,
    curve: Curves.elasticIn,
  ));

  final RouteService routeService = Get.find<RouteService>();
  LatLng? currentPosition;

  Rx<LocationStatus> locationStatus = LocationStatus.unknown.obs;
  Location location = Location();

  @override
  void onInit() async {
    await checkConnection();
    super.onInit();
  }

  @override
  onClose() {
    _controller.dispose();
  }

  checkConnection() async {
    bool isConnected = await SimpleConnectionChecker.isConnectedToInternet();
    if (isConnected) {
      Get.closeAllSnackbars();
      await checkLocationIsEnabled();
      if (locationStatus.value == LocationStatus.enabled) {
        determinePosition();
      }
    } else {
      Get.snackbar('Koooly', 'no_connection'.tr,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.deepOrange,
          colorText: Colors.white);
      checkConnection();
    }
  }

  checkLocationIsEnabled() async {
    bool serviceEnabled;
    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
    }

    if (!serviceEnabled) {
      locationStatus.value = LocationStatus.notEnabled;
    } else {
      locationStatus.value = LocationStatus.enabled;
    }
  }

  determinePosition() async {
    PermissionStatus permissionGranted;
    LocationData locationData;
    permissionGranted = await location.hasPermission();
    locationStatus.value = LocationStatus.unknown;
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        locationStatus.value = LocationStatus.denied;
        return;
      }
    }

    locationStatus.value = LocationStatus.granted;
    locationData = await location.getLocation();
    currentPosition = LatLng(locationData.latitude!, locationData.longitude!);
    await ServiceMethods.searchCoordinateAddress(currentPosition!);
    // initGeofireListener();
    Get.offAndToNamed(
        FirebaseAuth.instance.currentUser == null ? Routes.login : Routes.home);
  }

// checkLocationIsEnabled() async{
//   bool serviceEnabled;
//   // Test if location services are enabled.
//   serviceEnabled = await Geolocator.isLocationServiceEnabled();
//   if (!serviceEnabled) {
//     locationStatus.value = LocationStatus.notEnabled;
//   }
// }
//
// determinePosition() async {
//   LocationPermission permission;
//
//   permission = await Geolocator.checkPermission();
//   if (permission == LocationPermission.denied) {
//     permission = await Geolocator.requestPermission();
//     if (permission == LocationPermission.denied) {
//       locationStatus.value = LocationStatus.denied;
//       print(locationStatus.value.toString() + "locationStatus");
//       return;
//     }
//   }
//
//   if (permission == LocationPermission.deniedForever) {
//     // Permissions are denied forever, handle appropriately.
//     // return Future.error(
//     //     'Location permissions are permanently denied, we cannot request permissions.');
//     locationStatus.value = LocationStatus.deniedForever;
//     return;
//   }
//   locationStatus.value = LocationStatus.enabled;
//   print(locationStatus.value.toString()+"locationStatus");
//
//
//   // locationData = await location.getLocation();
//   // currentPosition = LatLng(locationData.latitude!, locationData.longitude!);
//   //
//   // await ServiceMethods.searchCoordinateAddress(currentPosition!);
//   // initGeofireListener();
//
// }
}
