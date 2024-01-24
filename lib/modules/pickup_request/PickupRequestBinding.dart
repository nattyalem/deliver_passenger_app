import 'package:get/get.dart';
import 'package:koooly_user/modules/pickup_request/pickup_request_controller.dart';

class PickupRequestBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => PickupRequestController());
  }
}
