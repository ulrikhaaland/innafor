import 'package:cloud_firestore/cloud_firestore.dart';

import 'comment.dart';

class Post {
  final String id;
  final List<dynamic> imgUrlList;
  final String message;
  final String title;
  final List<Comment> commentList;
  final String uid;
  final String userName;
  final String userNameId;
  final DocumentReference docRef;

  Post(
      {this.id,
      this.commentList,
      this.imgUrlList,
      this.message,
      this.title,
      this.uid,
      this.userName,
      this.docRef,
      this.userNameId});
}
