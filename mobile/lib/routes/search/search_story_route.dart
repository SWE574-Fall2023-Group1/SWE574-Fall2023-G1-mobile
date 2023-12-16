import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:memories_app/routes/search/bloc/search_story_bloc.dart';

class SearchStoryRoute extends StatefulWidget {
  const SearchStoryRoute({super.key});

  @override
  State<SearchStoryRoute> createState() => _SearchStoryRouteState();
}

class _SearchStoryRouteState extends State<SearchStoryRoute> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SearchStoryBloc, SearchStoryState>(
        buildWhen: (SearchStoryState previousState, SearchStoryState state) {
      return !(state is SearchStoryFailure || state is SearchStoryOffline);
    }, builder: (BuildContext context, SearchStoryState state) {
      return Center(
        child: OutlinedButton(
          child: Text("test"),
          onPressed: () {
            BlocProvider.of<SearchStoryBloc>(context)
                .add(const SearchStoryEventSearchPressed(
              author: "ayhan2",
              timeType: "Decade",
              decade: 2020,
              marker: null,
              radius: 25,
              dateDiff: 2,
            ));
          },
        ),
      );
    }, listener: (BuildContext context, SearchStoryState state) {
      if (state is SearchStorySuccess) {
      } else if (state is SearchStoryFailure) {
      } else if (state is SearchStoryOffline) {}
    });
  }
}
