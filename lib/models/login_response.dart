import 'package:equatable/equatable.dart';

class LoginResponse extends Equatable {

  const LoginResponse({
    required this.token,
    required this.clients,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    final Map<String, String> clientsMap = <String, String>{};
    final clientsRaw = json['clients'];
    for (var value in clientsRaw) {
      if (value is Map<String, String>) {
        value.forEach((String key, String val) {
          clientsMap[key] = val;
        });
      }
    }

    return LoginResponse(
      token: json['token'] ?? '',
      clients: clientsMap,
    );
  }
  final String token;
  final Map<String, String> clients;

  @override
  List<Object?> get props => <Object?>[token, clients];
}
