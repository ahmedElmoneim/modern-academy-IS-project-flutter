import 'package:flutter/material.dart';
import 'package:modern_adacemy/providers/auth.dart';
import 'package:provider/provider.dart';

class NavigationSideDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final authData = Provider.of<Auth>(context);
    return Drawer(
      child: Column(
        children: [
          DrawerHeader(
            child: Center(
              child: Text('Modern Academy'),
            ),
          ),
          ListTile(
            title: Text('Project Team'),
            onTap: () {},
          ),
          Divider(),
          ListTile(
            title: Text('Logout'),
            onTap: () {
              Navigator.of(context).pop();
              authData.logoutUser();
            },
          ),
        ],
      ),
    );
  }
}
