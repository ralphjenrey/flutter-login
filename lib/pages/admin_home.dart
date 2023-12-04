import 'package:flutter/material.dart';
import '../widgets/admin_drawer.dart';

class AdminHomePage extends StatelessWidget {
  const AdminHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Home Page'),
      ),
      drawer: const AdminDrawer(), // Use the AdminDrawer widget here
      body: const Center(
        child: Text('Admin Home Page Content'),
      ),
    );
  }
}
