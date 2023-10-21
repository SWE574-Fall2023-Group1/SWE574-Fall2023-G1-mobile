import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:memories_app/routes/login/bloc/login_bloc.dart";

// TODO: add login design and login bloc

class LoginRoute extends StatefulWidget {
  const LoginRoute({super.key});

  @override
  State<LoginRoute> createState() => _LoginRouteState();
}

class _LoginRouteState extends State<LoginRoute> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LoginBloc, LoginState>(
      builder: (context, state) {
        if (state is LoginInitial) {
          return const CircularProgressIndicator();
        } else if (state is LoginDisplayState) {
          return Material(
            child: Container(color: Colors.blue),
          );
        }
        return Container(color: Colors.red);
      },
      listener: (context, state) {
        if (state is LoginSuccess) {
          // TODO: Navigate to home page
        } else if (state is LoginFailure) {
          // TODO: Show error popup
        }
      },
    );
  }
}
