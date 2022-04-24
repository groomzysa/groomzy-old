import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:groomzy/controller/globals_controller.dart';
import 'package:groomzy/utils/constants.dart';
import 'package:groomzy/utils/enums.dart';
import 'package:groomzy/utils/utils.dart';
import 'package:groomzy/view/screens/about/main.dart';
import 'package:groomzy/view/screens/contacts/main.dart';
import 'package:groomzy/view/screens/edit_profile/main.dart';
import 'package:groomzy/view/screens/explorer/main.dart';
import 'package:groomzy/view/screens/signin/main.dart';
import 'package:groomzy/view/screens/signup/main.dart';
import 'package:groomzy/view/screens/ts_and_cs/main.dart';
import 'package:groomzy/view/widgets/drawer/drawer_item/item.dart';
import 'package:groomzy/view/widgets/drawer/drawer_item/item_header.dart';
import 'package:groomzy/view/widgets/drawer/styles.dart';

class AndroidDrawer extends StatelessWidget {
  AndroidDrawer({Key? key}) : super(key: key);
  final GlobalsController globalsController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      Map? user = globalsController.user;
      return Utils().currentDevice(context)['isDesktop']!
          ? SizedBox(
              width: MediaQuery.of(context).size.width * 0.2,
              height: MediaQuery.of(context).size.height,
              child: Column(
                children: <Widget>[
                  if (user.isNotEmpty && user['fullName'] != null)
                    AndroidDrawerItemHeader(
                      name: user['fullName'],
                      email: user['email']!,
                    ),
                  if (user.isEmpty)
                    const SizedBox(
                      height: 130,
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: Padding(
                          padding: EdgeInsets.all(20.0),
                          child: Text(
                            'Menu',
                            style: TextStyle(
                                fontSize: 20.0, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.7,
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          AndroidDrawerItem(
                            icon: Icons.home_outlined,
                            title: homeTitle,
                            navigateTo: Utils().navigateToHome(
                                user.isNotEmpty ? user['role'] ?? '' : ''),
                            navigateType: NavigatorNamedType.popAndPush,
                          ),
                          AndroidDrawerItem(
                            icon: Icons.info_outline,
                            title: aboutTitle,
                            navigateTo: AboutScreen.routeName,
                            navigateType: NavigatorNamedType.popAndPush,
                          ),
                          AndroidDrawerItem(
                            icon: Icons.contact_page_outlined,
                            title: contactTitle,
                            navigateTo: ContactScreen.routeName,
                            navigateType: NavigatorNamedType.popAndPush,
                          ),
                          const Divider(),
                          if (user.isNotEmpty)
                            AndroidDrawerItem(
                              icon: Icons.edit_outlined,
                              title: 'Edit profile',
                              navigateTo: EditProfileScreen.routeName,
                              navigateType: NavigatorNamedType.popAndPush,
                            ),
                          if (user.isEmpty)
                            AndroidDrawerItem(
                              icon: Icons.login_outlined,
                              title: signInTitle,
                              navigateTo: SignInScreen.routeName,
                              navigateType: NavigatorNamedType.popAndPush,
                            ),
                          if (user.isEmpty)
                            AndroidDrawerItem(
                              icon: Icons.person_add_outlined,
                              title: signupTitle,
                              navigateTo: SignUpScreen.routeName,
                              navigateType: NavigatorNamedType.popAndPush,
                            ),
                          if (user.isNotEmpty)
                            AndroidDrawerItem(
                              icon: Icons.logout_outlined,
                              title: signOutTitle,
                              navigateTo: ExploreScreen.routeName,
                            ),
                          const Divider(),
                          AndroidDrawerItem(
                            icon: Icons.policy_outlined,
                            title: tsAndCsTitle,
                            navigateTo: TsAndCsScreen.routeName,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomLeft,
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        children: <Widget>[
                          Align(
                            alignment: Alignment.bottomLeft,
                            child: Text(
                              'Copyright © 2020 Groomzy (Pty, Ltd)',
                              style: DrawerStyles().footerTextStyle,
                            ),
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.02,
                          ),
                          Align(
                            alignment: Alignment.bottomLeft,
                            child: Text('v0.0.1',
                                style: DrawerStyles().footerTextStyle),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            )
          : Drawer(
              child: SizedBox(
                height: MediaQuery.of(context).size.height,
                child: Column(
                  children: <Widget>[
                    AndroidDrawerItemHeader(
                      name: user.isNotEmpty && user['fullName'] != null
                          ? user['fullName']
                          : 'Groomzy',
                      email: user.isNotEmpty && user['email'] != null
                          ? user['email']!
                          : 'info@groomzy.co.za',
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            AndroidDrawerItem(
                              icon: Icons.home_outlined,
                              title: homeTitle,
                              navigateTo: Utils().navigateToHome(
                                  user.isNotEmpty ? user['role'] ?? '' : ''),
                              navigateType: NavigatorNamedType.popAndPush,
                            ),
                            AndroidDrawerItem(
                              icon: Icons.info_outline,
                              title: aboutTitle,
                              navigateTo: AboutScreen.routeName,
                              navigateType: NavigatorNamedType.popAndPush,
                            ),
                            AndroidDrawerItem(
                              icon: Icons.contact_page_outlined,
                              title: contactTitle,
                              navigateTo: ContactScreen.routeName,
                              navigateType: NavigatorNamedType.popAndPush,
                            ),
                            const Divider(),
                            if (user.isNotEmpty)
                              AndroidDrawerItem(
                                icon: Icons.edit_outlined,
                                title: 'Edit profile',
                                navigateTo: EditProfileScreen.routeName,
                                navigateType: NavigatorNamedType.popAndPush,
                              ),
                            if (user.isEmpty)
                              AndroidDrawerItem(
                                icon: Icons.login_outlined,
                                title: signInTitle,
                                navigateTo: SignInScreen.routeName,
                                navigateType: NavigatorNamedType.popAndPush,
                              ),
                            if (user.isEmpty)
                              AndroidDrawerItem(
                                icon: Icons.person_add_outlined,
                                title: signupTitle,
                                navigateTo: SignUpScreen.routeName,
                                navigateType: NavigatorNamedType.popAndPush,
                              ),
                            if (user.isNotEmpty)
                              AndroidDrawerItem(
                                icon: Icons.logout_outlined,
                                title: signOutTitle,
                                navigateTo: ExploreScreen.routeName,
                              ),
                            const Divider(),
                            AndroidDrawerItem(
                              icon: Icons.policy_outlined,
                              title: tsAndCsTitle,
                              navigateTo: TsAndCsScreen.routeName,
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        children: <Widget>[
                          Align(
                            alignment: Alignment.bottomLeft,
                            child: Text(
                              'Copyright © 2020 Groomzy (Pty, Ltd)',
                              style: DrawerStyles().footerTextStyle,
                            ),
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.02,
                          ),
                          Align(
                            alignment: Alignment.bottomLeft,
                            child: Text('v0.0.1',
                                style: DrawerStyles().footerTextStyle),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
    });
  }
}
