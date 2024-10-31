// repositories/auth_repository.dart
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_app/services/api_service.dart';

class AuthRepository {
  final ApiService _apiService;

  AuthRepository(this._apiService);

  Future<String> login(String email, String password) async {
    try {
      final response = await _apiService.login(email, password);
      final token = response['token'];
      final userId = response['user']['_id'];
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('authToken', token);
      await prefs.setBool('isLoggedIn', true);
      await prefs.setString('userId', userId);
      // print(token);
      return token;
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<void> signup(String name, String email, String password) async {
    try {
      await _apiService.signup(name, email, password);
    } catch (e) {
      print("Error in signup");
      throw Exception(e);
    }
  }

  Future<Map<String, dynamic>> fetchUserProfile(String userId) async {
    try {
      final profileData = await _apiService.fetchUserProfile(userId);
      return profileData;
    } catch (e) {
      throw Exception('Error fetching user profile: $e');
    }
  }

  // Logout
  Future<void> logout() async {
    try {
      await _apiService.logout();
    } catch (e) {
      throw Exception('Error logging out: $e');
    }
  }

  Future<void> changePassword(String userId, String password) async {
    try {
      await _apiService.changePassword(userId, password);
    } catch (e) {
      throw Exception('Error logging out: $e');
    }
  }
}
