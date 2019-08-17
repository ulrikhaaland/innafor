import 'comment.dart';

class Post {
  int commentCount;
  final List<dynamic> imgUrlList;
  final String message;
  final String title;
  final List<Comment> commentList;

  Post(
      {this.commentList,
      this.imgUrlList,
      this.message,
      this.commentCount,
      this.title});
}
