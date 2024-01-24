import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_geofire/flutter_geofire.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:koooly_user/constants/data_constants.dart';
import 'package:koooly_user/models/address.dart';
import 'package:koooly_user/models/car_types.dart';
import 'package:koooly_user/models/direcction_details.dart';
import 'package:koooly_user/models/nearby_available_drivers.dart';
import 'package:koooly_user/models/users.dart';
import 'package:koooly_user/services/geofire_methods.dart';
import 'package:koooly_user/services/request_handler_service.dart';
import 'package:koooly_user/services/route_service.dart';

class ServiceMethods {
  static final RouteService routeService = Get.find<RouteService>();

  static Future<DirectionDetails?> getPlaceDirectionDetails(
      LatLng initialPosition, LatLng finalPosition) async {
    String directionUrl = 'https://maps.googleapis.com/maps/api/directions/json'
        '?destination=${finalPosition.latitude},${finalPosition.longitude}'
        '&origin=${initialPosition.latitude},${initialPosition.longitude}'
        '&key=$mapApiKey';

    var response = await RequestHandlerService.getRequest(directionUrl);

    if (response == responseFailed) {
      return null;
    }
    if (response['status'] == 'OK') {
      DirectionDetails directionDetails = DirectionDetails();
      directionDetails.encodedPoints =
          response['routes'][0]['overview_polyline']['points'];
      directionDetails.distanceText =
          response['routes'][0]['legs'][0]['distance']['text'];
      directionDetails.distanceValue =
          response['routes'][0]['legs'][0]['distance']['value'];
      directionDetails.durationText =
          response['routes'][0]['legs'][0]['duration']['text'];
      directionDetails.durationValue =
          response['routes'][0]['legs'][0]['distance']['value'];
      return directionDetails;
    } else {
      return null;
    }
  }

  static searchCoordinateAddress(LatLng position) async {
    String placeAddress = '';
    String st1, st2, st3, st4;

    String url =
        'https://maps.googleapis.com/maps/api/geocode/json?latlng=${position.latitude},${position.longitude}&key=$mapApiKey';
    var response = await RequestHandlerService.getRequest(url);

    if (response != responseFailed) {
      placeAddress = response['results'][0]['formatted_address'];
      // st1 =  response['results'][0]['address_components'][3]['long_name'];
      // st2 =  response['results'][0]['address_components'][4]['long_name'];
      // st3 =  response['results'][0]['address_components'][5]['long_name'];
      // st4 =  response['results'][0]['address_compmjhonents'][6]['long_name'];
      // placeAddress = st1+', '+st2+', '+st3+', '+st4;

      Address userPickUpAddress = Address();
      userPickUpAddress.latitude = position.latitude;
      userPickUpAddress.longitude = position.longitude;
      userPickUpAddress.placeName = placeAddress;
      userPickUpAddress.placeFormattedAddress = placeAddress;
      routeService.pickUpLocation = userPickUpAddress;
      routeService.currentLocation = userPickUpAddress;
    } else {
      print('request failde');
      print(response.toString());
    }

    return placeAddress;
  }

  static getCurrentOnlineUserInfo() async {
    firebaseUser = FirebaseAuth.instance.currentUser;
    if (firebaseUser != null) {
      userRef.child(firebaseUser!.uid).once().then((value) {
        if (value.snapshot.value != null) {
          userCurrentInfo = Users.fromSnapshot(value.snapshot);
        }
      });
    }
  }

  static void sendNotificationToDriver(
      String token, String rideRequestId, bool isPreOrder) {
    print('requestUd');
    print(rideRequestId);
    print(token);

    Map<String, String> header = {
      'Content-Type': 'application/json',
      'Authorization': serverKey
    };

    Map<String, dynamic> body = {
      "notification": {
        "body":
            "DropOff Address, ${routeService.dropOffLocation!.placeFormattedAddress.toString()}",
        "title": isPreOrder ? "New Pre Order Ride Request" : "New Ride Request"
      },
      "priority": "high",
      "data": {
        "click_action": "FLUTTER_NOTIFICATION_CLICK",
        "id": "1",
        "status": "done",
        "ride_request_id": rideRequestId,
        // "body":
        // "DropOff Address, ${routeService.dropOffLocation!.placeFormattedAddress.toString()}",
        // "title": isPreOrder ? "New Pre Order Ride Request" : "New Ride Request"
      },
      "to": token
    };

    RequestHandlerService.postRequest(
        'https://fcm.googleapis.com/fcm/send', header, jsonEncode(body));
  }

  static void initGeofireListener() {
    // if (nearByAvailableDriversLoaded == false) {
    nearByAvailableDriversList.clear();
    Geofire.initialize('availableDrivers');
    Geofire.queryAtLocation(routeService.currentLocation!.latitude!,
            routeService.currentLocation!.longitude!, 5)!
        .listen((map) {
      if (map != null) {
        var callBack = map['callBack'];
        //latitude will be retrieved from map['latitude']
        //longitude will be retrieved from map['longitude']
        switch (callBack) {
          case Geofire.onKeyEntered:
            NearByAvailableDrivers nearByAvailableDrivers =
                NearByAvailableDrivers(
                    key: map["key"],
                    latitude: map["latitude"],
                    longitude: map["longitude"]);
            bool found = false;
            for (int i = 0; i < nearByAvailableDriversList.length; i++) {
              String key = nearByAvailableDriversList[i].key;
              if (nearByAvailableDriversList[i].key == key) {
                found = true;
                break;
              }
            }
            if (!found) {
              nearByAvailableDriversList.add(nearByAvailableDrivers);
            }
            for (NearByAvailableDrivers obj in nearByAvailableDriversList) {
              print(nearByAvailableDriversList.length);
              print(obj.key + 'mappppppppppppppp');
            }
            break;
          case Geofire.onKeyExited:
            GeofireMethods.removeDriverFromList(map["key"]);
            break;

          case Geofire.onKeyMoved:
            // NearByAvailableDrivers nearByAvailableDrivers =
            //     NearByAvailableDrivers(
            //         key: map["key"],
            //         latitude: map["latitude"],
            //         longitude: map["longitude"]);
            // GeofireMethods.updateDriverLocation(nearByAvailableDrivers);
            break;

          case Geofire.onGeoQueryReady:
            // nearByAvailableDriversLoaded = true;
            break;
        }
      }
    });
  }

  // }

  static int calculateFare(
      DirectionDetails directionDetails, CarTypes carType) {
    // print(directionDetails.durationValue!);
    print(directionDetails.distanceValue!);
    double timeTravelFare = (directionDetails.durationValue! / 60) * 0.15;
    double distanceTravelFare =
        (directionDetails.distanceValue! / 1000) * carType.pricePerKm;

    double totalFareAmount = 0.0;
    totalFareAmount = (timeTravelFare + distanceTravelFare);
    // * 5;

    print('cartyoe' + carType.toString());

    // if (carType == CarTypesEnum.Motorcycle.name) {
    //   totalFareAmount += 105;
    // } else if (carType == CarTypesEnum.Car.name) {
    //   totalFareAmount += 110;
    // } else if (carType == CarTypesEnum.Pickup.name) {
    //   totalFareAmount += 120;
    // } else {
    //   totalFareAmount = 0;
    // }
    totalFareAmount += carType.startingPrice;
    return totalFareAmount.truncate();
  }
}
