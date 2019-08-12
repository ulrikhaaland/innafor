import 'package:flutter/material.dart';

class PostImageTabBar extends StatefulWidget {
  final int length;
  final double imageWidth;
  PostImageTabBar({Key key, this.length, this.imageWidth}) : super(key: key);

  _PostImageTabBarState createState() => _PostImageTabBarState();
}

class _PostImageTabBarState extends State<PostImageTabBar>
    with TickerProviderStateMixin {
  TabController _tabController;

  List<Widget> emptyContainers;

  @override
  void initState() {
    _tabController = TabController(
      vsync: this,
      length: widget.length,
    );
    emptyContainers = <Widget>[];
    for (var i = 0; i < widget.length; i++) {
      emptyContainers.add(Container(
        height: 0,
        width: 0,
      ));
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.imageWidth,
      child: TabBar(
        indicatorColor: Colors.white,
        indicatorWeight: 4,
        controller: _tabController,
        tabs: emptyContainers,
      ),
    );
  }
}
