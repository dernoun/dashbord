import 'package:equatable/equatable.dart';

class LoginResponse extends Equatable {
  final String token;
  final Map<String, String> clients;

  const LoginResponse({
    required this.token,
    required this.clients,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    final Map<String, String> clientsMap = {};
    final clientsRaw = json['clients'];
    for (var value in clientsRaw) {
      if (value is Map<String, String>) {
        value.forEach((key, val) {
          clientsMap[key] = val;
        });
      }
    }

    return LoginResponse(
      token: json['token'] ?? '',
      clients: clientsMap,
    );
  }

  @override
  List<Object?> get props => [token, clients];
}
