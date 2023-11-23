class CommentRequestModel {
  final int commentAuthorId;
  final int storyId;
  final String text;

  CommentRequestModel({
    required this.commentAuthorId,
    required this.storyId,
    required this.text,
  });

  factory CommentRequestModel.fromJson(Map<String, dynamic> json) {
    return CommentRequestModel(
      commentAuthorId: json['comment_author'] as int,
      storyId: json['story'] as int,
      text: json['text'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'comment_author': commentAuthorId,
      'story': storyId,
      'text': text,
    };
  }
}
