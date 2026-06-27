import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'cubits/login_cubit.dart';
import 'cubits/login_state.dart';
import 'services/idempiere_auth_service.dart';
import 'views/home_page.dart';
import 'views/login_view.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'iDempiere ERP',
      theme: ThemeData(primarySwatch: Colors.blue, useMaterial3: true),
      home: BlocProvider(
        create: (BuildContext context) => LoginCubit(authService: IdempiereAuthService()),
        child: const AuthPage(),
      ),
      routes: <String, WidgetBuilder>{
        '/login': (BuildContext context) => BlocProvider(
          create: (BuildContext context) => LoginCubit(authService: IdempiereAuthService()),
          child: const LoginView(),
        ),
      },
    );
  }
}

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginCubit, LoginState>(
      builder: (BuildContext context, LoginState state) {
        if (state is LoginSuccess) {
          return HomePage(client: state.client);
        }
        return const LoginView();
      },
    );
  }
}
