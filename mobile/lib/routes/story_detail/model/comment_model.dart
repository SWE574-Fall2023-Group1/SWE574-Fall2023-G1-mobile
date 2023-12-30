import 'package:memories_app/routes/app/model/response/base_response_model.dart';

class CommentModel extends BaseResponseModel {
  final int id;
  final String commentAuthor;
  final int commentAuthorId;
  final int story;
  final String text;
  final DateTime date;

  CommentModel({
    required this.id,
    required this.commentAuthor,
    required this.commentAuthorId,
    required this.story,
    required this.text,
    required this.date,
    super.success = false,
    super.msg = '',
  });

  factory CommentModel.fromJson(Map<String, dynamic> json) {
    return CommentModel(
      id: json['id'] as int,
      commentAuthor: json['comment_author'] as String,
      commentAuthorId: json['comment_author_id'] as int,
      story: json['story'] as int,
      text: json['text'] as String,
      date: json['date'] is DateTime
          ? json['date']
          : DateTime.parse(json['date'] as String),
      success: json['success'] as bool,
      msg: json['msg'] as String,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'comment_author': commentAuthor,
      'comment_author_id': commentAuthorId,
      'story': story,
      'text': text,
      'date': date,
      'success': success,
      'msg': msg,
    };
  }
}
