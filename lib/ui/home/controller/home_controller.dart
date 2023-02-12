
import 'package:ecodrive/ui/home/controller/home_repository.dart';
import 'package:ecodrive/ui/home/pages/car_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';





class HomeController extends GetxController {
  HomeController(this._homeRepository);

  final HomeRepository _homeRepository;



  int pageIndex = 0;


  final pages = const [
    CarPage()
  ];



  late Widget content = pages[0];







  @override
  void onInit() {
    super.onInit();
    getUserData();

  }


  @override
  void onReady() async {
    super.onReady();
/*
    if (kIsWeb) {
      await Get.find<LocationService>().initPermission();
    } else {
      await Get.find<LocationService>().initPermissionService();
      await Get.find<LocationService>().initBackgroundFetch();
    }

 */

    //await PushNotification().startService();
  }

  @override
  void onClose() {
    super.onClose();
  }



  Future<void> getUserData()async{

  }

  void buttonSignOut() {
    /*
    Get.dialog(
      CustomTwoOptionsDialog(
        title: 'Sair',
        msg: 'Tem certeza que você deseja sair da sua conta?',
        no: () {
          Get.back();
        },
        yes: () {
          auth.logout();
        },
      ),
    );

     */
  }

  void excludeAccount() {
    /*
    Get.dialog(
      CustomTwoOptionsDialog(
        title: 'Excluir Conta',
        msg: 'Tem certeza que você deseja excluir a sua conta ?',
        no: () {
          Get.back();
        },
        yes: () async {
          await auth.excludeAccount();
        },
      ),
    );

     */
  }

  Future<void> launchWhatsapp(String text) async {
    final urlValue = Uri.parse("https://wa.me/+551152424499/?text=$text");


    //await launchUrl(urlValue, mode: LaunchMode.externalApplication);
  }







  void setPage(int idx, BuildContext context) {
    if (idx == pageIndex) return;
    pageIndex = idx;
    content = pages[pageIndex];
    update();
/*
    switch (idx) {
      case 0:
        setApplicationSwitcherDescription('Neo - Home', context);
        break;
      case 1:
        Get.find<LocationService>().checkPermission();
        setApplicationSwitcherDescription('Neo - Perfil', context);
        break;
      case 2:
        break;

      case 3:
        getNotifications();
        setApplicationSwitcherDescription('Neo - Notificações', context);
        break;
    }

 */
  }






}
