import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:koooly_user/models/direcction_details.dart';
import 'package:koooly_user/models/ride_detais.dart';
import 'package:koooly_user/services/maps_toolkit_service.dart';
import 'package:koooly_user/services/service_methods.dart';

import '../../services/route_service.dart';

class PickupRequestController extends GetxController {
  late RideDetails rideDetails;

  DateTime? currentBackPressTime;
  RxSet<Marker> markers = <Marker>{}.obs;
  RxSet<Circle> circles = <Circle>{}.obs;
  RxSet<Polyline> polyLineSet = <Polyline>{}.obs;
  List<LatLng> pLineCoordinates = [];
  PolylinePoints polylinePoints = PolylinePoints();

  LatLng? currentPosition;

  final Completer<GoogleMapController> controller = Completer();
  GoogleMapController? newRideGoogleMapController;
  final RouteService routeService = Get.find<RouteService>();

  String status = 'accepted';
  String userToken = '';

  StreamSubscription? rideStreamSubscription;
  Location location = Location();

  LatLng? myPosition;

  BitmapDescriptor? animatingMarkerIcon;

  RxString durationRide = ''.obs;

  bool isRequestingDirection = false;

  RxString buttonTitle = 'Arrived'.obs;

  Rx<Color> buttonColor = Color(0xffFE620D).obs;

  late Timer timer;

  int durationCounter = 0;

  @override
  void onInit() async {
    super.onInit();

    rideDetails = Get.arguments['rideDetails'];
    currentPosition = Get.arguments['currentPosition'];
  }

  getPlaceDirection(pickUpLatLng, dropOffLatLng) async {
    DirectionDetails? details = await ServiceMethods.getPlaceDirectionDetails(
        pickUpLatLng, dropOffLatLng);

    //must be dialog
    if (details != null) {
      print('this is the encoded points:: \n');
      print(details.toString());

      pLineCoordinates.clear();
      List<PointLatLng> decodedPolyLines =
          PolylinePoints().decodePolyline(details.encodedPoints!);
      if (decodedPolyLines.isNotEmpty) {
        decodedPolyLines.forEach((element) {
          pLineCoordinates.add(LatLng(element.latitude, element.longitude));
        });
      }

      polyLineSet.clear();
      Polyline polyline = Polyline(
          color: Colors.pink,
          polylineId: PolylineId('PolylineID'),
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

      newRideGoogleMapController!
          .animateCamera(CameraUpdate.newLatLngBounds(latLngBounds, 70));

      markers.clear();
      circles.clear();

      Marker pickUpMarker = Marker(
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueYellow),
        markerId: MarkerId('pickUpId'),
        position: pickUpLatLng,
        infoWindow: InfoWindow(
            title: rideDetails.pickupAddress, snippet: 'Pickup Location'),
      );
      Marker dropOffMarker = Marker(
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
        markerId: MarkerId('dropOffId'),
        position: pickUpLatLng,
        infoWindow: InfoWindow(
            title: rideDetails.dropOffAddress, snippet: 'Drop off Location'),
      );

      markers.add(pickUpMarker);
      markers.add(dropOffMarker);

      Circle pickupCircle = Circle(
          fillColor: Colors.yellow.withOpacity(.2),
          center: pickUpLatLng,
          radius: 400,
          strokeWidth: 2,
          strokeColor: Colors.yellowAccent.withOpacity(.5),
          circleId: CircleId('pickUpId'));
      Circle dropOffCircle = Circle(
          fillColor: Color(0xffFE620D).withOpacity(.2),
          center: dropOffLatLng,
          radius: 400,
          strokeWidth: 2,
          strokeColor: Color(0xffFE620D).withOpacity(.5),
          circleId: CircleId('dropOffId'));

      circles.add(pickupCircle);
      circles.add(dropOffCircle);
    }
  }

  void getRideLiveLocationUpdate() {
    LatLng oldPos = LatLng(0, 0);
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
          icon: animatingMarkerIcon!,
          infoWindow: InfoWindow(title: 'Current Location'),
          rotation: double.parse(rotation.toString()));
      CameraPosition cameraPosition =
          CameraPosition(target: myPosition!, zoom: 17);
      newRideGoogleMapController!
          .animateCamera(CameraUpdate.newCameraPosition(cameraPosition));

      markers.removeWhere((element) => element.markerId.value == 'animating');
      markers.add(animatingMarker);
      oldPos = myPosition!;
      updateRideDetails();
    });
  }

  createMarkerIcon(context) async {
    if (animatingMarkerIcon == null) {
      ImageConfiguration imageConfiguration =
          createLocalImageConfiguration(context, size: Size(2, 2));
      animatingMarkerIcon = await BitmapDescriptor.fromAssetImage(
          imageConfiguration, 'assets/images/min_red_car_for_map.png');
    }
  }

  void updateRideDetails() async {
    if (isRequestingDirection == false) {
      isRequestingDirection = true;
      if (myPosition == null) {
        return;
      }

      LatLng posLatLng = LatLng(myPosition!.latitude, myPosition!.longitude);
      LatLng destinationLatLng =
          status == 'accepted' ? rideDetails.pickup : rideDetails.dropOff;

      DirectionDetails? directionDetails =
          await ServiceMethods.getPlaceDirectionDetails(
              posLatLng, destinationLatLng);
      if (directionDetails != null) {
        durationRide.value = directionDetails.durationText!.toString();
      }
      isRequestingDirection = false;
    }
  }

  void initTimer() {
    const interval = Duration(seconds: 1);
    timer = Timer.periodic(interval, (timer) {
      durationCounter++;
    });
  }
}
