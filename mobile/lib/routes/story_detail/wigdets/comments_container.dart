import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:memories_app/routes/home/model/comment_model.dart';
import 'package:memories_app/routes/home/model/response/comments_response_model.dart';
import 'package:memories_app/routes/story_detail/model/story_detail_repository.dart';
import 'package:memories_app/routes/story_detail/wigdets/avatar_container.dart';

class LoadComments extends StatelessWidget {
  final int storyId;

  const LoadComments({required this.storyId, super.key});

  Future<List<CommentModel>> loadComments(BuildContext context) async {
    CommentResponseModel? responseModel;
    responseModel = await StoryDetailRepositoryImp().getComments(id: storyId);
    return responseModel.comments;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<CommentModel>>(
      future: loadComments(context),
      builder:
          (BuildContext context, AsyncSnapshot<List<CommentModel>> snapshot) {
        if (snapshot.hasData) {
          List<CommentModel> comments = snapshot.data!;
          return Column(children: <Widget>[
            const Text(
              'Comments',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontFamily: 'Inter',
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Column(
              children: comments.map((CommentModel comment) {
                return CommentWidget(comment: comment);
              }).toList(),
            )
          ]);
        }
        return const Center(child: CircularProgressIndicator());
      },
    );
  }
}

class CommentWidget extends StatelessWidget {
  final CommentModel comment;

  const CommentWidget({required this.comment, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(10),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.grey[200],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              LoadAvatar(id: comment.commentAuthorId),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    comment.commentAuthor,
                    style: const TextStyle(
                      color: Color(0xFF007AFF),
                      fontSize: 12,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w700,
                      height: 0,
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Container(
                    decoration: const BoxDecoration(color: Colors.white),
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Text(
                        comment.text,
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 12,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w700,
                          height: 0,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 5),
          Text(
            DateFormat('MM/dd/yyyy, hh:mm:ss a').format(comment.date),
            style: const TextStyle(
              color: Colors.black,
              fontSize: 12,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w700,
              height: 0,
            ),
          ),
        ],
      ),
    );
  }
}
