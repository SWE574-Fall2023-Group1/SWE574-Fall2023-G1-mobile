import 'package:flutter/material.dart';
import 'package:memories_app/routes/app/application_context.dart';
import 'package:memories_app/routes/story_detail/model/comment_model.dart';
import 'package:memories_app/routes/home/model/response/comments_response_model.dart';
import 'package:memories_app/routes/story_detail/model/request/comment_request_model.dart';
import 'package:memories_app/routes/story_detail/model/story_detail_repository.dart';
import 'package:memories_app/routes/story_detail/story_detail_route.dart';
import 'package:memories_app/routes/story_detail/widget/avatar_container.dart';
import 'package:timeago/timeago.dart' as timeago;

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
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.grey.shade300,
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              LoadAvatar(id: comment.commentAuthorId),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      comment.commentAuthor,
                      style: const TextStyle(
                        color: Color(0xFF007AFF),
                        fontSize: 14,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      comment.text,
                      style: const TextStyle(
                        color: Colors.black87,
                        fontSize: 12,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            timeago.format(comment.date.toLocal()),
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 10,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w400,
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
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          child: TextField(
            controller: _controller,
            keyboardType: TextInputType.multiline,
            maxLines: null,
            decoration: InputDecoration(
              hintText: 'Add a comment...',
              fillColor: Colors.grey[200],
              filled: true,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide.none,
              ),
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF007AFF),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onPressed: () async {
              CommentModel newComment =
                  await StoryDetailRepositoryImp().postComment(
                id: widget.storyId,
                requestModel: CommentRequestModel(
                  commentAuthorId: ApplicationContext.currentUserId,
                  storyId: widget.storyId,
                  text: _controller.text,
                ),
              );
              _controller.clear();
              widget.onCommentSubmitted(newComment);
            },
            child: const Text(
              'Submit',
              style: TextStyle(
                fontSize: 14,
                fontFamily: 'Inter',
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
