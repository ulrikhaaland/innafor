import 'dart:io';

import 'package:bss/base_controller.dart';
import 'package:bss/base_view.dart';
import 'package:bss/presentation/uploader.dart';
import 'package:bss/service/screen_service.dart';
import 'package:bss/service/service_provider.dart';
import 'package:bss/utilities/master_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/widgets.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class PostController extends BaseController {}

class Post extends BaseView {
  final PostController controller;

  File _imageFile;

  /// Cropper plugin
  Future<void> _cropImage() async {
    File cropped = await ImageCropper.cropImage(
        sourcePath: _imageFile.path,
        ratioX: 0.6,
        ratioY: 1.0,
        // maxWidth: 512,
        // maxHeight: 512,
        toolbarColor: Colors.purple,
        toolbarWidgetColor: Colors.white,
        toolbarTitle: 'Crop It');

    _imageFile = cropped ?? _imageFile;
    controller.refresh();
  }

  /// Select an image via gallery or camera
  Future<void> _pickImage(ImageSource source) async {
    File selected = await ImagePicker.pickImage(source: source);

    _imageFile = selected;
    controller.refresh();
  }

  /// Remove image
  void _clear() {
    _imageFile = null;
    controller.refresh();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Select an image from the camera or gallery
      bottomNavigationBar: BottomAppBar(
        child: Row(
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.photo_camera),
              onPressed: () => _pickImage(ImageSource.camera),
            ),
            IconButton(
              icon: Icon(Icons.photo_library),
              onPressed: () => _pickImage(ImageSource.gallery),
            ),
          ],
        ),
      ),

      // Preview the image and crop it
      body: ListView(
        children: <Widget>[
          if (_imageFile != null) ...[
            Image.file(_imageFile),
            Row(
              children: <Widget>[
                FlatButton(
                  child: Icon(Icons.crop),
                  onPressed: _cropImage,
                ),
                FlatButton(
                  child: Icon(Icons.refresh),
                  onPressed: _clear,
                ),
              ],
            ),
            Uploader(file: _imageFile)
          ]
        ],
      ),
    );
  }

  Post({this.controller});
  @override
  Widget buildContentLandscape(
      BuildContext context, ScreenSizeDefinition screenSizeDefinition) {
    // TODO: implement buildContentLandscape
    return null;
  }

  @override
  Widget buildContentPortrait(
      BuildContext context, ScreenSizeDefinition screenSizeDefinition) {
    return Scaffold(
      body: Center(
        child: IconButton(
          icon: Icon(Icons.camera),
          onPressed: null,
        ),
      ),
    );
  }

  // @override
  // Widget build(BuildContext context) {
  //   ScreenSizeDefinition screenSizeDefinition =
  //       ServiceProvider.instance.screenService.getScreenSizeDefinition(context);

  //   if (screenSizeDefinition == ScreenSizeDefinition.big) {
  //     return buildContentLandscape(context, screenSizeDefinition);
  //   } else {
  //     return buildContentPortrait(context, screenSizeDefinition);
  //   }
  // }
}
