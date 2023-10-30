import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:memories_app/routes/home/bloc/home_bloc.dart';
import 'package:memories_app/routes/home/model/post_response_model.dart';
import 'package:memories_app/util/router.dart';

// TODO: Move business logic to bloc
// TODO: Move PostCard to a separate file
// TODO: Improve design
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
          container = MaterialApp(
            home: Scaffold(
              appBar: AppBar(
                backgroundColor: Colors.white,
                leading: IconButton(
                  icon: const Icon(
                    Icons.power_settings_new,
                    color: Colors.black87, // Set the color to dark grey
                  ),
                  // You can use any other icon you prefer
                  onPressed: () {
                    handleLogout(context);
                  },
                ),
                title: Image.asset(
                  'assets/login/logo.png',
                  height: 140,
                ),
                centerTitle: true,
              ),
              body: const PostList(),
            ),
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

class PostList extends StatelessWidget {
  const PostList({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<PostModel>>(
      future: loadPosts(context),
      builder: (BuildContext context, AsyncSnapshot<List<PostModel>> snapshot) {
        if (snapshot.hasData) {
          List<PostModel> posts = snapshot.data!;
          return ListView.builder(
            itemCount: posts.length,
            itemBuilder: (BuildContext context, int index) {
              return PostCard(post: posts[index]);
            },
            padding: const EdgeInsets.all(8),
          );
        } else if (snapshot.hasError) {
          return const Center(child: Text('Error loading posts'));
        }
        return const Center(child: CircularProgressIndicator());
      },
    );
  }
}

Future<List<PostModel>> loadPosts(BuildContext context) async {
  List<dynamic> jsonList = jsonDecode(await DefaultAssetBundle.of(context)
      .loadString('assets/home/mock_up.json'));

  return jsonList.map((json) {
    return PostModel(
      username: json['username'],
      title: json['title'],
      date: json['date'],
      location: json['location'],
    );
  }).toList();
}

class PostCard extends StatelessWidget {
  final PostModel post;

  const PostCard({required this.post, super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'By ${post.username}',
              style: const TextStyle(
                color: Color(0xFFAFB4B7),
                fontSize: 14,
                fontFamily: 'Inter',
                fontWeight: FontWeight.bold,
                height: 0,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: <Widget>[
                Text(
                  post.title,
                  style: const TextStyle(
                    color: Color(0xFF5F6565),
                    fontSize: 18,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w600,
                    height: 0,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: <Widget>[
                Image.asset(
                  'assets/home/calendar_icon.png',
                  height: 20,
                  width: 20,
                ),
                const SizedBox(width: 4),
                Text(
                  post.date,
                  style: const TextStyle(
                    color: Color(0xFFAFB4B7),
                    fontSize: 14,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w500,
                    height: 0,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: <Widget>[
                Image.asset(
                  'assets/home/location_marker.png',
                  height: 20,
                  width: 20,
                ),
                const SizedBox(width: 4),
                Text(
                  post.location,
                  style: const TextStyle(
                    color: Color(0xFFAFB4B7),
                    fontSize: 14,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w500,
                    height: 0,
                  ),
                ),
                const Spacer(),
                Row(
                  children: <Widget>[
                    const Text(
                      'More',
                      style: TextStyle(
                        color: Color(0xFFAFB4B7),
                        fontSize: 14,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w500,
                        height: 0,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Image.asset(
                      'assets/home/chevrons-right.png',
                      height: 20,
                      width: 20,
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

void handleLogout(BuildContext context) {
  // Add your logout logic here
  // For example, you can clear user session and navigate to the login screen.
  AppRoute.login.navigate(context);
}
