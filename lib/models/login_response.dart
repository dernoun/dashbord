import 'package:equatable/equatable.dart';

class LoginResponse extends Equatable {
  final String token;
  final String id;
  final String name;

  const LoginResponse({
    required this.token,
    required this.id,
    required this.name,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    String id = '';
    String name = '';

    final clients = json['clients'];
    if (clients is List && clients.isNotEmpty) {
      final first = clients.first;
      if (first is Map<String, dynamic>) {
        id = first['id']?.toString() ?? '';
        name = first['name'] ?? '';
      }
    }

    return LoginResponse(
      token: json['token'] ?? '',
      id: id,
      name: name,
    );
  }

  @override
  List<Object?> get props => [token, id, name];
}
