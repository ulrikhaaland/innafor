import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  List<String> expertId;
  String userName;
  final String id;
  String email;
  String fcm;
  String bio;
  String profilePicURL;
  double appVersion;
  File image;
  int notifications;
  DateTime birthDate;

  final Firestore _firestoreInstance = Firestore.instance;
  User({
    this.email,
    this.id,
    this.userName,
    this.fcm,
    this.bio,
    this.profilePicURL,
    this.appVersion,
    this.image,
    this.notifications,
    this.birthDate,
    this.expertId,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': this.id,
      'name': this.userName,
      'email': this.email,
      'fcm': this.fcm,
      'bio': this.bio,
      'profilepicurl': this.profilePicURL,
      'appversion': this.appVersion,
      'notifications': this.notifications,
      'expert_id': this.expertId,
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

  // Future<Null> _updateExperts() {
  //   for (var item in expertList) {
  //     Firestore.instance.document("users/$id/expert/${item.id}").updateData(item.)
  //   }
  // }
}
