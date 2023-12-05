import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

import '../widgets/admin_drawer.dart';

class AdminHomePage extends StatefulWidget {
  const AdminHomePage({Key? key}) : super(key: key);

  @override
  _AdminHomePageState createState() => _AdminHomePageState();
}

class _AdminHomePageState extends State<AdminHomePage> with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;
  int numberOfAccounts = 0; // Initialize with 0

  @override
  void initState() {
    super.initState();
    // Fetch the number of registered accounts

    _animationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );

    // Trigger the animation from 1 to the maximum value
    _animationController.forward(from: 0);

    fetchNumberOfAccounts();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> fetchNumberOfAccounts() async {
    try {
      final response = await http.get(
        Uri.parse('http://192.168.1.8:80/flutter_login/count_users.php'),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);

        setState(() {
          numberOfAccounts = data['count'];
        });
        print(numberOfAccounts);
      } else {
        // Handle errors from the server
        print('Server error: ${response.statusCode}');
      }
    } catch (e) {
      // Handle network or other errors
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text(
          'Admin Panel',
          style: GoogleFonts.poppins(
            color: Colors.white,
          ),
        ),
      ),
      drawer: const AdminDrawer(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 200,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                children: [
                  Text(
                    'Registered Accounts',
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 30,
                    ),
                  ),
                  SizedBox(height: 8),
                  TweenAnimationBuilder(
                    tween: Tween<double>(begin: 1, end: numberOfAccounts.toDouble()),
                    duration: const Duration(seconds: 2),
                    builder: (context, double value, child) {
                      return Text(
                        value.toInt().toString(),
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 60,
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
