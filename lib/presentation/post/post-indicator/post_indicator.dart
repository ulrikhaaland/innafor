import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:innafor/model/user.dart';
import 'package:innafor/service/service_provider.dart';
import 'package:provider/provider.dart';

class PostIndicator extends StatelessWidget {
  final String postId;

  bool hasMoved = false;

  double value;

  final VoidCallback onDone;

  PostIndicator({Key key, this.postId, this.onDone}) : super(key: key);

  void timer() {
    Timer(Duration(seconds: 5), () => hasMoved = false);
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: Firestore.instance.collection('post/$postId/reviews').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Container();
        }
        if (!hasMoved) {
          value = 0;
          snapshot.data.documents.forEach((doc) {
            value += doc.data["value"];
          });
        }

        return Container(
          width: ServiceProvider.instance.screenService
              .getWidthByPercentage(context, 100),
          child: InnaforSlider(
            hasMoved: hasMoved,
            onDone: () {
              User user = Provider.of<User>(context);
              Firestore.instance
                  .document("post/$postId/reviews/${user.id}")
                  .setData({
                "uid": user.id,
                "value": value,
                "timestamp": DateTime.now(),
              });
            },
            moved: (val) {
              value = val;
              hasMoved = true;
              timer();
            },
            value: hasMoved ? value : value / snapshot.data.documents.length,
          ),
        );
      },
    );
  }
}

class InnaforSlider extends StatefulWidget {
  double value;

  final void Function(double val) moved;

  final VoidCallback onDone;

  bool hasMoved;

  InnaforSlider({Key key, this.value, this.moved, this.hasMoved, this.onDone})
      : super(key: key);
  @override
  _InnaforSliderState createState() => _InnaforSliderState();
}

class _InnaforSliderState extends State<InnaforSlider> {
  @override
  Widget build(BuildContext context) {
    return Slider(
      onChangeEnd: (val) => widget.onDone(),
      divisions: 50,
      activeColor: widget.hasMoved
          ? ServiceProvider
              .instance.instanceStyleService.appStyle.mountbattenPink
          : ServiceProvider.instance.instanceStyleService.appStyle.textGrey,
      max: 5,
      value: widget.value,
      onChanged: (val) => setState(() {
        widget.hasMoved = true;
        widget.moved(val);
        widget.value = val;
      }),
      label: widget.value.toString().substring(0, 3),
    );
  }
}
