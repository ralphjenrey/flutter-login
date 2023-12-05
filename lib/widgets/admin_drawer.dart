import 'package:flutter/material.dart';
import 'package:flutter_login/pages/admin_home.dart';
import 'package:provider/provider.dart';
import '../pages/about.dart';
import '../pages/list_of_users.dart';
import '../pages/login_page.dart';
import '../provider/user_provider.dart';
import '../pages/profile.dart';

class AdminDrawer extends StatelessWidget {
  const AdminDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          Container(
            height: 140, // Set the height of the DrawerHeader
            child: DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Admin Panel',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Welcome, ${userProvider.username}',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          ),
          buildListTile(
            icon: Icons.home,
            title: 'Home',
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AdminHomePage()),
              );
              userProvider.selectedTileIndex = 0; // Set the index of the tapped tile
            },
            selected: userProvider.selectedTileIndex == 0,
            selectedTileColor: Colors.blue,
          ),
          buildListTile(
            icon: Icons.person,
            title: 'Accounts',
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ListofUsers()),
              );
              userProvider.selectedTileIndex = 1; // Set the index of the tapped tile
            },
            selected: userProvider.selectedTileIndex == 1,
            selectedTileColor: Colors.blue,
          ),
          buildListTile(
            icon: Icons.account_circle,
            title: 'Profile',
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ProfilePage()), // Link to the ProfilePage
              );
              userProvider.selectedTileIndex = 2; // Set the index of the tapped tile
            },
            selected: userProvider.selectedTileIndex == 2,
            selectedTileColor: Colors.blue,
          ),
          buildListTile(
            icon: Icons.info,
            title: 'About',
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AboutPage()), // Link to the AboutPage
              );
              userProvider.selectedTileIndex = 3; // Set the index of the tapped tile
            },
            selected: userProvider.selectedTileIndex == 3,
            selectedTileColor: Colors.blue,
          ),
          buildListTile(
            icon: Icons.logout,
            title: 'Logout',
            onTap: () {
              Provider.of<UserProvider>(context, listen: false).clearUser();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const LoginPage()),
              );
            },
            selected: false,
            selectedTileColor: Colors.grey,
          ),
        ],
      ),
    );
  }

  Card buildListTile({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    required bool selected,
    required Color selectedTileColor,
  }) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      color: selected ? selectedTileColor : null,
      child: ListTile(
        leading: Icon(icon),
        title: Text(
          title,
          style: TextStyle(
            color: selected ? Colors.white : Colors.black,
          ),
        ),
        onTap: onTap,
      ),
    );
  }
}
