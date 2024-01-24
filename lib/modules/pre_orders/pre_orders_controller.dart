import 'package:firebase_database/firebase_database.dart';
import 'package:get/get.dart';
import 'package:koooly_user/constants/data_constants.dart';
import 'package:koooly_user/models/ride_model.dart';

class PreOrdersController extends GetxController {
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
          Map<dynamic, dynamic> formattedMap = value as Map;
          if (formattedMap['is_preorder']) {
            formattedMap['ride_id'] = key;
            rideLists.add(RideModel.fromJson(formattedMap));
          }
        });
        //   String data = value.snapshot.value.toString().removeAllWhitespace;
        //   String formattedData = data.substring(22, data.length - 2) +
        //       ',ride_id:' +
        //       data.substring(1, 21) +
        //       '}';
        //
        //   String jsonString = '{';
        //   // Split the string into individual key-value pairs
        //   List<String> keyValuePairs = formattedData.replaceAll('{','').replaceAll("}", '').split(',');
        //   print(keyValuePairs);
        //   // Process each key-value pair
        //   for (int i = 0; i < keyValuePairs.length; i++) {
        //     String keyValue = keyValuePairs[i];
        //     int colonIndex = keyValue.indexOf(':');
        //     String key = keyValue.substring(0, colonIndex).trim();
        //     String value = keyValue.substring(colonIndex + 1).trim();
        //     // Add double quotes to the key and value
        //     jsonString += '"$key":"$value"';
        //     // Add a comma after each key-value pair, except for the last one
        //     if (i < keyValuePairs.length - 1) {
        //       jsonString += ',';
        //     }
        //   }
        //
        //   jsonString += '}';
        //   Map<String, dynamic> rideMap = jsonDecode(jsonString);
        //   print(rideMap.toString());
        // }
      }
      loading.value = false;
    });
    // if (GetStorage().read(preOrderKey) != null) {
    //   List tempProducts = GetStorage()
    //       .read(preOrderKey)
    //       .map((e) => RideDetails.fromJson(e))
    //       .toList();
    //   for (RideDetails element in tempProducts) {
    //     preOrders.add(element);
    //   }
    // }
  }

// addRiderToPreOrder() {
//   GetStorage().write(preOrderKey, preOrders.toList());
// }
}
