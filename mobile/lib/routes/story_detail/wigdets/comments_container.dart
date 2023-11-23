import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:memories_app/routes/home/model/comment_model.dart';
import 'package:memories_app/routes/home/model/request/comment_request_model.dart';
import 'package:memories_app/routes/home/model/response/comments_response_model.dart';
import 'package:memories_app/routes/story_detail/model/story_detail_repository.dart';
import 'package:memories_app/routes/story_detail/story_detail_route.dart';
import 'package:memories_app/routes/story_detail/wigdets/avatar_container.dart';
import 'package:memories_app/util/sp_helper.dart';

class LoadComments extends StatefulWidget {
  final int storyId;

  const LoadComments({required this.storyId, super.key});

  @override
  LoadCommentsState createState() => LoadCommentsState();
}

class LoadCommentsState extends State<LoadComments> {
  late Future<List<CommentModel>> comments;

  LoadCommentsState();

  @override
  void initState() {
    super.initState();
    comments = loadComments();
  }

  Future<List<CommentModel>> loadComments() async {
    CommentResponseModel? responseModel;
    responseModel =
        await StoryDetailRepositoryImp().getComments(id: widget.storyId);
    return responseModel.comments;
  }

  void _addNewComment(CommentModel newComment) {
    setState(() {
      comments = comments.then((List<CommentModel> comments) =>
          Future<List<CommentModel>>.value(
              <CommentModel>[...comments, newComment]));
    });
    shouldRefreshStories = true;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<CommentModel>>(
      future: comments,
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
            ),
            PostCommentWidget(
              storyId: widget.storyId,
              onCommentSubmitted: (CommentModel newComment) {
                _addNewComment(newComment);
              },
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

class PostCommentWidget extends StatefulWidget {
  final int storyId;
  final Function(CommentModel) onCommentSubmitted;

  const PostCommentWidget(
      {required this.storyId, required this.onCommentSubmitted, super.key});

  @override
  PostCommentWidgetState createState() => PostCommentWidgetState();
}

class PostCommentWidgetState extends State<PostCommentWidget> {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(8),
          child: TextField(
            controller: _controller,
            keyboardType: TextInputType.multiline,
            decoration: const InputDecoration(
              hintText: 'Add a comment...',
              border: OutlineInputBorder(),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8),
          child: ElevatedButton(
            child: const Text('Submit'),
            onPressed: () async {
              CommentModel newComment =
                  await StoryDetailRepositoryImp().postComment(
                id: widget.storyId,
                requestModel: CommentRequestModel(
                  commentAuthorId:
                      await SPHelper.getInt(SPKeys.currentUserId) as int,
                  storyId: widget.storyId,
                  text: _controller.text,
                ),
              );
              _controller.clear();
              widget.onCommentSubmitted(newComment);
            },
          ),
        ),
      ],
    );
  }
}
