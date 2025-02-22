import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/user_model.dart';

class ApiService {
  static const String apiUrl = "https://randomuser.me/api/";

  static Future<UserModel?> fetchUser() async {
    try {
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return UserModel.fromJson(data['results'][0]);
      } else {
        throw Exception("Failed to load user");
      }
    } catch (e) {
      print("Error: $e");
      return null;
    }
  }
}
