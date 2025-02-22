import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../services/api_service.dart';
import '../database/database_helper.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<UserModel> users = [];
  List<UserModel> savedUsers = [];
  final dbHelper = DatabaseHelper();
  TextEditingController searchController = TextEditingController();

  void searchUsers(String query) async {
    final allUsers = await dbHelper.getUsers();
    final filteredUsers = allUsers
        .where((user) =>
            user.fullName.toLowerCase().contains(query.toLowerCase()) ||
            user.city.toLowerCase().contains(query.toLowerCase()))
        .toList();
    setState(() {
      users = filteredUsers;
    });
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () => fetchSavedUsers());
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  Future<void> fetchSavedUsers() async {
    final users = await dbHelper.getUsers(); // Fetch saved users
    setState(() {
      savedUsers = users;
    });

    print("Saved Users Count: ${savedUsers.length}"); // Debug log
  }

  Future<void> fetchNewUser() async {
  final newUser = await ApiService.fetchUser(); // Fetch new user
  if (newUser != null) {
    await dbHelper.insertUser(newUser);
    fetchSavedUsers(); // Refresh UI
  } else {
    print("No user fetched from API");
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Users List"),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(50),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: "Search by name or city...",
                border: OutlineInputBorder(),
                filled: true,
                fillColor: Colors.white,
                prefixIcon: Icon(Icons.search),
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              ),
              onChanged: searchUsers,
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: fetchNewUser,
        child: Icon(Icons.refresh),
      ),
      body: users.isEmpty
          ? Center(child: Text("No saved users"))
          : ListView.builder(
              itemCount: users.length,
              itemBuilder: (context, index) {
                final user = users[index];
                return ListTile(
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(user.profileImage),
                  ),
                  title: Text(user.fullName),
                  subtitle: Text(user.city),
                  trailing: Text(user.phone),
                );
              },
            ),
    );
  }
}
