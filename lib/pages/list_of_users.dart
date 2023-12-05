import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import '../provider/user_provider.dart';

class ListofUsers extends StatefulWidget {
  const ListofUsers({Key? key}) : super(key: key);

  @override
  _ListofUsersState createState() => _ListofUsersState();
}

class _ListofUsersState extends State<ListofUsers> {
  List<Map<String, dynamic>> users = [];
  Set<int> editingRows = Set<int>();
  late List<TextEditingController> usernameControllers;
  late List<TextEditingController> emailControllers;

  @override
  void initState() {
    super.initState();
    _fetchUsers();
  }

  Future<void> _fetchUsers() async {
    const String url =
        'http://192.168.1.8:80/flutter_login/fetch_users.php'; // Replace with your actual backend URL

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final List<Map<String, dynamic>> userList =
        List<Map<String, dynamic>>.from(json.decode(response.body));
        setState(() {
          users = userList;
          usernameControllers = List.generate(
            users.length,
                (index) => TextEditingController(text: users[index]['username']),
          );
          emailControllers = List.generate(
            users.length,
                (index) => TextEditingController(text: users[index]['email']),
          );
        });
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
    return WillPopScope(
      onWillPop: () async {
        // Set selectedTileIndex before navigating back
        Provider.of<UserProvider>(context, listen: false).selectedTileIndex = 0;
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('List of Users'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              columns: const [
                DataColumn(label: Text('ID')),
                DataColumn(label: Text('Username')),
                DataColumn(label: Text('Email')),
                DataColumn(label: Text('Actions')),
              ],
              rows: users
                  .asMap()
                  .entries
                  .map(
                    (entry) => DataRow(
                  cells: [
                    DataCell(Text(entry.value['id'].toString())),
                    DataCell(
                      _buildEditableCell(
                        entry.key,
                        'username',
                        entry.value['username'],
                        usernameControllers[entry.key],
                      ),
                    ),
                    DataCell(
                      _buildEditableCell(
                        entry.key,
                        'email',
                        entry.value['email'],
                        emailControllers[entry.key],
                      ),
                    ),
                    DataCell(
                      Row(
                        children: [
                          IconButton(
                            icon: editingRows.contains(entry.key)
                                ? const Icon(Icons.check)
                                : const Icon(Icons.edit),
                            onPressed: () {
                              _toggleEdit(entry.key);
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () {
                              _deleteUser(users[entry.key]['id']);
                            },
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              )
                  .toList(),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEditableCell(
      int index,
      String field,
      String value,
      TextEditingController controller,
      ) {
    return editingRows.contains(index)
        ? TextFormField(
      controller: controller,
    )
        : Text(value);
  }

  void _toggleEdit(int index) {
    setState(() {
      if (editingRows.contains(index)) {
        // Save changes
        _saveUserChanges(index);
      }
      editingRows.toggle(index);
    });
  }

  void _saveUserChanges(int index) async {
    try {
      final userId = users[index]['id'];
      final newUsername = usernameControllers[index].text;
      final newEmail = emailControllers[index].text;

      // Construct the URL for crudUsers.php or your endpoint
      const String url = 'http://192.168.1.8:80/flutter_login/crudUsers.php';

      // Send the updated user information to the server
      final response = await http.post(
        Uri.parse(url),
        body: {
          'id': userId.toString(),
          'username': newUsername,
          'email': newEmail,
        },
      );

      if (response.statusCode == 200) {
        print('Changes saved successfully for user with ID: $userId');
        // Optionally, you can update the local state or fetch the updated user list
        _fetchUsers();
      } else {
        print('Failed to save changes for user with ID: $userId');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  void _deleteUser(int userId) async {
    try {
      // Construct the URL for delete_users.php or your endpoint
      const String url = 'http://192.168.1.8:80/flutter_login/delete_users.php';

      // Send the user ID to be deleted to the server
      final response = await http.post(
        Uri.parse(url),
        body: {'id': userId.toString()},
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);

        if (data['status'] == 'success') {
          // Deletion successful
          print('User with ID $userId deleted successfully');
          // Optionally, you can update the local state or fetch the updated user list
          _fetchUsers();
        } else {
          // Deletion failed, display an error message
          print('Failed to delete user with ID $userId: ${data['message']}');
        }
      } else {
        // Handle errors from the server
        print('Server error: ${response.statusCode}');
      }
    } catch (e) {
      // Handle network or other errors
      print('Error: $e');
    }
  }
}

extension SetExtension<T> on Set<T> {
  void toggle(T element) {
    if (contains(element)) {
      remove(element);
    } else {
      add(element);
    }
  }
}
