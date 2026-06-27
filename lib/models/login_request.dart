import 'package:equatable/equatable.dart';

class LoginRequest extends Equatable {

  const LoginRequest({
    required this.username,
    required this.password,
  });
  final String username;
  final String password;

  @override
  List<Object?> get props => <Object?>[username, password];
}
