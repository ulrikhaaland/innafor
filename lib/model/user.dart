import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_networkimage/provider.dart';

class User {
  String userName;
  String userNameId;
  String id;
  String email;
  String fcm;
  String bio;
  String imageUrl;
  double appVersion;
  int notifications;
  double rating;
  DateTime birthDate;
  List<String> blockedUserIds;
  bool blocked;
  Widget profileImageWidget;
  List<String> bookmarkIds;
  final DocumentReference docRef;

  final Firestore _firestoreInstance = Firestore.instance;

  User(
      {this.email,
      this.id,
      this.userName,
      this.fcm,
      this.bio,
      this.imageUrl,
      this.appVersion,
      this.notifications,
      this.blockedUserIds,
      this.bookmarkIds,
      this.docRef,
      this.rating,
      this.userNameId});

  fromJson(Map<String, dynamic> data) {
    this.email = data["email"];
    this.id = data["id"];
    this.userName = data["name"];
    this.email = data["email"];
    this.fcm = data["fcm"];
    this.bio = data["bio"];
    this.imageUrl = data["image_url"];
    this.appVersion = data["app_version"];
    this.notifications = data["notifications"];
    this.bookmarkIds.addAll(data["bookmark_ids"]?.cast<String>() ?? []);
    this.blockedUserIds.addAll(data["blocker_user_ids"]?.cast<String>() ?? []);
    this.rating = data["rating"];
    this.userNameId = data["user_name_id"];
  }

  Map<String, dynamic> toJson() {
    return {
      'id': this.id,
      'name': this.userName,
      'email': this.email,
      'fcm': this.fcm,
      'bio': this.bio,
      'image_url': this.imageUrl,
      'app_version': this.appVersion,
      'notifications': this.notifications,
      'blocker_user_ids': this.blockedUserIds,
      'rating': this.rating,
      'user_name_id': this.userNameId,
    };
  }

  Future<Null> update() async {
    DocumentSnapshot docSnap =
        await _firestoreInstance.document("users/${this.id}").get();

    if (docSnap.exists) {
      await _firestoreInstance
          .document("users/${this.id}")
          .updateData(this.toJson());
    } else {
      await _firestoreInstance
          .document("users/${this.id}")
          .setData(this.toJson());
    }

    return;
  }
}
