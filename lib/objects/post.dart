import 'comment.dart';

class Post {
  final String id;
  final List<dynamic> imgUrlList;
  final String message;
  final String title;
  final List<Comment> commentList;
  final String uid;
  final String userName;

  Post(
      {this.id,
      this.commentList,
      this.imgUrlList,
      this.message,
      this.title,
      this.uid,
      this.userName});
}
