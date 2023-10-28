import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:memories_app/routes/login/bloc/login_bloc.dart';
import 'package:memories_app/routes/login/login_route.dart';
import 'package:memories_app/routes/login/model/login_repository.dart';

class _Constants {
  static final LoginRepositoryImp loginRepository = LoginRepositoryImp();
}

void runApplication() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: BlocProvider<LoginBloc>(
        create: (BuildContext context) =>
            LoginBloc(repository: _Constants.loginRepository)
              ..add(LoginLoadDisplayEvent()),
        child: const LoginRoute(),
      ),
    );
  }
}
