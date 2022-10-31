import 'dart:io';
import 'package:flutter/material.dart';
import 'package:hozzo/theme/app-theme.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class ImagePickerService {
  final picker = ImagePicker();

  Future<File> getImageFromCamera() async {
    final pickedFile = await picker.getImage(source: ImageSource.camera, preferredCameraDevice: CameraDevice.rear);
    if (pickedFile != null) {
      return File(pickedFile.path);
    }
    return null;
  }

  Future<File> getImageFromGallary() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      return File(pickedFile.path);
    }
    return null;
  }

  getAbsoluteImage() async {
    File image = await this.getImageFromGallary();
    if (image != null) return await _cropImage(image);
  }

  _cropImage(File image) async {
    File croppedFile = await ImageCropper.cropImage(
        sourcePath: image.path,
        aspectRatioPresets: [CropAspectRatioPreset.square],
        androidUiSettings: AndroidUiSettings(
            toolbarTitle: 'Crop Profile Image',
            toolbarColor: AppColors.primary,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.square,
            backgroundColor: Colors.white,
            activeControlsWidgetColor: AppColors.primary,
            statusBarColor: AppColors.primary,

            lockAspectRatio: true));
    if (croppedFile != null) {
      return croppedFile;
    }
  }
}
