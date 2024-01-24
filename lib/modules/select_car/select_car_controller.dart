import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:koooly_user/constants/data_constants.dart';
import 'package:koooly_user/constants/style_constants.dart';
import 'package:koooly_user/models/address.dart';
import 'package:koooly_user/models/car_types.dart';
import 'package:koooly_user/models/direcction_details.dart';
import 'package:koooly_user/models/nearby_available_drivers.dart';
import 'package:koooly_user/models/payment_method.dart';
import 'package:koooly_user/routes/app_pages.dart';
import 'package:koooly_user/services/maps_toolkit_service.dart';
import 'package:koooly_user/services/route_service.dart';
import 'package:koooly_user/services/service_methods.dart';

class SelectCarController extends GetxController
    with GetSingleTickerProviderStateMixin {
  late AnimationController animationController;
  RxDouble circleRadius = 0.0.obs;

  List<LatLng> pLineCoordinates = [];
  final RouteService routeService = Get.find<RouteService>();
  RxSet<Polyline> polyLineSet = <Polyline>{}.obs;

  RxSet<Marker> markers = <Marker>{}.obs;
  RxSet<Circle> circles = <Circle>{}.obs;

  final Completer<GoogleMapController> mapController = Completer();
  GoogleMapController? googleMapController;

  DirectionDetails tripDirectionDetails = DirectionDetails();

  Rx<CarTypes> selectedCar = CarTypes.carList[0].obs;

  String? requestKey;
  DatabaseReference rideRequestRef =
      FirebaseDatabase.instance.ref().child('Ride Requests');

  late StreamSubscription rideStreamSubscription;

  String statusRide = '';

  String driverName = '';
  String driverPhone = '';
  String carPlate = '';
  String carModel = '';
  String carColor = '';

  RxBool displayingDriverDetail = false.obs;

  List<NearByAvailableDrivers>? availableDrivers;
  RxInt driverRequestTimeOut = 30.obs;

  RxString state = 'normal'.obs;

  RxBool waitingRequest = false.obs;

  RxList<int> faresList = [0, 0, 0].obs;
  RxList<int> distanceList = [0, 0, 0].obs;

  late NearByAvailableDrivers nearestDriver;

  LatLng? currentPosition;

  LatLng? myPosition;

  BitmapDescriptor? carIcon;

  RxString driverMessage = 'Driver is Coming, track on the map.'.obs;
  DateTime? pickupTime;
  String? userPhone;

  @override
  void onInit() {
    animationController = AnimationController(
      vsync: this,
      duration:
          Duration(seconds: 1), // Adjust the duration as per your preference
    );

    animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        animationController.reset();
        animationController.forward();
      }
    });

    animationController.addListener(() {
      circleRadius.value = 500 * animationController.value;
    });

    animationController.forward();

    getPlaceDirection(
        routeService.pickUpLocation!, routeService.dropOffLocation!);
    ServiceMethods.initGeofireListener();
    userPhone = Get.arguments != null ? Get.arguments['userPhone'] : null;
    super.onInit();
  }

  @override
  void dispose() {
    super.dispose();
    rideStreamSubscription.cancel();
    googleMapController!.dispose();
  }

  getPlaceDirection(Address initialPosition, Address finalPosition) async {
    // Address initialPosition = routeService.pickUpLocation!;
    // Address finalPosition = routeService.dropOffLocation!;

    LatLng pickUpLatLng =
        LatLng(initialPosition.latitude!, initialPosition.longitude!);
    LatLng dropOffLatLng =
        LatLng(finalPosition.latitude!, finalPosition.longitude!);

    DirectionDetails? details = await ServiceMethods.getPlaceDirectionDetails(
        pickUpLatLng, dropOffLatLng);

    //must be dialog
    if (details != null) {
      pLineCoordinates.clear();
      List<PointLatLng> decodedPolyLines =
          PolylinePoints().decodePolyline(details.encodedPoints!);
      if (decodedPolyLines.isNotEmpty) {
        for (var element in decodedPolyLines) {
          pLineCoordinates.add(LatLng(element.latitude, element.longitude));
        }
      }

      polyLineSet.clear();
      Polyline polyline = Polyline(
          color: Colors.pink,
          polylineId: const PolylineId('PolylineID'),
          jointType: JointType.round,
          points: pLineCoordinates,
          width: 5,
          startCap: Cap.roundCap,
          endCap: Cap.roundCap,
          geodesic: true);
      polyLineSet.add(polyline);

      LatLngBounds latLngBounds;
      if (pickUpLatLng.latitude > dropOffLatLng.latitude &&
          pickUpLatLng.longitude > dropOffLatLng.longitude) {
        latLngBounds =
            LatLngBounds(southwest: dropOffLatLng, northeast: pickUpLatLng);
      } else if (pickUpLatLng.longitude > dropOffLatLng.longitude) {
        latLngBounds = LatLngBounds(
            southwest: LatLng(pickUpLatLng.latitude, dropOffLatLng.longitude),
            northeast: LatLng(dropOffLatLng.latitude, pickUpLatLng.longitude));
      } else if (pickUpLatLng.latitude > dropOffLatLng.latitude) {
        latLngBounds = LatLngBounds(
            southwest: LatLng(dropOffLatLng.latitude, pickUpLatLng.longitude),
            northeast: LatLng(pickUpLatLng.latitude, dropOffLatLng.longitude));
      } else {
        latLngBounds =
            LatLngBounds(southwest: pickUpLatLng, northeast: dropOffLatLng);
      }

      googleMapController!
          .animateCamera(CameraUpdate.newLatLngBounds(latLngBounds, 70));

      markers.clear();
      circles.clear();

      Marker pickUpMarker = Marker(
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueYellow),
        markerId: const MarkerId('pickUpId'),
        position: pickUpLatLng,
        infoWindow: InfoWindow(
            title: initialPosition.placeName, snippet: 'Pickup Location'),
      );
      Marker dropOffMarker = Marker(
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
        markerId: const MarkerId('dropOffId'),
        position: pickUpLatLng,
        infoWindow: InfoWindow(
            title: finalPosition.placeName, snippet: 'Drop off Location'),
      );

      markers.add(pickUpMarker);
      markers.add(dropOffMarker);
      Circle pickupCircle = Circle(
          fillColor: Colors.yellow,
          center: pickUpLatLng,
          radius: 12.0,
          strokeColor: Colors.yellowAccent,
          circleId: const CircleId('pickUpId'));
      Circle dropOffCircle = Circle(
          fillColor: Color(0xffFE620D),
          center: dropOffLatLng,
          radius: 12.0,
          strokeColor: Color(0xffFE620D),
          circleId: const CircleId('dropOffId'));

      circles.add(pickupCircle);
      circles.add(dropOffCircle);
      tripDirectionDetails = details;
      faresList[0] = calculateFare(CarTypes.carList[0]);
      faresList[1] = calculateFare(CarTypes.carList[1]);
      faresList[2] = calculateFare(CarTypes.carList[2]);
      distanceList[0] = tripDirectionDetails.distanceValue! ~/ 1000;
      distanceList[1] = tripDirectionDetails.distanceValue! ~/ 1000;
      distanceList[2] = tripDirectionDetails.distanceValue! ~/ 1000;
    }
  }

  saveRideRequest() async {
    if (availableDrivers == null || availableDrivers!.isEmpty) {
      availableDrivers = [];
      availableDrivers = nearByAvailableDriversList;
    }
    var pickUp = routeService.pickUpLocation;
    var dropOff = routeService.dropOffLocation;

    String? token = await FirebaseMessaging.instance.getToken();

    Map pickUpLocation = {
      'latitude': pickUp!.latitude.toString(),
      'longitude': pickUp.longitude.toString()
    };

    Map dropOffLocation = {
      'latitude': dropOff!.latitude.toString(),
      'longitude': dropOff.longitude.toString()
    };

    Map rideInfo = {
      'driver_id': 'waiting',
      'payment_method': routeService.isInCorporateMode
          ? PaymentMethod.mobileMoney.name
          : PaymentMethod.cash.name,
      'pick_up': pickUpLocation,
      'drop_off': dropOffLocation,
      'created_at': DateTime.now().toString(),
      'pickup_date': pickupTime != null
          ? pickupTime.toString()
          : DateTime.now().toString(),
      'is_preorder': pickupTime != null ? true : false,
      'rider_name': userCurrentInfo!.name,
      'rider_phone': userPhone == null ? userCurrentInfo!.phone : userPhone,
      'rider_id': userCurrentInfo!.id,
      'pickup_address': pickUp.placeName,
      'drop_off_address': dropOff.placeName,
      'selected_car_type': selectedCar.value.vehicleType,
      'token': token
    };

    requestKey = rideRequestRef.push().key;

    rideRequestRef.child(requestKey!).set(rideInfo);
    state.value = 'requesting';
    rideStreamSubscription =
        rideRequestRef.child(requestKey!).onValue.listen((event) {
      if (event.snapshot.value == null) {
        return;
      }
      Map result = event.snapshot.value as Map;

      if (result['status'] != null) {
        statusRide = result['status'].toString();
      }

      if (statusRide == 'accepted') {
        animationController.reset();
        if (pickupTime != null) {
          Get.snackbar('Koooly', 'Ride has been ordered, Thank You.'.tr,
              snackPosition: SnackPosition.BOTTOM,
              colorText: Colors.white,
              backgroundColor: Color(0xffFE620D).withOpacity(.8),
              duration: const Duration(seconds: 1));
          rideStreamSubscription.cancel();
          Get.offAllNamed(Routes.home);
          return;
        }
        if (driverName == '') {
          if (result['driverInfo']['driverName'] != null) {
            driverName = result['driverInfo']['driverName'];
            driverPhone = result['driverInfo']['phone'];
            carPlate = result['driverInfo']['carPlate'];
            carModel = result['driverInfo']['carModel'];
            carColor = result['driverInfo']['carColor'];
          }
          displayingDriverDetail.value = true;
          Address driverAddress = Address(
              latitude: nearestDriver.latitude,
              longitude: nearestDriver.longitude,
              placeFormattedAddress: '',
              placeId: '',
              placeName: '');
          getPlaceDirection(driverAddress, routeService.currentLocation!);
          drawDriverLocation();
        }
      }
      if (statusRide == 'arrived') {
        if (state.value != 'arrived') {
          driverMessage.value = 'Track your live location on the map.';
          getPlaceDirection(
              routeService.pickUpLocation!, routeService.dropOffLocation!);
        }
        state.value = 'arrived';
      }

      if (statusRide == 'ended') {
        if (result['fares'] != null) {
          rideStreamSubscription.cancel();
          Get.offAndToNamed(Routes.endTrip,
              arguments: {'totalPrice': result['fares']});
        }
      }
    });
  }

  cancelRideRequest() {
    rideRequestRef.child(requestKey!).remove();
    state.value = 'normal';
  }

  searchNearestDriver() async {
    print('availableDriversss' + availableDrivers!.toList().toString());
    print('availableDriversss' + availableDrivers!.length.toString());

    if (availableDrivers!.isEmpty) {
      rideStreamSubscription.cancel();
      // state.value = 'normal';
      // waitingRequest.value = false;
      Get.snackbar('Koooly', 'No Drivers Available. Please Try Again Later!'.tr,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Color(0xffFE620D).withOpacity(.8),
          colorText: Colors.white);
      resetApp();
      return;
    }

    if (state.value != 'requesting') {
      return;
    }

    nearestDriver = availableDrivers![0];
    if (availableDrivers!.isNotEmpty) {
      availableDrivers!.removeAt(0);
    }
    DatabaseEvent result =
        await driverRef.child(nearestDriver.key).child('carType').once();
    if (result.snapshot.value != null) {
      String carType = result.snapshot.value.toString();
      print('carType' + carType);
      if (carType.toLowerCase().trim() ==
          selectedCar.value.vehicleType.toLowerCase().trim()) {
        notifyDriver(nearestDriver);
      } else {
        waitingRequest.value = false;
        Fluttertoast.showToast(
            msg:
                '${selectedCar.value.vehicleType} Drivers not available. Please try again.',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.black,
            fontSize: 16.0);
      }
    } else {
      waitingRequest.value = false;
      Fluttertoast.showToast(
          msg: 'No Car Found. Please try again.',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black,
          fontSize: 16.0);
    }
  }

  void notifyDriver(NearByAvailableDrivers driver) async {
    driverRef.child(driver.key).child('newRide').set(requestKey);
    DatabaseEvent result =
        await driverRef.child(driver.key).child('token').once();
    if (result.snapshot.value != null) {
      String token = result.snapshot.value.toString();
      ServiceMethods.sendNotificationToDriver(
          token, requestKey!, pickupTime != null ? true : false);
    } else {
      return;
    }
    Timer.periodic(const Duration(seconds: 1), (timer) {
      driverRequestTimeOut.value--;
      if (state.value != 'requesting') {
        driverRef.child(driver.key).child('newRide').set('cancelled');
        driverRef.child(driver.key).child('newRide').onDisconnect();
        driverRequestTimeOut.value = 30;
        timer.cancel();
      }

      driverRef.child(driver.key).child('newRide').onValue.listen((event) {
        if (event.snapshot.value.toString() == 'accepted') {
          driverRef.child(driver.key).child('newRide').set('timeout');
          driverRef.child(driver.key).child('newRide').onDisconnect();
          driverRequestTimeOut.value = 30;
          timer.cancel();
        } else if (event.snapshot.value.toString() == 'searching') {
          if (statusRide == 'ended') {
            return;
          }
          driverRef.child(driver.key).child('newRide').onDisconnect();
          driverRequestTimeOut.value = 30;
          timer.cancel();
          searchNearestDriver();
          // Fluttertoast.showToast(
          //     msg: 'Driver cancelled Your request, Searching for other drivers',
          //     toastLength: Toast.LENGTH_SHORT,
          //     gravity: ToastGravity.BOTTOM,
          //     timeInSecForIosWeb: 1,
          //     backgroundColor: Colors.black,
          //     fontSize: 16.0);
        }
      });
      if (driverRequestTimeOut.value == 0) {
        driverRef.child(driver.key).child('newRide').set('timeout');
        driverRef.child(driver.key).child('newRide').onDisconnect();
        driverRequestTimeOut.value = 30;
        timer.cancel();
        searchNearestDriver();
      }
    });
  }

  void resetApp() async {
    waitingRequest.value = false;
    await cancelRideRequest();
    // ServiceMethods.initGeofireListener();
  }

  calculateFare(CarTypes carType) {
    return ServiceMethods.calculateFare(tripDirectionDetails, carType);
  }

  void drawDriverLocation() {
    LatLng oldPos = LatLng(0, 0);
    currentPosition = LatLng(
        nearestDriver.latitude.toDouble(), nearestDriver.longitude.toDouble());
    myPosition = LatLng(routeService.currentLocation!.latitude!.toDouble(),
        routeService.currentLocation!.longitude!.toDouble());

    num rotation = MapsToolKitService.getMarkerRotations(oldPos.latitude,
        oldPos.longitude, myPosition!.latitude, myPosition!.longitude);
    Marker animatingMarker = Marker(
        markerId: MarkerId('animating'),
        position: myPosition!,
        icon: carIcon!,
        rotation: double.parse(rotation.toString()));
    CameraPosition cameraPosition =
        CameraPosition(target: myPosition!, zoom: 14.4746);
    googleMapController!
        .animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
    markers.removeWhere((element) => element.markerId.value == 'animating');
    markers.add(animatingMarker);
    oldPos = myPosition!;
    // updateRideDetails();
  }

  void createIconMarker(BuildContext context) async {
    if (carIcon == null) {
      ImageConfiguration imageConfiguration =
          createLocalImageConfiguration(context, size: const Size(.2, .2));
      carIcon = await BitmapDescriptor.fromAssetImage(
          imageConfiguration, 'assets/images/min_red_car_for_map.png');
    }
  }

  void getRideLiveLocationUpdate() {
    LatLng oldPos = LatLng(0, 0);
    Location location = Location();
    rideStreamSubscription =
        location.onLocationChanged.listen((LocationData currentLocation) {
      currentPosition = LatLng(currentLocation.latitude!.toDouble(),
          currentLocation.longitude!.toDouble());
      myPosition = LatLng(currentLocation.latitude!.toDouble(),
          currentLocation.longitude!.toDouble());

      num rotation = MapsToolKitService.getMarkerRotations(oldPos.latitude,
          oldPos.longitude, myPosition!.latitude, myPosition!.longitude);

      Marker animatingMarker = Marker(
          markerId: MarkerId('animating'),
          position: myPosition!,
          icon: carIcon!,
          infoWindow: InfoWindow(title: 'Current Location'),
          rotation: double.parse(rotation.toString()));
      CameraPosition cameraPosition =
          CameraPosition(target: myPosition!, zoom: 14.4746);
      googleMapController!
          .animateCamera(CameraUpdate.newCameraPosition(cameraPosition));

      markers.removeWhere((element) => element.markerId.value == 'animating');
      markers.add(animatingMarker);
      oldPos = myPosition!;
    });
  }

  void showCancelDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: 5.h),
                Text('Cancel Reason',
                    style: roboto60014.copyWith(color: Color(0xffFE620D))),
                SizedBox(height: 5.h),
                MaterialButton(
                    elevation: 0,
                    minWidth: Get.width,
                    color: Color(0xffFE620D).withOpacity(.2),
                    onPressed: () {
                      setupCancelReason('cancelled,Accidental request');
                    },
                    child: Text('Accidental request',
                        style: roboto50012.copyWith(color: Colors.black))),
                MaterialButton(
                    elevation: 0,
                    minWidth: Get.width,
                    color: Color(0xffFE620D).withOpacity(.2),
                    onPressed: () {
                      setupCancelReason('cancelled,Accidental request');
                    },
                    child: Text('Driver is too far',
                        style: roboto50012.copyWith(color: Colors.black))),
                MaterialButton(
                    elevation: 0,
                    minWidth: Get.width,
                    color: Color(0xffFE620D).withOpacity(.2),
                    onPressed: () {
                      setupCancelReason('cancelled,Accidental request');
                    },
                    child: Text('Fare is too high',
                        style: roboto50012.copyWith(color: Colors.black))),
                MaterialButton(
                    elevation: 0,
                    minWidth: Get.width,
                    color: Colors.green,
                    onPressed: () {
                      Get.back();
                    },
                    child: Text('Don\'t cancel.',
                        style: roboto50012.copyWith(color: Colors.white))),
                SizedBox(height: 5.h),
              ],
            ),
          ),
        );
      },
    );
  }

  void setupCancelReason(String reason) {
    rideRequestRef.child(requestKey!).child('status').set(reason);
    Get.snackbar('Koooly', 'Ride has been cancelled, Thank You.'.tr,
        snackPosition: SnackPosition.BOTTOM,
        colorText: Colors.white,
        backgroundColor: Color(0xffFE620D).withOpacity(.8),
        duration: const Duration(seconds: 1));
    Get.offAllNamed(Routes.home);
  }
}
