import 'package:flutter_bloc/flutter_bloc.dart';

import '../models/user.dart';
import '../services/idempiere_auth_service.dart';
import 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  final IdempiereAuthService authService;

  LoginCubit({required this.authService}) : super(const LoginInitial());

  Future<void> login(String username, String password) async {
    emit(const LoginLoading());
    try {
      final response = await authService.login(username, password);
      final user = Client(
        tenantId: response.id,
        tenantName: response.name,
        token: response.token,
      );
      emit(LoginSuccess(user));
    } on IdempiereDatabaseException catch (e) {
      emit(LoginFailure(e.message));
    } catch (e) {
      emit(LoginFailure('An unexpected error occurred'));
    }
  }

  void reset() {
    emit(const LoginInitial());
  }
}
