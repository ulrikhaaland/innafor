import 'dart:math';

import 'package:bss/post/post_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'animation/innafor_intro.dart';
import 'auth.dart';
import 'intro/user_intro.dart';
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
}

class RootPageController extends BaseController {
  final BaseAuth _auth = Auth();

  Firestore firestoreInstance = Firestore.instance;
  FirebaseMessaging firebaseMessaging = FirebaseMessaging();

  FirebaseUser _firebaseUser;

  User _user;
  bool introDone = false;
  bool _userIntro = true;

  void _getUser() async {
    // _firebaseUser = await _auth.currentUser();

    // DocumentSnapshot docSnap =
    //     await Firestore.instance.document("users/${_firebaseUser.uid}").get();
    // if (docSnap.exists) {
    //   _userIntro = false;
    // } else {
    //   _userIntro = true;
    //   Firestore.instance.document("users/${_firebaseUser.uid}").setData({
    //     "id": _firebaseUser.uid,
    //   });
    // }
    // _updateFcmToken();
    _user = User(
      id: Random().nextInt(3100).toString(),
      userName: "",
      email: "",
      bio: "",
      appVersion: 1,
      expertId: [],
    );
    refresh();
  }

  _updateFcmToken() async {
    var messagingToken = await firebaseMessaging.getToken();
    _user.fcm = messagingToken;
    firestoreInstance.document("users/${_user.id}").get().then((doc) {
      if (doc.data["fcm"] != messagingToken) {
        firestoreInstance
            .document("users/${_user.id}")
            .updateData({"fcm": messagingToken});
      }
    });
  }

  @override
  void initState() {
    print('RootPage: initState');
    _getUser();

    super.initState();
  }

  @override
  void dispose() {
    print('RootPage: dispose');
    super.dispose();
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

    // return Test(
    //   controller: TestController(),
    // );

    if (!controller.introDone) {
      return Intro(
        introDone: () {
          controller.introDone = true;
          controller.refresh();
        },
      );
    }
    // else if (controller._firebaseUser == null) {
    //   return LoginPage(
    //     auth: controller._auth,
    //     userFound: () => controller._getUser(),
    //   );
    // } else if (controller._userIntro) {
    //   return UserIntro(
    //     controller: UserIntroController(
    //         onIntroFinished: () {
    //           controller._userIntro = false;
    //           controller.refresh();
    //         },
    //         user: controller._user),
    //   );
    // }
    else {
      return PostPage(
        controller: PostPageController(
          auth: controller._auth,
        ),
      );
    }
  }
}
