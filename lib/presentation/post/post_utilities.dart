import 'package:innafor/model/comment.dart';

abstract class PostActionController {
  Future<void> saveComment(Comment comment);
  Future<void> deleteComment(Comment comment);
}
