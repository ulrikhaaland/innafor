import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';

part 'comment.g.dart';

enum CommentType { comment, response, topLevel }

@JsonSerializable()
class Comment {
  Comment({
    this.id,
    this.isChildOfId,
    this.text,
    this.timestamp,
    this.uid,
    this.userImageUrl,
    this.userName,
    this.userNameId,
    this.favoriteIds,
    this.userRating,
    this.docRef,
    this.hierarchy,
  });
  String uid;
  String userImageUrl;
  String userName;
  String userNameId;
  String id;
  String isChildOfId;
  String text;
  DateTime timestamp;
  @JsonKey(ignore: true)
  double sort;
  @JsonKey(disallowNullValue: true)
  List<String> favoriteIds;
  @JsonKey(disallowNullValue: true)
  List<String> hierarchy;
  double userRating;
  @JsonKey(ignore: true)
  DocumentReference docRef;

  factory Comment.fromJson(Map<String, dynamic> json) =>
      _$CommentFromJson(json);

  Map<String, dynamic> toJson() => _$CommentToJson(this);
}
