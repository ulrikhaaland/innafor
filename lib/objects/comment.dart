import 'user.dart';

class Comment {
  final String text;
  final User user;
  final int commentCount;
  final DateTime timestamp;
  final int favoriteCount;
  final List<Comment> commentList;
  final bool children;

  Comment(
      {this.commentList,
      this.text,
      this.user,
      this.commentCount,
      this.timestamp,
      this.favoriteCount,
      this.children});
}
