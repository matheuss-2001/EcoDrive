import 'package:get/get.dart';


class HomeApi extends GetConnect {
  @override
  void onInit() {
    super.onInit();
    timeout = const Duration(seconds: 20);
    httpClient.timeout = const Duration(seconds: 20);
  }


}
