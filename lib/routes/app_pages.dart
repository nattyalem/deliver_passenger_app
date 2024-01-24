import 'package:get/get.dart';
import 'package:koooly_user/modules/connection_checker/connection_checker_binding.dart';
import 'package:koooly_user/modules/connection_checker/connection_checker_view.dart';
import 'package:koooly_user/modules/end_trip/end_trip_binding.dart';
import 'package:koooly_user/modules/end_trip/end_trip_view.dart';
import 'package:koooly_user/modules/history/history_binding.dart';
import 'package:koooly_user/modules/history/history_view.dart';
import 'package:koooly_user/modules/home/home_binding.dart';
import 'package:koooly_user/modules/home/home_view.dart';
import 'package:koooly_user/modules/login/login_binding.dart';
import 'package:koooly_user/modules/login/login_view.dart';
import 'package:koooly_user/modules/miles/miles_binding.dart';
import 'package:koooly_user/modules/miles/miles_view.dart';
import 'package:koooly_user/modules/otp/otp_binding.dart';
import 'package:koooly_user/modules/otp/otp_view.dart';
import 'package:koooly_user/modules/pickup_request/PickupRequestBinding.dart';
import 'package:koooly_user/modules/pickup_request/pickup_request_view.dart';
import 'package:koooly_user/modules/pre_orders/pre_orders_binding.dart';
import 'package:koooly_user/modules/pre_orders/pre_orders_view.dart';
import 'package:koooly_user/modules/search_places/search_places_binding.dart';
import 'package:koooly_user/modules/search_places/search_places_view.dart';
import 'package:koooly_user/modules/select_car/select_car_binding.dart';
import 'package:koooly_user/modules/select_car/select_car_view.dart';
import 'package:koooly_user/modules/signup/signup_binding.dart';
import 'package:koooly_user/modules/signup/signup_view.dart';
import 'package:koooly_user/widgets/comming_soon_page.dart';
part 'app_routes.dart';

// ignore: avoid_classes_with_only_static_members
class AppPages {
  // static String initial = box.read(savedUserId)!=null? Routes.home: Routes.login;
  static String initial = Routes.connectionChecker;

  static final routes = [
    GetPage(
        name: Routes.connectionChecker,
        page: () => const ConnectionCheckerView(),
        binding: ConnectionCheckerBinding()),
    GetPage(
        name: Routes.home,
        page: () => const HomeView(),
        binding: HomeBinding()),
    GetPage(
        name: Routes.searchPlaces,
        page: () => const SearchPlacesView(),
        binding: SearchPlacesBiding()),
    GetPage(
        name: Routes.selectCars,
        page: () => const SelectCarView(),
        binding: SelectCarBinding()),
    GetPage(
        name: Routes.login,
        page: () => const LoginView(),
        binding: LoginBinding()),
    GetPage(
        name: Routes.signup,
        page: () => const SignUpView(),
        binding: SignUpBinding()),
    GetPage(
        name: Routes.otp, page: () => const OTPView(), binding: OTPBinding()),
    GetPage(
        name: Routes.pickUpRequest,
        page: () => const PickupRequestView(),
        binding: PickupRequestBinding()),
    GetPage(
        name: Routes.endTrip,
        page: () => const EndTripView(),
        binding: EndTripBinding()),
    GetPage(
        name: Routes.preOrders,
        page: () => const PreOrdersView(),
        binding: PreOrdersBinding()),
    GetPage(name: Routes.comingSoon, page: () => ComingSoonPage()),
    GetPage(
        name: Routes.miles, page: () => MilesView(), binding: MilesBinding()),
    GetPage(
        name: Routes.history,
        page: () => HistoryView(),
        binding: HistoryBinding())
  ];
}
