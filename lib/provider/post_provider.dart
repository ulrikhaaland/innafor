import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:innafor/model/comment.dart';
import 'package:innafor/model/post.dart';
import 'package:innafor/provider/crud_provider.dart';

class PostProvider {
  Future<Post> providePost(String postId) async {
    DocumentSnapshot postSnap = await CrudProvider().read("post/$postId");

    Post post = Post.fromJson(postSnap.data);

    post.id = postSnap.documentID;

    post.docRef = postSnap.reference;

    return post;
  }
}
