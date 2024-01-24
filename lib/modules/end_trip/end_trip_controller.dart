import 'package:get/get.dart';

class EndTripController extends GetxController{
  late String totalPrice;
  @override
  void onInit() {
    super.onInit();
    totalPrice = Get.arguments['totalPrice'];
  }
}