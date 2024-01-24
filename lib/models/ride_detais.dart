import 'package:google_maps_flutter/google_maps_flutter.dart';

class RideDetails {
  late String pickupAddress;
  late String dropOffAddress;
  late LatLng pickup;
  late LatLng dropOff;
  late String rideRequestId;
  late String paymentMethod;
  late String riderName;
  late String riderPhone;
  late String pickupDate;
  late bool isPreorder;

  RideDetails(
      this.pickupAddress,
      this.dropOffAddress,
      this.pickup,
      this.dropOff,
      this.rideRequestId,
      this.paymentMethod,
      this.riderName,
      this.riderPhone,
      this.pickupDate,
      this.isPreorder);

  RideDetails.fromJson(Map<String, dynamic> json) {
    pickupAddress = json['pickupAddress'];
    dropOffAddress = json['dropOffAddress'];
    pickup = json['pickup'];
    dropOff = json['dropOff'];
    rideRequestId = json['rideRequestId'];
    paymentMethod = json['paymentMethod'];
    riderName = json['riderName'];
    riderPhone = json['riderPhone'];
    pickupDate = json['pickupDate'];
    isPreorder = json['isPreorder'];
  }
}
