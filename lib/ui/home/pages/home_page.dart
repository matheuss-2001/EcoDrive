import 'package:ecodrive/app/helpers/global_variables.dart';
import 'package:ecodrive/app/widgets/bottom_app_bar.dart';
import 'package:ecodrive/ui/home/controller/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NeoHomePage extends GetView<HomeController> {
  const NeoHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return GetBuilder<HomeController>(builder: (controller) {
      return WillPopScope(
        onWillPop: () async {
          if (controller.pageIndex != 0) {
            controller.setPage(0, context);
            return false;
          }
          return true;
        },
        child: Scaffold(
          appBar: _buildAppBar(),
          body: _buildBody(size),
          bottomNavigationBar: _buildBottomNavigationBar(size),
        ),
      );
    });
  }

  AppBar _buildAppBar() {
    return AppBar(
      leadingWidth: 100,
      centerTitle: true,
      /*
      leading: Padding(
        padding: const EdgeInsets.only(left: 16.0),
        child: Image.asset(
          OneAssets.logoText,
          scale: 5,
        ),
      ),

       */
      title: FittedBox(
        child: Text(
          " ",
          //controller.getTitle,
          style: OneStyles.subtitle.copyWith(
              color: OneColors.accentDark,
              fontWeight: FontWeight.bold,
              fontSize: 16),
        ),
      ),
      actions: [
        if (controller.pageIndex == 1)
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: IconButton(
              icon: const Icon(
                Icons.refresh,
                color: OneColors.accentDark,
                size: 28,
              ),
              onPressed: () {
                // controller.refreshProfile(withLoading: true);
              },
              tooltip: 'Atualizar Perfil',
            ),
          ),
        Padding(
          padding: const EdgeInsets.only(right: 16),
          child: IconButton(
            icon: const Icon(
              Icons.help_outline,
              color: OneColors.accentDark,
              size: 28,
            ),
            onPressed: () {
              controller.launchWhatsapp('Olá,  preciso de suporte');
            },
            tooltip: 'Ajuda',
          ),
        ),
      ],
    );
  }

  Widget _buildBody(Size size) {
    return size.width < 1000
        ? controller.content
        : Stack(
            children: [
              controller.content,
              const Align(
                alignment: Alignment.centerLeft,
                child: CustomBottomBar(),
              ),
            ],
          );
  }

  Widget? _buildBottomNavigationBar(Size size) {
    return size.width < 1000 ? const CustomBottomBar() : null;
  }
}
