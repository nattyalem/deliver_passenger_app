import 'package:get/get.dart';
import 'package:koooly_user/modules/history/history_controller.dart';

class HistoryBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => HistoryController());
  }
}
