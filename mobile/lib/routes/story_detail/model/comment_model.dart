class CommentModel {
  final int id;
  final String commentAuthor;
  final int commentAuthorId;
  final int story;
  final String text;
  final DateTime date;
  final bool success;
  final String msg;

  CommentModel({
    required this.id,
    required this.commentAuthor,
    required this.commentAuthorId,
    required this.story,
    required this.text,
    required this.date,
    required this.success,
    required this.msg,
  });

  factory CommentModel.fromJson(Map<String, dynamic> json) {
    return CommentModel(
      id: json['id'] as int,
      commentAuthor: json['comment_author'] as String,
      commentAuthorId: json['comment_author_id'] as int,
      story: json['story'] as int,
      text: json['text'] as String,
      date: DateTime.parse(json['date'] as String),
      success: json['success'] as bool,
      msg: json['msg'] as String,
    );
  }
}
