import 'package:innafor/helper/helper.dart';
import 'package:innafor/service/service_provider.dart';
import 'package:flutter/material.dart';

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
  bool validate;
  final bool autoFocus;
  final bool obscure;
  final bool autocorrect;

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
      this.autoFocus,
      this.obscure,
      this.autocorrect})
      : super(key: key);

  _PrimaryTextFieldState createState() => _PrimaryTextFieldState();
}

class _PrimaryTextFieldState extends State<PrimaryTextField> {
  @override
  Widget build(BuildContext context) {
    widget.validate == null ? widget.validate = true : null;
    return Container(
      width: ServiceProvider.instance.screenService
          .getWidthByPercentage(context, 80),
      child: Padding(
        padding: EdgeInsets.only(
            top: widget.paddingTop ?? 0,
            bottom: widget.paddingBottom ?? getDefaultPadding(context) * 2),
        child: TextFormField(
          autocorrect: widget.autocorrect ?? false,
          obscureText: widget.obscure ?? false,
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
              ServiceProvider.instance.instanceStyleService.appStyle.imperial,
          style: widget.style ??
              ServiceProvider.instance.instanceStyleService.appStyle.body1Black,
          validator: widget.validate
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
                ServiceProvider
                    .instance.instanceStyleService.appStyle.body1Black,
            counterStyle:
                TextStyle(color: Colors.red, fontFamily: "Montserrat"),
            enabledBorder: new UnderlineInputBorder(
                borderSide: new BorderSide(
              color: ServiceProvider
                  .instance.instanceStyleService.appStyle.imperial,
            )),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                width: 2,
                color: ServiceProvider
                    .instance.instanceStyleService.appStyle.imperial,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
