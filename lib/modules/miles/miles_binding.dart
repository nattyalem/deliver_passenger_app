import 'package:get/get.dart';
import 'package:koooly_user/modules/miles/miles_controller.dart';

class MilesBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => MilesController());
  }
}
