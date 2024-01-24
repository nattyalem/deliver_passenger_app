import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:koooly_user/constants/data_constants.dart';
import 'package:koooly_user/models/address.dart';
import 'package:koooly_user/models/place_predictions.dart';
import 'package:koooly_user/services/request_handler_service.dart';
import 'package:koooly_user/services/route_service.dart';

class SearchPlacesController extends GetxController {
  late TextEditingController pickUpController;
  late TextEditingController dropOffController;
  late TextEditingController phoneController;
  late FocusNode pickupFocus;
  late FocusNode dropFocus;
  late FocusNode phoneFocus;
  final RouteService routeService = Get.find<RouteService>();

  RxList<PlacePredictions> placePredictionList = <PlacePredictions>[].obs;

  String? userPhone;

  @override
  void onInit() {
    userPhone = Get.arguments != null ? Get.arguments['userPhone'] : null;
    pickUpController = TextEditingController(
        text: userPhone != null ? '' : routeService.pickUpLocation!.placeName);
    dropOffController = TextEditingController();
    phoneController = TextEditingController();
    pickupFocus = FocusNode();
    dropFocus = FocusNode();
    phoneFocus = FocusNode();
    super.onInit();
  }

  @override
  void onClose() {
    pickupFocus.dispose();
    pickUpController.dispose();
    dropOffController.dispose();
    phoneController.dispose();
    dropFocus.dispose();
    phoneFocus.dispose();
    super.onClose();
  }

  searchPlaces(String placeName) async {
    if (placeName.length > 2) {
      String autoCompleteUrl =
          'https://maps.googleapis.com/maps/api/place/autocomplete/json'
          '?input=$placeName'
          '&location=${addisLatLng.latitude},${addisLatLng.longitude}'
          '&radius=${30000}'
          '&strictbounds'
          '&key=$mapApiKey'
          '&components=country:et';

      var response = await RequestHandlerService.getRequest(autoCompleteUrl);
      if (response == responseFailed) {
        return;
      }

      if (response['status'] == 'OK') {
        var predictions = response['predictions'];

        List<PlacePredictions> placesList = (predictions as List)
            .map((e) => PlacePredictions.fromJson(e))
            .toList();
        placePredictionList.value = placesList;
      }
    }
  }

  Future<bool> getPlaceAddressDetails(String? placeID, bool isDropOff) async {
    String detailUrl = 'https://maps.googleapis.com/maps/api/place/details/json'
        '?place_id=$placeID'
        '&key=$mapApiKey';
    var response = await RequestHandlerService.getRequest(detailUrl);
    if (response == responseFailed) {
      return false;
    }

    if (response['status'] == 'OK') {
      Address address = Address();
      address.placeName = response['result']['name'];
      address.placeId = placeID;
      address.latitude = response['result']['geometry']['location']['lat'];
      address.longitude = response['result']['geometry']['location']['lng'];
      address.placeFormattedAddress = response['result']['formatted_address'];

      if (isDropOff) {
        dropOffController.text = address.placeName.toString();
        routeService.dropOffLocation = address;
      } else {
        pickUpController.text = address.placeName.toString();
        routeService.pickUpLocation = address;
      }
      return true;
    } else {
      return false;
    }
  }
}
