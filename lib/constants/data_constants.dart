import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:koooly_user/models/nearby_available_drivers.dart';
import 'package:koooly_user/models/users.dart';
import 'package:koooly_user/services/push_notification_service.dart';

final box = GetStorage();
const String savedUserId = 'USER_ID';
const String preOrderKey = 'PRE_ORDERS';
const int milliSeconds = 500;
const Duration animationDuration = Duration(milliseconds: milliSeconds);
const double maxSlide = 225.0;
const double dragLeftStart = maxSlide - 30;
const double dragRightStart = 60;
const String mapApiKey = 'AIzaSyAnK4hH6JIwcrNOED_cAATG5hPref7GiOc';
const String serverKey =
    'key=AAAAj072XMQ:APA91bEf4z-wGa5zB0C_ic2Dsm5X-rAZWNImYoaFZtmcpJnOn1cwMnhuTHLcQrsBnTJI8q8aBEno9c81UNgJ4q52f4IMA6pjGJ0JEEytf9DHu-qaDfW_j0mW0UYDJKMmKOzyrq_Poy7z';

const LatLng addisLatLng = LatLng(9.005401, 38.763611);
const String responseFailed = 'failed';

User? firebaseUser;
Users? userCurrentInfo;
DatabaseReference userRef = FirebaseDatabase.instance.ref('users');
DatabaseReference driverRef = FirebaseDatabase.instance.ref('drivers');
DatabaseReference corporateRef = FirebaseDatabase.instance.ref('corporates');
DatabaseReference carTypesRef = FirebaseDatabase.instance.ref('Car Types');
List<NearByAvailableDrivers> nearByAvailableDriversList = [];
// bool nearByAvailableDriversLoaded = false;

CameraPosition addisAbabaCenter = const CameraPosition(
  target: addisLatLng,
  zoom: 14.4746,
);

PushNotificationService pushNotificationService = PushNotificationService();

DateFormat timeFormatter = DateFormat('dd-MM-yy HH:MM');

class Constants {}
