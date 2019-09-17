import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:innafor/service/service_provider.dart';

class PostIndicator extends StatelessWidget {
  final String postId;

  bool hasMoved = false;

  double value;

  PostIndicator({Key key, this.postId}) : super(key: key);

  void timer() {
    Timer(Duration(seconds: 5), () => hasMoved = false);
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: Firestore.instance.collection('post/$postId/reviews').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Text("Loading..");
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

  bool hasMoved;

  InnaforSlider({Key key, this.value, this.moved, this.hasMoved})
      : super(key: key);
  @override
  _InnaforSliderState createState() => _InnaforSliderState();
}

class _InnaforSliderState extends State<InnaforSlider> {
  @override
  Widget build(BuildContext context) {
    return Slider(
      divisions: 10,
      activeColor: widget.hasMoved
          ? ServiceProvider.instance.instanceStyleService.appStyle.imperial
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
