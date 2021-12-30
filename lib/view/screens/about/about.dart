import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:groomzy/utils/constants.dart';

class About extends StatelessWidget {
  const About({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          decoration: const BoxDecoration(
            color: Colors.white12,
          ),
          child: Image.asset(
            logoImage,
            fit: BoxFit.cover,
            height: 80,
          ),
        ),
        Column(
          children: const [
            Padding(
              padding: EdgeInsets.all(5.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Background',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    color: Colors.blueGrey,
                    fontWeight: FontWeight.bold,
                    fontSize: 20.0,
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(10.0),
              child: AutoSizeText(
                'Groomzy is a concept that was born in times of the '
                    '2020 COVID 19 Global pandemic in response to offer '
                    'convenient, transparent, flexible and reliable '
                    'business operations platform for the beauty grooming industry.',
                style: TextStyle(fontSize: 16.0),
              ),
            ),
          ],
        ),
        const Divider(),
        Column(
          children: [
            const Padding(
              padding: EdgeInsets.all(5.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'About',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    color: Colors.blueGrey,
                    fontWeight: FontWeight.bold,
                    fontSize: 20.0,
                  ),
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(10.0),
              child: AutoSizeText(
                'Groomzy is a beauty grooming industry booking '
                    'platform where service '
                    'providers offer their services and the clients make '
                    'bookings for these services. \n\nBoth users '
                    '(clients and service providers) can download the app '
                    'to find service providers in their location.\n\n'
                    'It is an Any time, Anywhere platform that has an '
                    'in-house booking feature, and makes scheduling and '
                    'managing bookings much easier.',
                style: TextStyle(fontSize: 16.0),
              ),
            ),
            const Divider(),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                children: const [
                  ListTile(
                    contentPadding: EdgeInsets.only(left: 5.0),
                    leading: Icon(Icons.arrow_forward),
                    title: Text(
                      'No more waiting for 9am to call and book your '
                          'appointment.',
                      style: TextStyle(
                        fontSize: 16.0,
                        color: Colors.black54,
                      ),
                    ),
                  ),
                  ListTile(
                    contentPadding: EdgeInsets.only(left: 5.0),
                    leading: Icon(Icons.arrow_forward),
                    title: Text(
                      'No more engaged phones.',
                      style: TextStyle(
                        fontSize: 16.0,
                        color: Colors.black54,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(10.0),
              child: AutoSizeText(
                'To get started, download groomzy application platform'
                    ', select service type, search for a service '
                    'provider, choose a service and make a booking within '
                    'your area.\n\n'
                    'Booking is easy, convenient and instant.',
                style: TextStyle(
                  fontSize: 16.0,
                ),
              ),
            ),
          ],
        ),
        const Divider(),
        Column(
          children: [
            const Padding(
              padding: EdgeInsets.all(5.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Values and Missions',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    color: Colors.blueGrey,
                    fontWeight: FontWeight.bold,
                    fontSize: 20.0,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                children: const [
                  ListTile(
                    contentPadding: EdgeInsets.only(left: 5.0),
                    leading: Icon(Icons.arrow_forward),
                    title: Text(
                      'Convenience',
                    ),
                    subtitle: Text(
                      'We promise to offer easy, convenient and '
                          'instant booking.',
                    ),
                  ),
                  ListTile(
                    contentPadding: EdgeInsets.only(left: 5.0),
                    leading: Icon(Icons.arrow_forward),
                    title: Text(
                      'Transparency',
                    ),
                    subtitle: Text(
                      'We promise to always put Groomzy clients’s '
                          'interests first.',
                    ),
                  ),
                  ListTile(
                    contentPadding: EdgeInsets.only(left: 5.0),
                    leading: Icon(Icons.arrow_forward),
                    title: Text(
                      'Flexibility',
                    ),
                    subtitle: Text(
                      'We promise to provide flexible and reliable '
                          'service.',
                    ),
                  ),
                  ListTile(
                    contentPadding: EdgeInsets.only(left: 5.0),
                    leading: Icon(Icons.arrow_forward),
                    title: Text(
                      'Reliability',
                    ),
                    subtitle: Text(
                      'To build trust and confidence between Groomzy '
                          'and clients by offering excellent and reliable '
                          'service.',
                    ),
                  ),
                ],
              ),
            ),
          ],
        )
      ],
    );
  }
}
