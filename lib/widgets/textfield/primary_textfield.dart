import 'package:bss/service/service_provider.dart';
import 'package:flutter/material.dart';

import '../../helper.dart';

class PrimaryTextField extends StatefulWidget {
  final String initValue;
  final FocusNode focusNode;
  final VoidCallback onFieldSubmitted;
  final Function(String val) onSaved;
  final String labelText;
  final String helperText;
  final String hintText;
  final TextStyle helperStyle;
  final TextStyle labelStyle;
  final TextStyle style;
  final TextCapitalization textCapitalization;
  final TextInputAction textInputAction;
  final TextInputType textInputType;
  final Color cursorColor;
  final double paddingTop;
  final double paddingBottom;
  final TextEditingController textEditingController;
  final int maxLines;
  final bool validate;
  final bool autoFocus;

  PrimaryTextField(
      {Key key,
      this.initValue,
      this.focusNode,
      this.onFieldSubmitted,
      this.onSaved,
      this.labelText,
      this.helperText,
      this.helperStyle,
      this.labelStyle,
      this.style,
      this.textCapitalization,
      this.textInputAction,
      this.textInputType,
      this.cursorColor,
      this.paddingTop,
      this.paddingBottom,
      this.textEditingController,
      this.maxLines,
      this.hintText,
      this.validate,
      this.autoFocus})
      : super(key: key);

  _PrimaryTextFieldState createState() => _PrimaryTextFieldState();
}

class _PrimaryTextFieldState extends State<PrimaryTextField> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
          top: widget.paddingTop ?? 0,
          bottom: widget.paddingBottom ?? getDefaultPadding(context) * 2),
      child: TextFormField(
        autofocus: widget.autoFocus ?? false,
        controller: widget.textEditingController,
        textCapitalization:
            widget.textCapitalization ?? TextCapitalization.words,
        initialValue: widget.textEditingController != null
            ? null
            : widget.initValue ?? "",
        maxLines: widget.maxLines ?? 1,
        focusNode: widget.focusNode,
        textInputAction: widget.textInputAction ?? TextInputAction.next,
        cursorRadius: Radius.circular(1),
        keyboardType: widget.textInputType ?? TextInputType.text,
        cursorColor: widget.cursorColor ??
            ServiceProvider.instance.instanceStyleService.appStyle.sunGlow,
        style: widget.style ??
            ServiceProvider.instance.instanceStyleService.appStyle.body1Black,
        validator: widget.validate == null
            ? (val) => val.isEmpty ? "Feltet kan ikke være tomt" : null
            : null,
        onSaved: (val) =>
            widget.textEditingController == null ? widget.onSaved(val) : null,
        onFieldSubmitted: (val) => widget.onFieldSubmitted(),
        decoration: InputDecoration(
          hintText: widget.hintText ?? null,
          labelText: widget.labelText ?? null,
          helperText: widget.helperText ?? null,
          helperStyle: widget.helperStyle ??
              ServiceProvider.instance.instanceStyleService.appStyle.italic,
          labelStyle: widget.labelStyle ??
              ServiceProvider.instance.instanceStyleService.appStyle.body1,
          counterStyle: TextStyle(color: Colors.red),
          enabledBorder: new UnderlineInputBorder(
              borderSide: new BorderSide(
            color:
                ServiceProvider.instance.instanceStyleService.appStyle.sunGlow,
          )),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              color: ServiceProvider
                  .instance.instanceStyleService.appStyle.sunGlow,
            ),
          ),
        ),
      ),
    );
  }
}
