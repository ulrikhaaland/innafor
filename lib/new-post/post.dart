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
import 'package:video_player/video_player.dart';

class NewPostController extends BaseController {
  VideoPlayerController _videoController;

  File _imageFile;

  bool video = true;

  @override
  void initState() {
    super.initState();
  }

  /// Cropper plugin
  Future<void> _cropImage() async {
    File cropped = await ImageCropper.cropImage(
        sourcePath: _imageFile.path,
        ratioX: 0.65,
        ratioY: 1.0,
        // maxWidth: 512,
        // maxHeight: 512,
        toolbarColor: Colors.purple,
        toolbarWidgetColor: Colors.white,
        toolbarTitle: 'Crop It');

    _imageFile = cropped ?? _imageFile;
    refresh();
  }

  Future<void> _pickImage(ImageSource source) async {
    video = false;
    File selected = await ImagePicker.pickImage(source: source);

    _imageFile = selected;
    refresh();
  }

  Future<void> _pickVideo(ImageSource source) async {
    video = true;
    File selected = await ImagePicker.pickVideo(source: source);

    _imageFile = selected;
    _videoController = VideoPlayerController.file(_imageFile);
    _videoController.initialize();
    refresh();
  }

  /// Remove image
  void _clear() {
    _imageFile = null;
    refresh();
  }
}

class NewPost extends BaseView {
  final NewPostController controller;

  NewPost({this.controller});

  @override
  Widget build(BuildContext context) {
    if (!mounted) return Container();

    return Scaffold(
      bottomNavigationBar: BottomAppBar(
        child: Row(
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.photo_camera),
              onPressed: () => controller._pickImage(ImageSource.camera),
            ),
            IconButton(
              icon: Icon(Icons.photo_library),
              onPressed: () => controller._pickImage(ImageSource.gallery),
            ),
            IconButton(
              icon: Icon(Icons.video_library),
              onPressed: () => controller._pickVideo(ImageSource.gallery),
            ),
          ],
        ),
      ),

      // Preview the image and crop it
      body: ListView(
        children: <Widget>[
          if (controller._imageFile != null) ...[
            controller.video
                ? controller._videoController.value.initialized
                    ? AspectRatio(
                        aspectRatio:
                            controller._videoController.value.aspectRatio,
                        child: VideoPlayer(controller._videoController),
                      )
                    : Text("data")
                : Image.file(controller._imageFile),
            Row(
              children: <Widget>[
                FlatButton(
                  child: Icon(Icons.crop),
                  onPressed: controller._cropImage,
                ),
                FlatButton(
                  child: Icon(Icons.refresh),
                  onPressed: controller._clear,
                ),
              ],
            ),
            Uploader(file: controller._imageFile)
          ]
        ],
      ),
    );
  }

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
}
