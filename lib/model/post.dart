import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';

part 'post.g.dart';

@JsonSerializable()
class Post {
  Post(
      {this.id,
      this.imgUrlList,
      this.message,
      this.title,
      this.uid,
      this.userName,
      this.userNameId,
      this.docRef});
  String id;
  List<dynamic> imgUrlList;
  String message;
  String title;
  String uid;
  String userName;
  String userNameId;

  @JsonKey(ignore: true)
  DocumentReference docRef;

  factory Post.fromJson(Map<String, dynamic> json) => _$PostFromJson(json);

  Map<String, dynamic> toJson() => _$PostToJson(this);
}
