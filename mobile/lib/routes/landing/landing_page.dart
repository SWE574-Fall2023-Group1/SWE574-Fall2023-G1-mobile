import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:memories_app/routes/home/bloc/home_bloc.dart';
import 'package:memories_app/routes/home/home_route.dart';
import 'package:memories_app/routes/landing/bloc/landing_bloc.dart';
import 'package:memories_app/routes/map/create_story_route.dart';
import 'package:memories_app/util/utils.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});
  static const String routeName = '/landing';

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  @override
  Widget build(BuildContext context) {
    // ignore: no_leading_underscores_for_local_identifiers
    PageController _pageController = PageController();

    return BlocConsumer<LandingBloc, LandingState>(
      buildWhen: (LandingState previousState, LandingState state) {
        return state is! LandingJumpToPageState;
      },
      builder: (BuildContext context, LandingState state) {
        Widget widget;
        if (state is LandingInitial) {
          widget = const CircularProgressIndicator();
        } else if (state is LandingDisplayState) {
          widget = Scaffold(
            body: PageView(
              controller: _pageController,
              onPageChanged: (int index) {
                BlocProvider.of<LandingBloc>(context)
                    .add(LandingOnPageChangedEvent(tabIndex: index));
              },
              children: _buildBottomNavScreen(),
            ),
            bottomNavigationBar: BottomNavigationBar(
              items: _buildBottomBarItems(state.tabIndex),
              onTap: (int index) {
                BlocProvider.of<LandingBloc>(context)
                    .add(LandingOnPageChangedEvent(tabIndex: index));
              },
              showSelectedLabels: true,
              showUnselectedLabels: true,
              selectedItemColor: AppColors.buttonColor,
              unselectedItemColor: Colors.black,
              currentIndex: state.tabIndex,
              selectedLabelStyle: const TextStyle(color: AppColors.buttonColor),
              unselectedLabelStyle: const TextStyle(color: Colors.black),
            ),
          );
        } else {
          widget = const CircularProgressIndicator();
        }
        return widget;
      },
      listener: (BuildContext context, LandingState state) {
        if (state is LandingJumpToPageState) {
          if (state.tabIndex == 2) {
            // ignore: always_specify_types
            Navigator.of(context).push(MaterialPageRoute(
              builder: (BuildContext context) => const CreateStoryRoute(),
            ));
          } else {
            _pageController.jumpToPage(state.tabIndex);
          }
        }
      },
    );
  }

  List<Widget> _buildBottomNavScreen() {
    return <Widget>[
      BlocProvider<HomeBloc>(
        create: (BuildContext context) =>
            HomeBloc()..add(HomeLoadDisplayEvent()),
        child: const HomeRoute(),
      ),
      const Center(child: Text('Index 1: Profile')),
      const Placeholder(),
      const Center(child: Text('Index 3: Search')),
      const Center(child: Text('Index 4: More')),
    ];
  }

  List<BottomNavigationBarItem> _buildBottomBarItems(int selectedIndex) {
    return <BottomNavigationBarItem>[
      BottomNavigationBarItem(
        icon: Image.asset(
          "assets/landing/home.png",
          color: selectedIndex == 0 ? AppColors.buttonColor : Colors.black,
        ),
        label: 'Home',
      ),
      BottomNavigationBarItem(
        icon: Image.asset(
          "assets/landing/user.png",
          color: selectedIndex == 1 ? AppColors.buttonColor : Colors.black,
        ),
        label: 'Profile',
      ),
      BottomNavigationBarItem(
        icon: Image.asset(
          "assets/landing/file-add.png",
          color: selectedIndex == 2 ? AppColors.buttonColor : Colors.black,
        ),
        label: 'Create',
      ),
      BottomNavigationBarItem(
        icon: Image.asset(
          "assets/landing/search.png",
          color: selectedIndex == 3 ? AppColors.buttonColor : Colors.black,
        ),
        label: 'Search',
      ),
      BottomNavigationBarItem(
        icon: Image.asset(
          "assets/landing/menu.png",
          color: selectedIndex == 4 ? AppColors.buttonColor : Colors.black,
        ),
        label: 'More',
      ),
    ];
  }
}
