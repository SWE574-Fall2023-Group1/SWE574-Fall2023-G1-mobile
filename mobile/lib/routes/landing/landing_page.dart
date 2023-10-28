import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:memories_app/routes/home/bloc/home_bloc.dart';
import 'package:memories_app/routes/home/home_route.dart';
import 'package:memories_app/routes/landing/bloc/landing_bloc.dart';

List<BottomNavigationBarItem> bottomNavItems = <BottomNavigationBarItem>[
  BottomNavigationBarItem(
    icon: Image.asset(
      "assets/landing/home.png",
      color: Colors.black,
    ),
    label: 'Home',
  ),
  BottomNavigationBarItem(
    icon: Image.asset(
      "assets/landing/user.png",
      color: Colors.black,
    ),
    label: 'Profile',
  ),
  BottomNavigationBarItem(
    icon: Image.asset(
      "assets/landing/file-add.png",
      color: Colors.black,
    ),
    label: 'Create',
  ),
  BottomNavigationBarItem(
    icon: Image.asset(
      "assets/landing/search.png",
      color: Colors.black,
    ),
    label: 'Search',
  ),
  BottomNavigationBarItem(
    icon: Image.asset(
      "assets/landing/menu.png",
      color: Colors.black,
    ),
    label: 'More',
  ),
];

List<Widget> bottomNavScreen = <Widget>[
  BlocProvider<HomeBloc>(
    create: (BuildContext context) => HomeBloc()..add(HomeLoadDisplayEvent()),
    child: const HomeRoute(),
  ),
  const Text('Index 1: Profile'),
  const Text('Index 2: Create'),
  const Text('Index 3: Search'),
  const Text('Index 4: More'),
];

class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LandingBloc, LandingState>(
      listener: (BuildContext context, LandingState state) {},
      builder: (BuildContext context, LandingState state) {
        return Scaffold(
          body: Center(child: bottomNavScreen.elementAt(state.tabIndex)),
          bottomNavigationBar: BottomNavigationBar(
            items: bottomNavItems,
            currentIndex: state.tabIndex,
            selectedItemColor: Colors.black,
            unselectedItemColor: Colors.black,
            showSelectedLabels: true,
            showUnselectedLabels: true,
            onTap: (int index) {
              BlocProvider.of<LandingBloc>(context)
                  .add(LandingTabChangeEvent(tabIndex: index));
            },
          ),
        );
      },
    );
  }
}
