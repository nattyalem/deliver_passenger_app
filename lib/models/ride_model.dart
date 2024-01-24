class RideModel {
  String? rideId;
  String? driverId;
  DropOff? dropOff;
  String? dropOffAddress;
  bool? isPreorder;
  String? createdAt;
  String? pickupAddress;
  String? riderPhone;
  String? token;
  DriverInfo? driverInfo;
  DropOff? pickUp;
  String? pickupDate;
  String? riderName;
  String? selectedCarType;
  String? riderId;
  String? paymentMethod;
  String? status;

  RideModel(
      {this.rideId,
        this.driverId,
        this.dropOff,
        this.dropOffAddress,
        this.isPreorder,
        this.createdAt,
        this.pickupAddress,
        this.riderPhone,
        this.token,
        this.driverInfo,
        this.pickUp,
        this.pickupDate,
        this.riderName,
        this.selectedCarType,
        this.riderId,
        this.paymentMethod,
        this.status});

  RideModel.fromJson(Map json) {
    rideId = json['ride_id'];
    driverId = json['driver_id'];
    dropOff = json['drop_off'] != null
        ? new DropOff.fromJson(json['drop_off'])
        : null;
    dropOffAddress = json['drop_off_address'];
    isPreorder = json['is_preorder'];
    createdAt = json['created_at'];
    pickupAddress = json['pickup_address'];
    riderPhone = json['rider_phone'];
    token = json['token'];
    driverInfo = json['driverInfo'] != null
        ? new DriverInfo.fromJson(json['driverInfo'])
        : null;
    pickUp =
    json['pick_up'] != null ? new DropOff.fromJson(json['pick_up']) : null;
    pickupDate = json['pickup_date'];
    riderName = json['rider_name'];
    selectedCarType = json['selected_car_type'];
    riderId = json['rider_id'];
    paymentMethod = json['payment_method'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ride_id'] = this.rideId;
    data['driver_id'] = this.driverId;
    if (this.dropOff != null) {
      data['drop_off'] = this.dropOff!.toJson();
    }
    data['drop_off_address'] = this.dropOffAddress;
    data['is_preorder'] = this.isPreorder;
    data['created_at'] = this.createdAt;
    data['pickup_address'] = this.pickupAddress;
    data['rider_phone'] = this.riderPhone;
    data['token'] = this.token;
    if (this.driverInfo != null) {
      data['driverInfo'] = this.driverInfo!.toJson();
    }
    if (this.pickUp != null) {
      data['pick_up'] = this.pickUp!.toJson();
    }
    data['pickup_date'] = this.pickupDate;
    data['rider_name'] = this.riderName;
    data['selected_car_type'] = this.selectedCarType;
    data['rider_id'] = this.riderId;
    data['payment_method'] = this.paymentMethod;
    data['status'] = this.status;
    return data;
  }
}

class DropOff {
  String? latitude;
  String? longitude;

  DropOff({this.latitude, this.longitude});

  DropOff.fromJson(json) {
    latitude = json['latitude'];
    longitude = json['longitude'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    return data;
  }
}

class DriverInfo {
  String? carPlate;
  String? carColor;
  DropOff? driverLocation;
  String? phone;
  String? driverName;
  String? carModel;

  DriverInfo(
      {this.carPlate,
        this.carColor,
        this.driverLocation,
        this.phone,
        this.driverName,
        this.carModel});

  DriverInfo.fromJson( json) {
    carPlate = json['carPlate'];
    carColor = json['carColor'];
    driverLocation = json['driverLocation'] != null
        ? new DropOff.fromJson(json['driverLocation'])
        : null;
    phone = json['phone'];
    driverName = json['driverName'];
    carModel = json['carModel'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['carPlate'] = this.carPlate;
    data['carColor'] = this.carColor;
    if (this.driverLocation != null) {
      data['driverLocation'] = this.driverLocation!.toJson();
    }
    data['phone'] = this.phone;
    data['driverName'] = this.driverName;
    data['carModel'] = this.carModel;
    return data;
  }
}
