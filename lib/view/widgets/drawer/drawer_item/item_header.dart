import 'package:flutter/material.dart';

class AndroidDrawerItemHeader extends StatelessWidget {
  final String name;
  final String email;

  const AndroidDrawerItemHeader({
    required this.name,
    required this.email,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return UserAccountsDrawerHeader(
      margin: EdgeInsets.zero,
      accountName: Text(
        name,
        style: const TextStyle(color: Colors.white),
      ),
      accountEmail: Text(email),
      currentAccountPicture: CircleAvatar(
        backgroundColor: Colors.white,
        child: CircleAvatar(
          backgroundColor: Colors.white,
          child: Icon(
            Icons.person,
            color: Theme.of(context).primaryColor,
          ),
        ),
      ),
    );
  }
}
