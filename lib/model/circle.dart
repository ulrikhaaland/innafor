import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:innafor/presentation/post/post_page.dart';
import 'package:json_annotation/json_annotation.dart';

part 'circle.g.dart';

@JsonSerializable()
class Circle {
  Circle({this.title, this.postIds}) {
    this.postIds = [];
    this.postPages = [];
  }

  String title;
  @JsonKey(ignore: true)
  List<String> postIds;
  @JsonKey(ignore: true)
  List<PostPage> postPages;
  @JsonKey(ignore: true)
  DocumentReference docRef;

  factory Circle.fromJson(Map<String, dynamic> json) => _$CircleFromJson(json);

  Map<String, dynamic> toJson() => _$CircleToJson(this);
}
