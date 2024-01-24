import 'package:get/get.dart';
import 'package:koooly_user/modules/connection_checker/connection_checker_controller.dart';

class ConnectionCheckerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ConnectionCheckerController());
  }
}
