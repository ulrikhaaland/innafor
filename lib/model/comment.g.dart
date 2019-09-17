// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'comment.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Comment _$CommentFromJson(Map<String, dynamic> json) {
  $checkKeys(json, disallowNullValues: const ['favoriteIds', 'hierarchy']);
  return Comment(
    id: json['id'] as String,
    isChildOfId: json['isChildOfId'] as String,
    text: json['text'] as String,
    timestamp: json['timestamp'] == null
        ? null
        : DateTime.parse(json['timestamp'] as String),
    uid: json['uid'] as String,
    userImageUrl: json['userImageUrl'] as String,
    userName: json['userName'] as String,
    userNameId: json['userNameId'] as String,
    favoriteIds:
        (json['favoriteIds'] as List)?.map((e) => e as String)?.toList(),
    userRating: (json['userRating'] as num)?.toDouble(),
    hierarchy: (json['hierarchy'] as List)?.map((e) => e as String)?.toList(),
  );
}

Map<String, dynamic> _$CommentToJson(Comment instance) {
  final val = <String, dynamic>{
    'uid': instance.uid,
    'userImageUrl': instance.userImageUrl,
    'userName': instance.userName,
    'userNameId': instance.userNameId,
    'id': instance.id,
    'isChildOfId': instance.isChildOfId,
    'text': instance.text,
    'timestamp': instance.timestamp?.toIso8601String(),
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('favoriteIds', instance.favoriteIds);
  writeNotNull('hierarchy', instance.hierarchy);
  val['userRating'] = instance.userRating;
  return val;
}
