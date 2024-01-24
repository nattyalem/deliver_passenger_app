import 'package:koooly_user/constants/data_constants.dart';
import 'package:koooly_user/models/nearby_available_drivers.dart';

class GeofireMethods {
  static void removeDriverFromList(String key) {
    int index =
        nearByAvailableDriversList.indexWhere((element) => element.key == key);

    if (nearByAvailableDriversList.isNotEmpty) {
      nearByAvailableDriversList.removeAt(index);
    }
  }

  static void updateDriverLocation(NearByAvailableDrivers driver) {
    int index = nearByAvailableDriversList
        .indexWhere((element) => element.key == driver.key);
    if (index > -1) {
      nearByAvailableDriversList[index].latitude = driver.latitude;
      nearByAvailableDriversList[index].longitude = driver.longitude;
    }
  }
}
