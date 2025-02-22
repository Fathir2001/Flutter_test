import 'package:flutter/foundation.dart';
import '../models/user_model.dart';
import '../services/api_service.dart';
import '../services/database_helper.dart';

class UserProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();
  final DatabaseHelper _databaseHelper = DatabaseHelper();
  List<User> _users = [];
  bool _isLoading = false;
  String _error = '';

  List<User> get users => _users;
  bool get isLoading => _isLoading;
  String get error => _error;

  Future<void> fetchAndSaveUser() async {
    try {
      _isLoading = true;
      _error = '';
      notifyListeners();

      final user = await _apiService.fetchUser();
      await _databaseHelper.insertUser(user);
      await loadUsers();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadUsers({String? search}) async {
    try {
      _isLoading = true;
      notifyListeners();
      
      _users = await _databaseHelper.getUsers(search: search);
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}