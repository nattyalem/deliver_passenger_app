import 'package:get/get.dart';
import 'package:koooly_user/models/address.dart';

class RouteService extends GetxService {
  Address? pickUpLocation;
  Address? dropOffLocation;
  Address? currentLocation;
  bool isInCorporateMode = false;
}
