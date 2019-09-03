import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:innafor/post/post-comment/post_new_comment.dart';

import 'user.dart';

enum CommentType { comment, response, topLevel }

class Comment {
  final String uid;
  final String userImageUrl;
  final String userName;
  final String userNameId;
  String id;
  String isChildOfId;
  final String text;
  final DateTime timestamp;
  final List<String> ancestorIds;
  double sort;
  final List<String> favoriteIds;
  final double userRating;
  DocumentReference docRef;

  Comment({
    this.id,
    this.isChildOfId,
    this.text,
    this.timestamp,
    this.ancestorIds,
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

  void addComment({
    @required String postId,
    NewCommentType type,
  }) {
    Firestore.instance
        .collection("post/$postId/comments")
        .add(this.toJson())
        .then((docRef) {
      this.docRef = docRef;
      this.id = docRef.documentID;
    });
  }
}
