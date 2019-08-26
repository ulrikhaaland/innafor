import 'package:cloud_firestore/cloud_firestore.dart';

import 'user.dart';

enum CommentType { comment, response, topLevel }

class Comment {
  final String uid;
  final String userImageUrl;
  final String userName;
  final String userNameId;
  final String id;
  final String isChildOfId;
  final String text;
  final DateTime timestamp;
  final List<Comment> children;
  int sort;
  final List<String> favoriteIds;
  final double userRating;
  DocumentReference docRef;

  Comment({
    this.id,
    this.isChildOfId,
    this.text,
    this.timestamp,
    this.children,
    this.uid,
    this.userImageUrl,
    this.userName,
    this.userNameId,
    this.favoriteIds,
    this.userRating,
    this.docRef,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': this.id,
      'is_child_of_id': this.isChildOfId,
      'text': this.text,
      'timestamp': this.timestamp,
      'uid': this.uid,
      'user_image_url': this.userImageUrl,
      'user_name': this.userName,
      'user_rating': this.userRating,
      'user_name_id': this.userNameId,
    };
  }

  void addComment(String postId) {
    Firestore.instance
        .collection("post/$postId/comments")
        .add(this.toJson())
        .then((docRef) => this.docRef = docRef);
  }
}
