import 'package:ecodrive/ui/home/controller/home_controller.dart';
import 'package:ecodrive/ui/home/controller/home_repository.dart';
import 'package:ecodrive/ui/home/data/home_api.dart';
import 'package:ecodrive/ui/home/data/home_repository_impl.dart';
import 'package:get/get.dart';

class HomeBinding implements Bindings {
  @override
  void dependencies() {
    Get.put(HomeApi());
    Get.lazyPut<HomeRepository>(() => HomeRepositoryImpl(Get.find()));
    Get.lazyPut<HomeController>(() => HomeController(Get.find()));
  }
}
