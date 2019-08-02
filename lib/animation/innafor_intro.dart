import 'package:flutter/material.dart';
import '../service/service_provider.dart';
import 'show_up.dart';
import 'dart:async';

class Intro extends StatefulWidget {
  final VoidCallback introDone;

  const Intro({Key key, this.introDone}) : super(key: key);
  @override
  _IntroState createState() => _IntroState();
}

class _IntroState extends State<Intro> {
  final int _delay = 1200;

  @override
  void initState() {
    Timer(Duration(milliseconds: _delay + 1000), () => widget.introDone());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          ServiceProvider.instance.instanceStyleService.appStyle.caribbeanGreen,
      body: Center(
          child: ShowUp(
        delay: _delay,
        child: Text(
          "HENVEND",
          style: TextStyle(
              fontFamily: "Asap",
              color: ServiceProvider
                  .instance.instanceStyleService.appStyle.lightYellow,
              fontSize: 50),
        ),
      )),
    );
  }
}
