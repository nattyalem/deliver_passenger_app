import 'package:get/get.dart';
import 'package:koooly_user/modules/select_car/select_car_controller.dart';

class SelectCarBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => SelectCarController());
  }
}
