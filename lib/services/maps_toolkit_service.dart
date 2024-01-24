import 'package:maps_toolkit/maps_toolkit.dart';

class MapsToolKitService{
  static num getMarkerRotations(srcLat,srcLng,dropLat,dropLng,){
    return SphericalUtil.computeHeading(LatLng(srcLat,srcLng), LatLng(dropLat,dropLng));
  }
}