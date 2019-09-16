import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:innafor/model/comment.dart';
import 'package:innafor/presentation/post/post-comment/post_new_comment.dart';

class CommentProvider {
  Firestore firestoreInstance = Firestore.instance;

  Future<List<Comment>> provideComments(String postId) async {
    List<Comment> commentList = <Comment>[];
    QuerySnapshot qSnap = await firestoreInstance
        .collection("post/$postId/comments")
        .getDocuments();
    if (qSnap.documents.isNotEmpty) {
      qSnap.documents.forEach((doc) {
        Comment comment = Comment.fromJson(doc.data);

        if (comment.favoriteIds == null) {
          comment.favoriteIds = [];
        }

        comment.id = doc.documentID;

        comment.docRef = doc.reference;

        commentList.add(comment);
      });

      commentList.forEach((c) => c.sort =
          (commentList.where((child) => child.isChildOfId == c.id).length * 1) +
              (c.favoriteIds.length * 0.6));
      commentList.sort((a, b) => b.sort.compareTo(a.sort));

      return commentList;
    } else {
      return commentList;
    }
  }

  Future<void> deleteComment(Comment comment) {
    return comment.docRef.delete();
  }

  Future<void> saveComment({Comment comment, String postId}) {
    return firestoreInstance
        .collection("post/$postId/comments")
        .add(comment.toJson())
        .then((docRef) {
      comment.docRef = docRef;
      comment.id = docRef.documentID;
    });
  }
}
