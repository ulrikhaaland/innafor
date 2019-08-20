import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class User {
  String name;
  String id;
  String email;
  String fcm;
  String bio;
  String profilePicURL;
  double appVersion;
  int notifications;
  DateTime birthDate;
  List<dynamic> blockedUserId;
  bool blocked;
  final DocumentReference docRef;

  final Firestore _firestoreInstance = Firestore.instance;
  User(
      {this.email,
      this.id,
      this.name,
      this.fcm,
      this.bio,
      this.profilePicURL,
      this.appVersion,
      this.notifications,
      this.blockedUserId,
      this.docRef});

  fromJson(Map<String, dynamic> data) {
    this.email = data["email"];
    this.id = data["id"];
    this.name = data["name"];
    this.email = data["email"];
    this.fcm = data["fcm"];
    this.bio = data["bio"];
    this.profilePicURL = data["profile_pic_url"];
    this.appVersion = data["app_version"];
    this.notifications = data["notifications"];
    this.blockedUserId = data["blocker_user_id"] ?? <dynamic>[];
  }

  Map<String, dynamic> toJson() {
    return {
      'id': this.id,
      'name': this.name,
      'email': this.email,
      'fcm': this.fcm,
      'bio': this.bio,
      'profile_pic_url': this.profilePicURL,
      'app_version': this.appVersion,
      'notifications': this.notifications,
      'blocker_user_id': this.blockedUserId,
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
