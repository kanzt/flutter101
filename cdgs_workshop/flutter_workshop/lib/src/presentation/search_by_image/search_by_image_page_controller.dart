import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class SearchByImagePageController extends GetxController {
  File? image;
  final picker = ImagePicker();

  ///Image Picker function to get image from gallery
  Future getImageFromGallery() async {
    try {
      final pickedFile = await picker.pickImage(source: ImageSource.gallery);

      if (pickedFile != null) {
        image = File(pickedFile.path);
        update();
      }
    } on PlatformException catch (e) {
      if (kDebugMode) {
        print('Failed to pick image: $e');
      }
    }
  }

  ///Image Picker function to get image from camera
  Future getImageFromCamera() async {
    try {
      final pickedFile = await picker.pickImage(source: ImageSource.camera);

      if (pickedFile != null) {
        image = File(pickedFile.path);
        update();
      }
    } on PlatformException catch (e) {
      if (kDebugMode) {
        print('Failed to pick image: $e');
      }
    }
  }
}
