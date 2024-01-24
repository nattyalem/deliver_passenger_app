import 'package:get/get.dart';
import 'package:koooly_user/modules/search_places/search_places_controller.dart';

class SearchPlacesBiding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => SearchPlacesController());
  }
}
