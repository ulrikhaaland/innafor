import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

class FileProvider {
  Future<File> getFile() async {
    File _image;
    _image = await ImagePicker.pickImage(source: ImageSource.gallery);
    return _image;
  }

  Future<dynamic> uploadFile({File file, String path}) async {
    if (file != null) {
      StorageReference ref = FirebaseStorage.instance.ref().child(path);
      StorageUploadTask uploadTask = ref.putFile(file);
      return await (await uploadTask.onComplete).ref.getDownloadURL();
    }
  }
}
