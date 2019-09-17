import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:innafor/model/comment.dart';
import 'package:innafor/presentation/post/post-comment/post_new_comment.dart';
import 'package:innafor/provider/crud_provider.dart';

class CommentProvider {
  Firestore firestoreInstance = Firestore.instance;

  Future<List<Comment>> provideComments(String postId) async {
    List<Comment> commentList = <Comment>[];
    QuerySnapshot qSnap =
        await CrudProvider().getCollection("post/$postId/comments");
    if (qSnap.documents.isNotEmpty) {
      qSnap.documents.forEach((doc) {
        Comment comment = Comment.fromJson(doc.data);

        if (comment.favoriteIds == null) {
          comment.favoriteIds = [];
        }

        if (comment.hierarchy == null) {
          comment.hierarchy = [];
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

  Future delete(Comment comment, List<Comment> commentList) {
    while (comment.hierarchy.isNotEmpty) {
      Comment child =
          commentList.firstWhere((c) => c.id == comment.hierarchy[0]);
      delete(child, commentList);
      comment.hierarchy.remove(child.id);
    }
    return CrudProvider().delete(comment);
  }

  Future saveComment({Comment comment, DocumentReference postRef}) {
    return CrudProvider().create(comment, postRef.path + "/comments");
  }
}
