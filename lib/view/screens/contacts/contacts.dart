import 'package:flutter/material.dart';
import 'package:groomzy/utils/constants.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../widgets/alert_dialog/alert_dialog.dart';

class Contact extends StatefulWidget {
  const Contact({Key? key}) : super(key: key);

  @override
  _ContactState createState() => _ContactState();
}

class _ContactState extends State<Contact> {
  String? errorMessage;

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context);

    if (errorMessage != null) {
      return AndroidAlertDialog(
        title: 'Error',
        message: Text(
          errorMessage!,
          style: const TextStyle(
            color: Colors.redAccent,
          ),
        ),
      );
    }

    return Column(
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
        SizedBox(height: mediaQuery.size.height * 0.02),
        Card(
          child: GestureDetector(
            child: ListTile(
              leading: const FaIcon(
                FontAwesomeIcons.whatsappSquare,
                color: Colors.lightGreen,
              ),
              title: const Text(
                '+27 67 135 0513',
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
              if (await canLaunch(
                  'https://api.whatsapp.com/send?phone=+27671350513')) {
                await launch(
                    'https://api.whatsapp.com/send?phone=+27671350513');
                setState(() {
                  errorMessage = null;
                });
              } else {
                setState(() {
                  errorMessage = 'Could not launch whatsapp';
                });
              }
            },
          ),
        ),
        const Divider(),
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
              if (await canLaunch('mailto:helpme@groomzy.co.za')) {
                await launch('mailto:helpme@groomzy.co.za');
                setState(() {
                  errorMessage = null;
                });
              } else {
                setState(() {
                  errorMessage = 'Could not launch mail';
                });
              }
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
              if (await canLaunch('https://instagram.com/groomzy_')) {
                await launch('https://instagram.com/groomzy_');
                setState(() {
                  errorMessage = null;
                });
              } else {
                setState(() {
                  errorMessage = 'Could not launch instagram';
                });
              }
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
              if (await canLaunch('https://twitter.com/groomzy_')) {
                await launch('https://twitter.com/groomzy_');
                setState(() {
                  errorMessage = null;
                });
              } else {
                setState(() {
                  errorMessage = 'Could not launch twitter';
                });
              }
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
              if (await canLaunch('https://facebook.com/groomzy')) {
                await launch('https://facebook.com/groomzy');
                setState(() {
                  errorMessage = null;
                });
              } else {
                setState(() {
                  errorMessage = 'Could not launch facebook';
                });
              }
            },
          ),
        ),
      ],
    );
  }
}
