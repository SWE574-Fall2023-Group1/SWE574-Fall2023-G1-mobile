import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:memories_app/routes/home/bloc/home_bloc.dart';

// TODO: Add home page design
class HomeRoute extends StatefulWidget {
  final HomeBloc bloc;
  const HomeRoute({required this.bloc, super.key});

  @override
  State<HomeRoute> createState() => _HomeRouteState();
}

class _HomeRouteState extends State<HomeRoute> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<HomeBloc>(
      create: (BuildContext context) => HomeBloc()..add(HomeLoadDisplayEvent()),
      child: BlocConsumer<HomeBloc, HomeState>(
        builder: (BuildContext context, HomeState state) {
          Widget container;
          if (state is HomeInitial) {
            container = const CircularProgressIndicator();
          } else if (state is HomeDisplayState) {
            container = Container(
              color: Colors.yellow,
            );
          } else {
            container = const CircularProgressIndicator();
          }
          return container;
        },
        listener: (BuildContext context, HomeState state) {},
      ),
    );
  }
}
