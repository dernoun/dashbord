import 'dart:convert';
import 'dart:developer';

import 'package:dashbord/config/app_config.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:dashbord/models/login_response.dart';

class IdempiereDatabaseException implements Exception {
  final String message;
  IdempiereDatabaseException(this.message);
}

class IdempiereAuthService {
  final String baseUrl = AppConfig.baseUrl;
  final int timeoutSeconds = AppConfig.timeoutSeconds;
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();
  static const String _tokenKey = 'auth_token';

  Future<LoginResponse> login(String username, String password) async {
    try {
      final dio = Dio();
      final response = await dio
          .post(
            '$baseUrl/auth/tokens',
            options: Options(headers: {'Content-Type': 'application/json'}),
            data: {'userName': username, 'password': password},
          )
          .timeout(
            Duration(seconds: timeoutSeconds),
            onTimeout: () {
              throw IdempiereDatabaseException('Connection timeout');
            },
          );

      log('Login Response Status: ${response.statusCode}');
      log('Login Response Body: ${response.data}');

      if (response.statusCode == 200) {
        final jsonResponse = response.data is String ? jsonDecode(response.data) : response.data;

        // store token securely
        final tokenValue = jsonResponse['token']?.toString();
        if (tokenValue != null && tokenValue.isNotEmpty) {
          try {
            await _secureStorage.write(key: _tokenKey, value: tokenValue);
          } catch (e) {
            log('Failed to write token to secure storage: $e');
            // proceed without failing login — app can still use returned LoginResponse
          }
        }

        return LoginResponse.fromJson(jsonResponse);
      } else if (response.statusCode == 401) {
        throw IdempiereDatabaseException('Invalid username or password');
      } else {
        throw IdempiereDatabaseException(
          'Login failed with status code ${response.statusCode}',
        );
      }
    } on IdempiereDatabaseException {
      rethrow;
    } catch (e) {
      log('Login error: $e');
      throw IdempiereDatabaseException('An error occurred: $e');
    }
  }

  /// Read stored token from secure storage
  Future<String?> getStoredToken() async {
    try {
      return await _secureStorage.read(key: _tokenKey);
    } catch (e) {
      log('Failed to read token from secure storage: $e');
      return null;
    }
  }

  /// Delete stored token (logout)
  Future<void> deleteStoredToken() async {
    try {
      await _secureStorage.delete(key: _tokenKey);
    } catch (e) {
      log('Failed to delete token from secure storage: $e');
    }
  }
}
