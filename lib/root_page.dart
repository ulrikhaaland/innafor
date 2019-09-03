import 'package:firebase_auth/firebase_auth.dart';
import 'package:innafor/post/post_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'animation/innafor_intro.dart';
import 'auth.dart';
import 'login/login_page.dart';
import 'objects/user.dart';
import 'service/service_provider.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/services.dart';
import './base_controller.dart';
import './base_view.dart';

enum AuthState {
  notAuthenticated,
  authenticating,
  authenticated,
  anon,
}

class RootPageController extends BaseController {
  final BaseAuth auth = Auth();

  Firestore firestoreInstance = Firestore.instance;
  FirebaseMessaging firebaseMessaging = FirebaseMessaging();

  FirebaseUser firebaseUser;

  User _user;
  bool introDone = false;

  @override
  void initState() {
    print('RootPage: initState');
    getUser();

    super.initState();
  }

  @override
  void dispose() {
    print('RootPage: dispose');
    super.dispose();
  }

  Future<Null> getUser() async {
    if (firebaseUser == null) {
      firebaseUser = await auth.currentUser();
    }

    if (firebaseUser != null) {
      DocumentSnapshot docSnap =
          await Firestore.instance.document("users/${firebaseUser.uid}").get();
      if (!docSnap.exists) {
        _user = User(
          userName: null,
          userNameId: null,
          email: firebaseUser.email == "" ? null : firebaseUser.email,
          id: firebaseUser.uid == "" ? null : firebaseUser.uid,
          fcm: null,
          bio: null,
          imageUrl: null,
          appVersion: 1,
          notifications: 0,
          blockedUserIds: <String>[],
          bookmarkIds: <String>[],
          docRef: docSnap.reference,
        );

        await Firestore.instance
            .document("users/${firebaseUser.uid}")
            .setData(_user.toJson());
      } else {
        _user = User(
          docRef: docSnap.reference,
          blockedUserIds: [],
          bookmarkIds: [],
        );
        _user.fromJson(docSnap.data);
      }
      // Get list of blocked users id
      // docSnap.reference.collection("blocked").getDocuments().then((qSnap) =>
      //     qSnap.documents
      //         .forEach((doc) => _user.blockedUserId.add(doc.documentID)));

      _updateFcmToken();
    }

    this.refresh();
    return;
  }

  Future asAnon() async {
    firebaseUser = await auth.asAnon();
    refresh();
  }

  _updateFcmToken() async {
    var messagingToken = await firebaseMessaging.getToken();
    _user.fcm = messagingToken;

    firestoreInstance
        .document("users/${_user.id}")
        .updateData({"fcm": messagingToken});
  }
}

class RootPage extends BaseView {
  final RootPageController controller;

  RootPage({this.controller, Key key})
      : super(
          controller: controller,
          key: key,
        );

  @override
  Widget build(BuildContext context) {
    if (!mounted) {
      return Container();
    }

    /// Force the app bar to be "white" so that the time,
    /// battery and all those symbols are rendered as black
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarColor: Colors.white));

    /// Make sure that a style is set which is
    /// also based on the dimensions of the context
    /// whom can be fetched here. The default style
    /// can only be set one during the applications
    /// lifetime so re-render of this page will not
    /// set the style every time since the style service
    /// has an internal control of that
    ServiceProvider.instance.instanceStyleService.setStandardStyle(
      ServiceProvider.instance.screenService.getPortraitHeight(context),
      ServiceProvider.instance.screenService.getBambooFactor(context),
    );

    if (!controller.introDone) {
      return Intro(
        introDone: () {
          controller.introDone = true;
          controller.refresh();
        },
      );
    } else if (controller.firebaseUser == null) {
      return LoginPage(
        controller: LoginPageController(
          rootPageController: controller,
          auth: controller.auth,
          returnUser: (returnUser) {
            if (returnUser != null) {
              controller.firebaseUser = returnUser;
              controller.refresh();
            }
            return returnUser;
          },
        ),
      );
    } else {
      return PostPage(
        controller:
            PostPageController(auth: controller.auth, user: controller._user),
      );
    }
  }
}
