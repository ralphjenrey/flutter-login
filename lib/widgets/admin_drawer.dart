import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../pages/list_of_users.dart';
import '../pages/login_page.dart';
import '../provider/user_provider.dart'; // Import the ListofUsers widget

class AdminDrawer extends StatelessWidget {
  const AdminDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
            child: Text(
              'Admin Drawer',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
          ),
          ListTile(
            leading: Icon(Icons.home),
            title: const Text('Home'),
            onTap: () {
              // Handle navigation for home
              Navigator.pop(context); // Close the drawer
            },
          ),
          ListTile(
            leading: Icon(Icons.person),
            title: const Text('Accounts'),
            onTap: () {
              // Handle navigation for accounts
              Navigator.pop(context); // Close the drawer
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        ListofUsers()), // Navigate to ListofUsers
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.account_circle),
            title: const Text('Profile'),
            onTap: () {
              // Handle navigation for profile
              Navigator.pop(context); // Close the drawer
            },
          ),
          ListTile(
            leading: Icon(Icons.logout),
            title: const Text('Logout'),
            onTap: () {
              // Handle logout
              // Clear the user session and navigate to the login page
              Provider.of<UserProvider>(context, listen: false).clearUser();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const LoginPage()),
              );
            },
          ),
        ],
      ),
    );
  }
}
