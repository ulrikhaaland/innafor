import 'package:bss/service/service_provider.dart';
import 'package:flutter/material.dart';

class HenvendDialog extends StatefulWidget {
  final List<Widget> items;
  final String title;

  const HenvendDialog({Key key, this.items, this.title}) : super(key: key);

  @override
  _HenvendDialogState createState() => _HenvendDialogState();
}

class _HenvendDialogState extends State<HenvendDialog> {
  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
        title: Text(
          widget.title,
          style: ServiceProvider.instance.instanceStyleService.appStyle.title,
        ),
        children: widget.items);
  }
}
