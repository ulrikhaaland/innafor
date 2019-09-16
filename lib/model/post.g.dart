// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Post _$PostFromJson(Map<String, dynamic> json) {
  return Post(
    id: json['id'] as String,
    imgUrlList: json['imgUrlList'] as List,
    message: json['message'] as String,
    title: json['title'] as String,
    uid: json['uid'] as String,
    userName: json['userName'] as String,
    userNameId: json['userNameId'] as String,
  );
}

Map<String, dynamic> _$PostToJson(Post instance) => <String, dynamic>{
      'id': instance.id,
      'imgUrlList': instance.imgUrlList,
      'message': instance.message,
      'title': instance.title,
      'uid': instance.uid,
      'userName': instance.userName,
      'userNameId': instance.userNameId,
    };
