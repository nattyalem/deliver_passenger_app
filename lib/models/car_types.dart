class CarTypes {
  final String vehicleType;
  final num percentageCut;
  final num pricePerKm;
  final num startingPrice;
  final String image;

  CarTypes(
      {required this.vehicleType,
      required this.percentageCut,
      required this.pricePerKm,
      required this.startingPrice,
      required this.image});

  static List<CarTypes> carList = [
    // CarTypes(CarTypesEnum.Motorcycle.name, 'assets/images/motorbike.png'),
    // CarTypes(CarTypesEnum.Car.name, 'assets/images/car.png'),
    // CarTypes(CarTypesEnum.Pickup.name, 'assets/images/pickup.png'),
  ];
}

enum CarTypesEnum {
  // ignore: constant_identifier_names
  Motorcycle,
  Car,
  Pickup
}
