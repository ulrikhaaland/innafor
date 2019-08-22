import 'package:flutter_advanced_networkimage/provider.dart';
import 'package:innafor/post/post_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
import 'package:innafor/post/post-comment/post_comment.dart';

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

  Future<Null> getUser() async {
    _firebaseUser = await _auth.currentUser();
    if (_firebaseUser != null) {
      DocumentSnapshot docSnap =
          await Firestore.instance.document("users/${_firebaseUser.uid}").get();
      if (!docSnap.exists) {
        _user = User(
          email: _firebaseUser.email,
          id: _firebaseUser.uid,
          fcm: null,
          bio: null,
          imageUrl: null,
          appVersion: 1,
          notifications: 0,
          blockedUserId: <String>[],
          docRef: docSnap.reference,
        );

        await Firestore.instance
            .document("users/${_firebaseUser.uid}")
            .setData(_user.toJson());
      } else {
        _user = User(
          docRef: docSnap.reference,
        );
        _user.fromJson(docSnap.data);
      }
      // Get list of blocked users id
      docSnap.reference.collection("blocked").getDocuments().then((qSnap) =>
          qSnap.documents
              .forEach((doc) => _user.blockedUserId.add(doc.documentID)));

      _updateFcmToken();
    }

    // _user = User(
    //   id: Random().nextInt(3100).toString(),
    //   userName: "",
    //   email: "",
    //   bio: "",
    //   appVersion: 1,
    //   expertId: [],
    // );
    refresh();
    return;
  }

  _updateFcmToken() async {
    var messagingToken = await firebaseMessaging.getToken();
    _user.fcm = messagingToken;

    firestoreInstance
        .document("users/${_user.id}")
        .updateData({"fcm": messagingToken});
  }

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
    } else if (controller._firebaseUser == null) {
      return LoginPage(
        controller: LoginPageController(
          rootPageController: controller,
          auth: controller._auth,
          returnUser: (returnUser) {
            if (returnUser != null) {
              controller._firebaseUser = returnUser;
              controller.refresh();
            }
            return returnUser;
          },
        ),
      );
    } else {
      return Provider.value(
        value: controller._user,
        child: PostPage(
          controller: PostPageController(
            auth: controller._auth,
          ),
        ),
      );
    }
  }
}
