import 'package:flutter/material.dart';
import 'package:groomzy/utils/constants.dart';
import 'package:groomzy/utils/utils.dart';
import 'package:groomzy/view/widgets/drawer/drawer.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../widgets/alert_dialog/alert_dialog.dart';

class Contact extends StatelessWidget {
  const Contact({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Future<void> launchUrl(String url) async {
      try {
        await launch(url);
      } catch (err) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AndroidAlertDialog(
              title: 'Oops!',
              message: Text(
                '$err',
              ),
            );
          },
        );
      }
    }

    Size mediaQuerySize = MediaQuery.of(context).size;
    Map currentDevice = Utils().currentDevice(context);

    return currentDevice['isDesktop']
        ? SizedBox(
            height: mediaQuerySize.height,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AndroidDrawer(),
                const VerticalDivider(),
                Expanded(
                    child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Column(
                    children: <Widget>[
                      Container(
                        height: 130,
                        decoration: const BoxDecoration(
                          color: Colors.white12,
                        ),
                        child: Image.asset(
                          logoImage,
                          fit: BoxFit.cover,
                          height: 80,
                        ),
                      ),
                      // Card(
                      //   child: GestureDetector(
                      //     child: ListTile(
                      //       leading: const FaIcon(
                      //         FontAwesomeIcons.whatsappSquare,
                      //         color: Colors.lightGreen,
                      //       ),
                      //       title: const Text(
                      //         '+27 67 135 0513',
                      //         style: TextStyle(
                      //           fontFamily: 'Arial',
                      //           fontStyle: FontStyle.italic,
                      //           fontWeight: FontWeight.bold,
                      //         ),
                      //       ),
                      //       trailing: Icon(
                      //         Icons.play_arrow,
                      //         color: Theme.of(context).primaryColor,
                      //       ),
                      //     ),
                      //     onTap: () async {
                      //       launchUrl('https://api.whatsapp.com/send?phone=+27671350513');
                      //     },
                      //   ),
                      // ),
                      // const Divider(),
                      SizedBox(
                        width: mediaQuerySize.width * 0.3,
                        child: Card(
                          child: GestureDetector(
                            child: ListTile(
                              leading: const Icon(
                                Icons.email,
                                color: Colors.redAccent,
                              ),
                              title: const Text(
                                'helpme@groomzy.co.za',
                                style: TextStyle(
                                  fontFamily: 'Arial',
                                  fontStyle: FontStyle.italic,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              trailing: Icon(
                                Icons.play_arrow,
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                            onTap: () async {
                              launchUrl('mailto:helpme@groomzy.co.za');
                            },
                          ),
                        ),
                      ),
                      const SizedBox(height: 10.0),
                      SizedBox(
                        width: mediaQuerySize.width * 0.3,
                        child: Card(
                          child: GestureDetector(
                            child: ListTile(
                              leading: const FaIcon(
                                FontAwesomeIcons.instagramSquare,
                                color: Colors.pinkAccent,
                              ),
                              title: const Text(
                                'groomzy_',
                                style: TextStyle(
                                  fontFamily: 'Arial',
                                  fontStyle: FontStyle.italic,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              trailing: Icon(
                                Icons.play_arrow,
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                            onTap: () async {
                              launchUrl('https://instagram.com/groomzy_');
                            },
                          ),
                        ),
                      ),
                      const SizedBox(height: 10.0),
                      SizedBox(
                        width: mediaQuerySize.width * 0.3,
                        child: Card(
                          child: GestureDetector(
                            child: ListTile(
                              leading: const Icon(
                                FontAwesomeIcons.twitterSquare,
                                color: Colors.lightBlueAccent,
                              ),
                              title: const Text(
                                '@groomzy_',
                                style: TextStyle(
                                  fontFamily: 'Arial',
                                  fontStyle: FontStyle.italic,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              trailing: Icon(
                                Icons.play_arrow,
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                            onTap: () async {
                              launchUrl('https://twitter.com/groomzy_');
                            },
                          ),
                        ),
                      ),
                      const SizedBox(height: 10.0),
                      SizedBox(
                        width: mediaQuerySize.width * 0.3,
                        child: Card(
                          child: GestureDetector(
                            child: ListTile(
                              leading: const FaIcon(
                                FontAwesomeIcons.facebookSquare,
                                color: Colors.blueAccent,
                              ),
                              title: const Text(
                                'Groomzy',
                                style: TextStyle(
                                  fontFamily: 'Arial',
                                  fontStyle: FontStyle.italic,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              trailing: Icon(
                                Icons.play_arrow,
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                            onTap: () async {
                              launchUrl('https://facebook.com/groomzy');
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ))
              ],
            ))
        : Column(
            children: <Widget>[
              Container(
                height: 80,
                decoration: const BoxDecoration(
                  color: Colors.white12,
                ),
                child: Image.asset(
                  logoImage,
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(height: mediaQuerySize.height * 0.02),
              // Card(
              //   child: GestureDetector(
              //     child: ListTile(
              //       leading: const FaIcon(
              //         FontAwesomeIcons.whatsappSquare,
              //         color: Colors.lightGreen,
              //       ),
              //       title: const Text(
              //         '+27 67 135 0513',
              //         style: TextStyle(
              //           fontFamily: 'Arial',
              //           fontStyle: FontStyle.italic,
              //           fontWeight: FontWeight.bold,
              //         ),
              //       ),
              //       trailing: Icon(
              //         Icons.play_arrow,
              //         color: Theme.of(context).primaryColor,
              //       ),
              //     ),
              //     onTap: () async {
              //       launchUrl('https://api.whatsapp.com/send?phone=+27671350513');
              //     },
              //   ),
              // ),
              // const Divider(),
              Card(
                child: GestureDetector(
                  child: ListTile(
                    leading: const Icon(
                      Icons.email,
                      color: Colors.redAccent,
                    ),
                    title: const Text(
                      'helpme@groomzy.co.za',
                      style: TextStyle(
                        fontFamily: 'Arial',
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    trailing: Icon(
                      Icons.play_arrow,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  onTap: () async {
                    launchUrl('mailto:helpme@groomzy.co.za');
                  },
                ),
              ),
              const Divider(),
              Card(
                child: GestureDetector(
                  child: ListTile(
                    leading: const FaIcon(
                      FontAwesomeIcons.instagramSquare,
                      color: Colors.pinkAccent,
                    ),
                    title: const Text(
                      'groomzy_',
                      style: TextStyle(
                        fontFamily: 'Arial',
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    trailing: Icon(
                      Icons.play_arrow,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  onTap: () async {
                    launchUrl('https://instagram.com/groomzy_');
                  },
                ),
              ),
              const Divider(),
              Card(
                child: GestureDetector(
                  child: ListTile(
                    leading: const Icon(
                      FontAwesomeIcons.twitterSquare,
                      color: Colors.lightBlueAccent,
                    ),
                    title: const Text(
                      '@groomzy_',
                      style: TextStyle(
                        fontFamily: 'Arial',
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    trailing: Icon(
                      Icons.play_arrow,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  onTap: () async {
                    launchUrl('https://twitter.com/groomzy_');
                  },
                ),
              ),
              const Divider(),
              Card(
                child: GestureDetector(
                  child: ListTile(
                    leading: const FaIcon(
                      FontAwesomeIcons.facebookSquare,
                      color: Colors.blueAccent,
                    ),
                    title: const Text(
                      'Groomzy',
                      style: TextStyle(
                        fontFamily: 'Arial',
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    trailing: Icon(
                      Icons.play_arrow,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  onTap: () async {
                    launchUrl('https://facebook.com/groomzy');
                  },
                ),
              ),
            ],
          );
  }
}
