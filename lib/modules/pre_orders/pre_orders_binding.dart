import 'package:get/get.dart';
import 'package:koooly_user/modules/pre_orders/pre_orders_controller.dart';

class PreOrdersBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => PreOrdersController());
  }
}
