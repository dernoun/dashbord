import 'package:equatable/equatable.dart';

abstract class LoginEvent extends Equatable {
  const LoginEvent();

  @override
  List<Object?> get props => <Object?>[];
}

class LoginButtonPressed extends LoginEvent {

  const LoginButtonPressed({
    required this.username,
    required this.password,
  });
  final String username;
  final String password;

  @override
  List<Object?> get props => <Object?>[username, password];
}

class LoginReset extends LoginEvent {
  const LoginReset();
}
