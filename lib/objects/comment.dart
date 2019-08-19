import 'user.dart';

class Comment {
  final String uid;
  final String userImageUrl;
  final String userName;
  final String id;
  final String isChildOfId;
  final String text;
  final int commentCount;
  final DateTime timestamp;
  final List<Comment> children;
  int sort;
  final List<String> favoriteIds;

  Comment(
      {this.id,
      this.isChildOfId,
      this.text,
      this.commentCount,
      this.timestamp,
      this.children,
      this.uid,
      this.userImageUrl,
      this.userName,
      this.favoriteIds});
}
