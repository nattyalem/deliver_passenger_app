import 'package:get/get.dart';
import 'package:koooly_user/modules/end_trip/end_trip_controller.dart';

class EndTripBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => EndTripController());
  }
}
