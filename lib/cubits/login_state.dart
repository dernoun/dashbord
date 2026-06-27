import 'package:equatable/equatable.dart';

import 'package:dashbord/models/user.dart';

abstract class LoginState extends Equatable {
  const LoginState();

  @override
  List<Object?> get props => <Object?>[];
}

class LoginInitial extends LoginState {
  const LoginInitial();
}

class LoginLoading extends LoginState {
  const LoginLoading();
}

class LoginSuccess extends LoginState {

  const LoginSuccess(this.client);
  final Client client;

  @override
  List<Object?> get props => <Object?>[client];
}

class LoginFailure extends LoginState {

  const LoginFailure(this.error);
  final String error;

  @override
  List<Object?> get props => <Object?>[error];
}
