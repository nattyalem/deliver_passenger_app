import 'package:firebase_database/firebase_database.dart';
import 'package:get/get.dart';
import 'package:koooly_user/constants/data_constants.dart';
import 'package:koooly_user/models/ride_model.dart';

class HistoryController extends GetxController {
  final DatabaseReference rideRequestRef =
      FirebaseDatabase.instance.ref().child('Ride Requests');

  RxList<RideModel> rideLists = <RideModel>[].obs;

  RxBool loading = true.obs;

  @override
  void onInit() {
    super.onInit();
    loading.value = true;
    rideRequestRef
        .orderByChild('rider_id')
        .equalTo(firebaseUser!.uid)
        .once()
        .then((value) {
      if (value.snapshot.value != null) {
        Map<dynamic, dynamic> data =
            value.snapshot.value as Map<dynamic, dynamic>;
        data.forEach((key, value) {
          print(key);
          Map<dynamic, dynamic> formattedMap = value as Map;
          formattedMap['ride_id'] = key;
          rideLists.add(RideModel.fromJson(formattedMap));
          rideLists.value = rideLists.reversed.toList();
        });
      }
      loading.value = false;
    });
  }
}
