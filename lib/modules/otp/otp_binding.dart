import 'package:get/get.dart';
import 'package:koooly_user/modules/otp/otp_controller.dart';

class OTPBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => OTPController());
  }
}
