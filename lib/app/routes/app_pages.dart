
import 'package:ecodrive/app/routes/app_routes.dart';
import 'package:ecodrive/ui/home/pages/car_page.dart';
import 'package:get/get.dart';

abstract class AppPages {
  static final pages = [

    GetPage(
      name: Routes.HOME,
      page: () => const CarPage(),
    ),

  ];
}
