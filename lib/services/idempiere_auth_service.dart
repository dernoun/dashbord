import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';

import '../models/login_response.dart';

class IdempiereDatabaseException implements Exception {
  final String message;
  IdempiereDatabaseException(this.message);
}

class IdempiereAuthService {
  final String baseUrl = 'https://test.idempiere.org:443/api/v1';

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
            const Duration(seconds: 30),
            onTimeout: () {
              throw IdempiereDatabaseException('Connection timeout');
            },
          );

      log('Login Response Status: ${response.statusCode}');
      log('Login Response Body: ${response.data}');

      if (response.statusCode == 200) {
        final jsonResponse = response.data is String ? jsonDecode(response.data) : response.data;
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
}
