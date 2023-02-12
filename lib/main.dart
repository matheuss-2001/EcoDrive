import 'package:ecodrive/app/helpers/global_variables.dart';
import 'package:ecodrive/app/routes/app_pages.dart';
import 'package:ecodrive/app/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'EcoDrive',
      supportedLocales: const [Locale('pt', 'BR')],
      locale: const Locale('pt', 'BR'),
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      defaultTransition: Transition.cupertino,
      transitionDuration: const Duration(milliseconds: 450),
      debugShowCheckedModeBanner: false,
      //initialBinding: InitialBinding(),
      theme: ThemeData(
        brightness: Brightness.light,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        fontFamily: OneStyles.fontFamilyPoppins,
        appBarTheme: const AppBarTheme(
            iconTheme: IconThemeData(color: OneColors.accentDark),
            backgroundColor: Colors.white,
            elevation: 20,
            shadowColor: OneColors.backShadow,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(20),
              ),
            ),
            centerTitle: true),
        scaffoldBackgroundColor: OneColors.whiteBg,
        cardColor: Colors.white,
        primaryColor: OneColors.primaryDark,
        colorScheme:
            ColorScheme.fromSwatch(primarySwatch: Palette.primarySwatch),
        primaryTextTheme:
            const TextTheme(titleSmall: TextStyle(color: OneColors.accentDark)),
      ),
      getPages: AppPages.pages,
      initialRoute: Routes.HOME,
      routingCallback: (routing) {
        //setPageTitle(routing?.current, context);
      },
      builder: (context, child) {
        return Container(
          height: 200,
          width: 200,
          color: Colors.pink,
        );

        /*
          Material(
          child: Stack(
            children: [
              child!,
              Obx(
                    () {
                  final currentUser = Get.find<AuthService>().user;
                  String userName = '';
                  if (currentUser.value.name != null &&
                      currentUser.value.name!.isNotEmpty) {
                    userName = currentUser.value.name!;
                  } else {
                    userName = currentUser.value.name ?? '';
                  }
                  return Visibility(
                      visible: Get.find<DynamicLinkService>().isLoading.value,
                      child: Container(
                        width: Get.size.width,
                        height: Get.size.height,
                        color: Colors.white,
                        child: Container(
                          alignment: Alignment.center,
                          width: Get.size.width,
                          height: Get.size.height,
                          margin: EdgeInsets.symmetric(
                              horizontal: Get.size.width <= 700
                                  ? 0
                                  : Get.size.width <= 1000
                                  ? Get.size.width * 0.1
                                  : Get.size.width <= 1440
                                  ? Get.size.width * 0.22
                                  : Get.size.width * 0.28,
                              vertical: Get.size.width > 700
                                  ? Get.size.height * 0.05
                                  : 0),
                          padding: const EdgeInsets.all(12.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(
                                Get.size.width > 700 ? 20 : 0),
                            color: OneColors.primaryDark,
                            boxShadow: [
                              BoxShadow(
                                offset: const Offset(0, 0.0),
                                blurRadius: 15.0,
                                spreadRadius: 2.0,
                                color: Colors.black.withOpacity(0.05),
                              ),
                            ],
                          ),
                          child: SafeArea(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Image.asset(
                                  OneAssets.logoTextWhite,
                                  height: Get.size.height * 0.1,
                                  fit: BoxFit.fitHeight,
                                ),
                                Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 16),
                                      child: Wrap(
                                        alignment: WrapAlignment.center,
                                        spacing: 8,
                                        children: [
                                          Text(
                                            'Aguarde um momento',
                                            textAlign: TextAlign.center,
                                            style: OneStyles.pageTitle.copyWith(
                                                color: OneColors.whiteBg,
                                                fontWeight: FontWeight.bold,
                                                fontSize:
                                                Get.size.height * 0.035),
                                          ),
                                          Text(
                                            userName,
                                            textAlign: TextAlign.center,
                                            style: OneStyles.pageTitle.copyWith(
                                                color: OneColors.whiteBg,
                                                fontWeight: FontWeight.bold,
                                                fontSize:
                                                Get.size.height * 0.035),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(height: 30),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 16),
                                      child: Text(
                                        'Estamos montando as melhores opções de coberturas para você e seu veículo!',
                                        textAlign: TextAlign.center,
                                        style: OneStyles.body.copyWith(
                                            color: OneColors.whiteBg,
                                            fontWeight: FontWeight.w600,
                                            fontSize: Get.size.height * 0.025),
                                      ),
                                    ),
                                  ],
                                ),
                                /*
                                LottieBuilder.asset(
                                  OneAssets.loadingAstrounaut,
                                  height: Get.size.height * 0.3,
                                  repeat: true,
                                ),

                                 */
                              ],
                            ),
                          ),
                        ),
                      ));
                },
              ),
            ],
          ),
        );

     */
      },
    );
  }
}
