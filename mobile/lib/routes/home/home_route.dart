import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:memories_app/routes/home/bloc/home_bloc.dart';
import 'package:memories_app/routes/home/model/home_repository.dart';
import 'package:memories_app/routes/home/model/request/all_stories_request_model.dart';
import 'package:memories_app/routes/home/model/response/stories_response_model.dart';
import 'package:memories_app/util/router.dart';
import 'package:memories_app/routes/home/model/story_model.dart';

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
    return FutureBuilder<List<StoryModel>>(
      future: loadPosts(context),
      builder:
          (BuildContext context, AsyncSnapshot<List<StoryModel>> snapshot) {
        if (snapshot.hasData) {
          List<StoryModel> posts = snapshot.data!;
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

Future<List<StoryModel>> loadPosts(BuildContext context) async {
  AllStoriesRequestModel requestModel =
      AllStoriesRequestModel(page: 1, size: 10);

  StoriesResponseModel? responseModel;

  responseModel = await HomeRepositoryImp().getAllStories(requestModel);

  return responseModel.stories;
}

class PostCard extends StatelessWidget {
  final StoryModel post;

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
              'By ${post.author_username}',
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
                  post.date ?? "",
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
                  post.location_ids[0].name,
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
