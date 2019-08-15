import 'package:bss/login/login_phone.dart';
import 'package:bss/objects/post.dart';
import 'package:bss/root_page.dart';
import 'package:bss/test.dart';

import './service/instance_style_service.dart';
import './service/theme_service.dart';
import 'package:firebase_analytics/firebase_analytics.dart';

import 'package:flutter/material.dart';
import './service/service_provider.dart';
import './service/screen_service.dart';
import 'new-post/post.dart';

void main() {
  ServiceProvider.instance.screenService = ScreenService();
  ServiceProvider.instance.instanceStyleService = InstanceStyleService();
  ServiceProvider.instance.themeService = ThemeService();
  runApp(App());
}

class App extends StatefulWidget {
  final RootPageController _rootController = RootPageController();
  final FirebaseAnalytics analytics = FirebaseAnalytics();

  @override
  State<StatefulWidget> createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  Widget build(BuildContext context) {
    if (!(mounted ?? false)) {
      return Container();
    }

    print('App: build');
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        // brightness: Brightness.light,
        primarySwatch: Colors.grey,
      ),
      home: RootPage(
        controller: widget._rootController,
      ),
      routes: {
        "/test": (BuildContext c) => Test(
              controller: TestController(),
            ),
        "/home": (BuildContext c) => RootPage(
              controller: widget._rootController,
            ),
        "/post": (BuildContext c) => NewPost(
              controller: NewPostController(),
            ),
        // "/phoneLogin": (BuildContext c) => PhoneLogin(
        //       controller: PhoneLoginController(),
        //     ),
      },
    );
  }
}
