import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import '../provider/user_provider.dart';
import 'register_page.dart';
import 'admin_home.dart'; // Import the AdminHomePage
import 'package:google_fonts/google_fonts.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool isPasswordVisible = false;
  Future<void> _login() async {
    const String url =
        'http://192.168.1.8:80/flutter_login/loginProcess.php'; // Replace with your actual backend URL

    try {
      final response = await http.post(
        Uri.parse(url),
        body: {
          'username': usernameController.text,
          'password': passwordController.text,
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);

        if (data['status'] == 'success') {
          // Login successful
          print('Login successful');
          showToast('Login successful', Colors.green);

          // Set the user in the session
          Provider.of<UserProvider>(context, listen: false).setUser(usernameController.text);

          // Navigate to AdminHomePage on successful login
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AdminHomePage()),
          );
        } else {
          // Login failed, display an error message
          print('Login failed: ${data['message']}');
          showToast('Login failed: ${data['message']}', Colors.red);
        }
      } else {
        // Handle errors from the server
        print('Server error: ${response.statusCode}');
        showToast('Server error: ${response.statusCode}', Colors.red);
      }
    } catch (e) {
      // Handle network or other errors
      print('Error: $e');
      showToast('Error: $e', Colors.red);
    }
  }

  void showToast(String message, Color backgroundColor) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 2,
      backgroundColor: backgroundColor,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
             Center(
              child: Text(
                'Login',
                style: GoogleFonts.poppins(
                  fontSize: 30,
                ),
              ),
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: usernameController,
              decoration:  InputDecoration(
                labelText: 'Username',
                labelStyle: GoogleFonts.poppins(),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
              ),
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: passwordController,
              obscureText: !isPasswordVisible,
              decoration:  InputDecoration(
                labelText: 'Password',
                labelStyle: GoogleFonts.poppins(),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                suffixIcon: IconButton(
                  icon: Icon(
                    isPasswordVisible
                        ? Icons.visibility
                        : Icons.visibility_off,
                    color: Colors.black54,
                  ),
                  onPressed: () {
                    setState(() {
                      isPasswordVisible = !isPasswordVisible;
                    });
                  },
                ),
              ),
            ),
            const SizedBox(height: 16.0),
            TextButton(
              onPressed: () {
                // Navigate to the register page
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const RegisterPage()),
                );
              },
              child: Text(
                'No account yet? Tap to register.',
                style: GoogleFonts.poppins(
                  fontSize: 14.0,
                  color: Colors.blueAccent, // Set the text color to blue
                ),
              ),
            ),
            const SizedBox(height: 16.0),
            SizedBox(
              width: double.infinity, // Make the button full width
              child: ElevatedButton(
                onPressed: _login,
                style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 16.0),
                  backgroundColor: Colors.blue// Set the background color to blue
                ),
                child: Text('Login',
                  style: GoogleFonts.poppins(
                      fontSize: 18.0,
                      color: Colors.white,
                  ),
                ),

              ),
            ),
          ],
        ),
      ),
    );
  }
}
