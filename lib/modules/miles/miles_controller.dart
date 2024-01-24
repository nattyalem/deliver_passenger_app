import 'package:get/get.dart';
import 'package:koooly_user/constants/data_constants.dart';

class MilesController extends GetxController {
  RxInt miles = 0.obs;

  @override
  void onInit() {
    userRef
      ..child(firebaseUser!.uid).child('miles').once().then((value) {
        if (value.snapshot.value != null) {
          miles.value = value.snapshot.value as int;
        }
      });
    super.onInit();
  }
}
