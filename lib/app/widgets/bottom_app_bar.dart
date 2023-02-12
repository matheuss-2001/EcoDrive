import 'package:ecodrive/app/helpers/global_variables.dart';
import 'package:ecodrive/ui/home/controller/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CustomBottomBar extends StatelessWidget {
  const CustomBottomBar({
    Key? key,
    this.onTap,
    this.index = 0,
  }) : super(key: key);

  final Function(int)? onTap;
  final int index;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    if (size.width >= 1000) {
      return GetBuilder<HomeController>(builder: (controller) {
        return ConstrainedBox(
          constraints: const BoxConstraints(minWidth: 130, maxWidth: 200),
          child: ClipRRect(
            borderRadius:
                const BorderRadius.horizontal(right: Radius.circular(20)),
            child: SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.only(left: 16, top: 16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    const SizedBox(
                      height: 20,
                    ),
                    TextButton(
                      onPressed: () {
                        controller.setPage(0, context);
                      },
                      style: TextButton.styleFrom(
                        backgroundColor: controller.pageIndex == 0
                            ? OneColors.primaryDark.withOpacity(0.1)
                            : null,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Row(
                              children: const [
                                Icon(
                                  Icons.home,
                                  color: OneColors.primaryDark,
                                ),
                                SizedBox(
                                  width: 15.0,
                                ),
                                Text(
                                  'Home',
                                  style: TextStyle(
                                    fontFamily: OneStyles.fontFamilyPoppins,
                                    fontSize: 14.0,
                                    fontWeight: FontWeight.w500,
                                    letterSpacing: 0.3,
                                    color: OneColors.primaryDark,
                                  ),
                                ),
                              ],
                            ),
                            const Icon(
                              Icons.arrow_forward_ios,
                              color: OneColors.primaryDark,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    TextButton(
                      onPressed: () {
                        controller.setPage(1, context);
                      },
                      style: TextButton.styleFrom(
                        backgroundColor: controller.pageIndex == 1
                            ? OneColors.primaryDark.withOpacity(0.1)
                            : null,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Row(
                              children: const [
                                Icon(
                                  Icons.person,
                                  color: OneColors.primaryDark,
                                ),
                                SizedBox(
                                  width: 15.0,
                                ),
                                Text(
                                  'Perfil',
                                  style: TextStyle(
                                    fontFamily: OneStyles.fontFamilyPoppins,
                                    fontSize: 14.0,
                                    fontWeight: FontWeight.w500,
                                    letterSpacing: 0.3,
                                    color: OneColors.primaryDark,
                                  ),
                                ),
                              ],
                            ),
                            const Icon(
                              Icons.arrow_forward_ios,
                              color: OneColors.primaryDark,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    // TextButton(
                    //   onPressed: () {
                    //     controller.setPage(2);
                    //   },
                    //   style: TextButton.styleFrom(
                    //     backgroundColor: controller.pageIndex.value == 2
                    //         ? OneColors.primaryDark.withOpacity(0.1)
                    //         : null,
                    //     shape: RoundedRectangleBorder(
                    //       borderRadius: BorderRadius.circular(15.0),
                    //     ),
                    //   ),
                    //   child: Padding(
                    //     padding: const EdgeInsets.symmetric(vertical: 10.0),
                    //     child: Row(
                    //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //       mainAxisSize: MainAxisSize.max,
                    //       crossAxisAlignment: CrossAxisAlignment.center,
                    //       children: [
                    //         Row(
                    //           children: const [
                    //             Icon(
                    //               Icons.comment,
                    //               color: OneColors.primaryDark,
                    //             ),
                    //             SizedBox(
                    //               width: 15.0,
                    //             ),
                    //             Text(
                    //               'Ajuda',
                    //               style: TextStyle(
                    //                 fontFamily: OneStyles.fontFamilyPoppins,
                    //                 fontSize: 14.0,
                    //                 fontWeight: FontWeight.w500,
                    //                 letterSpacing: 0.3,
                    //                 color: OneColors.primaryDark,
                    //               ),
                    //             ),
                    //           ],
                    //         ),
                    //         const Icon(
                    //           Icons.arrow_forward_ios,
                    //           color: OneColors.primaryDark,
                    //         ),
                    //       ],
                    //     ),
                    //   ),
                    // ),
                    // const SizedBox(
                    //   height: 20,
                    // ),
                    TextButton(
                      onPressed: () {
                        controller.setPage(3, context);
                      },
                      style: TextButton.styleFrom(
                        backgroundColor: (controller.pageIndex == 2 ||
                                controller.pageIndex == 3)
                            ? OneColors.primaryDark.withOpacity(0.1)
                            : null,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Row(
                              children: const [
                                Icon(
                                  Icons.notifications_active,
                                  color: OneColors.primaryDark,
                                ),
                                SizedBox(
                                  width: 15.0,
                                ),
                                Text(
                                  'Notificações',
                                  style: TextStyle(
                                    fontFamily: OneStyles.fontFamilyPoppins,
                                    fontSize: 14.0,
                                    fontWeight: FontWeight.w500,
                                    letterSpacing: 0.3,
                                    color: OneColors.primaryDark,
                                  ),
                                ),
                              ],
                            ),
                            const Icon(
                              Icons.arrow_forward_ios,
                              color: OneColors.primaryDark,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Container(
                      height: 35,
                      width: double.maxFinite,
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: OutlinedButton(
                        onPressed: () {
                          controller.buttonSignOut();
                        },
                        style: OutlinedButton.styleFrom(
                          alignment: Alignment.center,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            FaIcon(
                              FontAwesomeIcons.rightFromBracket,
                              size: 16,
                            ),
                            SizedBox(
                              width: 15.0,
                            ),
                            Text(
                              'Sair',
                              style: TextStyle(
                                fontFamily: OneStyles.fontFamilyPoppins,
                                fontSize: 14.0,
                                fontWeight: FontWeight.w500,
                                letterSpacing: 0.3,
                                color: OneColors.primaryDark,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    // const SizedBox(
                    //   height: 22,
                    // ),
                    // Container(
                    //   height: 35,
                    //   width: double.maxFinite,
                    //   padding: const EdgeInsets.symmetric(horizontal: 8),
                    //   child: OutlinedButton(
                    //     onPressed: () {
                    //       controller.excludeAccount();
                    //     },
                    //     style: OutlinedButton.styleFrom(
                    //       foregroundColor: Colors.red.shade700,
                    //       alignment: Alignment.center,
                    //       shape: RoundedRectangleBorder(
                    //         borderRadius: BorderRadius.circular(10.0),
                    //       ),
                    //     ),
                    //     child: Row(
                    //       mainAxisAlignment: MainAxisAlignment.center,
                    //       children: [
                    //         FaIcon(
                    //           FontAwesomeIcons.circleExclamation,
                    //           size: 16,
                    //           color: Colors.red.shade700,
                    //         ),
                    //         const SizedBox(
                    //           width: 15.0,
                    //         ),
                    //         Text(
                    //           'Excluir Conta',
                    //           style: TextStyle(
                    //             fontFamily: OneStyles.fontFamilyPoppins,
                    //             fontSize: 14.0,
                    //             fontWeight: FontWeight.w500,
                    //             letterSpacing: 0.3,
                    //             color: Colors.red.shade700,
                    //           ),
                    //         ),
                    //       ],
                    //     ),
                    //   ),
                    // ),
                    const SizedBox(
                      height: 40.0,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      });
    }
    return GetBuilder<HomeController>(
      builder: (controller) {
        return BottomNavigationBar(
          selectedFontSize: 12,
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.white,
          unselectedItemColor: OneColors.accentMidle,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Perfil',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.comment),
              label: 'Ajuda',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.notifications_active),
              label: 'Notificações',
            ),
          ],
          currentIndex: controller.pageIndex,
          onTap: (idx) {
            if (idx == 2) {
              controller.launchWhatsapp('Olá,  preciso de suporte');
              return;
            } else if (idx == 3) {
              controller.setPage(2, context);
            }
            controller.setPage(idx, context);
          },
        );
      },
    );
  }
}
