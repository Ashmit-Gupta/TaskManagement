import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:task_management_app/common/constants.dart';
import 'package:task_management_app/models/error_model.dart';
import 'package:task_management_app/models/user_model.dart';
import 'package:task_management_app/repository/shared_pref_repository.dart';

class AuthRepository {
  final SharedPrefStorage sharedPrefStorage;
  final Logger _logger = Logger();

  AuthRepository({required this.sharedPrefStorage});

  Future<ErrorModel> register(String name, String email, String pwd) async {
    final userModel = UserModel(password: pwd, email: email, name: name);
    _logger.i("Registering user: ${userModel.email}");

    try {
      final response = await http.post(
        Uri.parse('$kHost/register'),
        headers: {'Content-Type': 'application/json;charset=UTF-8'},
        body: jsonEncode(userModel.toJson()), // Ensure proper JSON encoding
      );

      return _handleResponse(response);
    } catch (e) {
      _logger.e("Register Error: $e");
      return ErrorModel(error: "Network error. Please try again.", data: null);
    }
  }

  Future<ErrorModel> login(String email, String pwd) async {
    final userModel = UserModel(password: pwd, email: email, name: "");
    _logger.i("Logging in user: ${userModel.email}");

    try {
      final response = await http.post(
        Uri.parse('$kHost/login'),
        headers: {'Content-Type': 'application/json;charset=UTF-8'},
        body: jsonEncode(userModel.toJson()),
      );

      final errorModel = _handleResponse(response);
      if (errorModel.data != null) {
        sharedPrefStorage.setData(
          errorModel.data['token'],
          errorModel.data['name'],
          errorModel.data['email'],
        );
      }

      return errorModel;
    } catch (e) {
      _logger.e("Login Error: $e");
      return ErrorModel(error: "Network error. Please try again.", data: null);
    }
  }

  Future<void> logout() async {
    _logger.i("Logging out user");
    await sharedPrefStorage.removeToken();
  }

  // Extracted response handler to avoid repetition
  ErrorModel _handleResponse(http.Response response) {
    final Map<String, dynamic> data = jsonDecode(response.body);
    switch (response.statusCode) {
      case 200:
        return ErrorModel(error: null, data: data);
      case 401:
        return ErrorModel(error: "Unauthorized access", data: null);
      case 500:
        return ErrorModel(error: "Server error. Please try again later.", data: null);
      default:
        return ErrorModel(error: data['message'] ?? "Unknown error", data: null);
    }
  }
}
