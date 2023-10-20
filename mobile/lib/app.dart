import 'package:flutter/material.dart';
import 'package:memories_app/routes/login/login_route.dart';

void runApplication() {
  runApp(const App());
}

// TODO: Return BlocBuilder and build LoginBloc here with BlocProvider
class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: LoginRoute(),
    );
  }
}
