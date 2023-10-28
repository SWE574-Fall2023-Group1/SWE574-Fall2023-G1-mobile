import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:memories_app/routes/home/bloc/home_bloc.dart';

// TODO: Add home page design
class HomeRoute extends StatefulWidget {
  const HomeRoute({super.key});

  @override
  State<HomeRoute> createState() => _HomeRouteState();
}

class _HomeRouteState extends State<HomeRoute>
    with AutomaticKeepAliveClientMixin<HomeRoute> {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BlocConsumer<HomeBloc, HomeState>(
      builder: (BuildContext context, HomeState state) {
        Widget container;
        if (state is HomeInitial) {
          container = const CircularProgressIndicator();
        } else if (state is HomeDisplayState) {
          // TODO: Show stories list
          container = Container(
            color: Colors.yellow,
          );
        } else {
          container = const CircularProgressIndicator();
        }
        return container;
      },
      listener: (BuildContext context, HomeState state) {},
    );
  }
}
