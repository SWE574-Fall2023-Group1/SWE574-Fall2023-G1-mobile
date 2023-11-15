import 'package:memories_app/routes/home/model/comment_model.dart';

class CommentResponseModel {
  final List<CommentModel> comments;
  final bool hasNext;
  final bool hasPrev;
  final int? nextPage;
  final int? prevPage;
  final int totalPages;

  CommentResponseModel({
    required this.comments,
    required this.hasNext,
    required this.hasPrev,
    this.nextPage,
    this.prevPage,
    required this.totalPages,
  });

  factory CommentResponseModel.fromJson(Map<String, dynamic> json) {
    return CommentResponseModel(
      comments: (json['comments'] as List)
          .map((commentJson) => CommentModel.fromJson(commentJson))
          .toList(),
      hasNext: json['has_next'] as bool,
      hasPrev: json['has_prev'] as bool,
      nextPage: json['next_page'] as int?,
      prevPage: json['prev_page'] as int?,
      totalPages: json['total_pages'] as int,
    );
  }
}
