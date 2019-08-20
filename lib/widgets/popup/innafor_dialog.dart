import 'package:innafor/service/service_provider.dart';
import 'package:flutter/material.dart';

class InnaforDialog extends StatefulWidget {
  final List<Widget> items;
  final String title;

  const InnaforDialog({Key key, this.items, this.title}) : super(key: key);

  @override
  _InnaforDialogState createState() => _InnaforDialogState();
}

class _InnaforDialogState extends State<InnaforDialog> {
  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
        contentPadding: EdgeInsets.only(
          top: 12,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        title: Text(
          widget.title ?? "N/A",
          style: ServiceProvider
              .instance.instanceStyleService.appStyle.secondaryTitle,
          textAlign: TextAlign.center,
        ),
        children: widget.items);
  }
}
