import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:innafor/model/comment.dart';
import 'package:innafor/model/post.dart';

class PostProvider {
  Future<Post> providePost(String postId) async {
    DocumentSnapshot postSnap =
        await Firestore.instance.document("post/$postId").get();

    Post post = Post.fromJson(postSnap.data);

    post.id = postSnap.documentID;

    post.docRef = postSnap.reference;

    return post;
  }
}
