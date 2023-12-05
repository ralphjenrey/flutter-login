import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';

import '../provider/user_provider.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _currentPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  Future<void> changePassword() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    final response = await http.post(
      Uri.parse('http://192.168.1.8:80/flutter_login/changePassword.php'),
      body: {
        'username': userProvider.username,
        'currentPassword': _currentPasswordController.text,
        'newPassword': _newPasswordController.text,
        'confirmPassword': _confirmPasswordController.text,
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);

      Fluttertoast.showToast(
        msg: 'Message from server: ${data['message']}',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 2,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 16.0,
      );

      // Navigate back to AdminHomePage and set selected to true
      Navigator.pop(context);
    } else {
      Fluttertoast.showToast(
        msg: 'Server error: ${response.statusCode}',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 2,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a password';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Set selectedTileIndex before navigating back
        Provider.of<UserProvider>(context, listen: false).selectedTileIndex = 0;
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('Profile', style: GoogleFonts.poppins()),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: _currentPasswordController,
                  obscureText: true,
                  decoration: InputDecoration(labelText: 'Current Password', labelStyle: GoogleFonts.poppins()),
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: _newPasswordController,
                  obscureText: true,
                  decoration: InputDecoration(labelText: 'New Password', labelStyle: GoogleFonts.poppins()),
                  validator: _validatePassword,
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: _confirmPasswordController,
                  obscureText: true,
                  decoration: InputDecoration(labelText: 'Confirm Password', labelStyle: GoogleFonts.poppins()),
                  validator: _validatePassword,
                ),
                SizedBox(height: 16.0),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState?.validate() ?? false) {
                        changePassword();
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 16.0),
                    ),
                    child: Text('Change Password', style: GoogleFonts.poppins()),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}