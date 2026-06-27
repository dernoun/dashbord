import 'package:dashbord/models/login_response.dart';
import 'package:dashbord/models/user.dart';
import 'package:dashbord/services/idempiere_auth_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {

  LoginCubit({required this.authService}) : super(const LoginInitial());
  final IdempiereAuthService authService;

  Future<void> login(String username, String password) async {
    emit(const LoginLoading());
    try {
      final LoginResponse response = await authService.login(username, password);
      // Create multiple Client instances for each client in the response
      final List<Client> clients = response.clients.entries.map((MapEntry<String, String> entry) {
        return Client(
          tenantId: entry.key,
          tenantName: entry.value,
          token: response.token,
        );
      }).toList();
      emit(
        LoginSuccess(
          clients.isNotEmpty
              ? clients.first
              : Client(tenantId: '', tenantName: '', token: response.token),
        ),
      );
    } on IdempiereDatabaseException catch (e) {
      emit(LoginFailure(e.message));
    } catch (e) {
      emit(const LoginFailure('An unexpected error occurred'));
    }
  }

  void reset() {
    emit(const LoginInitial());
  }
}
