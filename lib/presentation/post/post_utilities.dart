import 'package:innafor/model/comment.dart';

abstract class PostActionController {
  // Future<model.DateEvent> getDateEvent(int dateEventId);
  Future<void> saveComment(Comment comment);
  Future<void> deleteComment(Comment comment);
}
