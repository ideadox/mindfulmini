import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:go_router/go_router.dart';

import '../../../injection/injection.dart';
import '../../../services/image_picker_helper.dart';
import '../../../services/upload_file_service.dart';
import '../profile_data/profile_data.dart';

class EditImageProvider with ChangeNotifier {
  final _imageHelper = sl<ImagePickerHelper>();
  final _uploadImage = sl<UploadFileService>();
  final _profileData = sl<ProfileData>();
  final _navigationService = sl<GoRouter>();

  late String profileId;

  EditImageProvider(this.profileId);

  File? imageFile;
  void pickImage({String type = 'lib'}) async {
    if (type == 'lib') {
      imageFile = await _imageHelper.pickFromGallery();
    } else {
      imageFile = await _imageHelper.pickFromCamera();
    }
    notifyListeners();
  }

  void changeImage() {
    imageFile = null;
    notifyListeners();
  }

  void uploadImage() async {
    try {
      SmartDialog.showLoading();
      final urlKey = await _uploadImage.uploadFile(imageFile!);
      if (urlKey == null) {
        SmartDialog.showToast('Something went wrong please try again');
        return;
      }
      await _profileData.editImage(
        profileId,
        'https://minfulminis.s3.eu-north-1.amazonaws.com/$urlKey',
      );
      _navigationService.pop(true);
    } catch (e) {
      SmartDialog.showToast(e.toString());
    } finally {
      SmartDialog.dismiss();
    }
  }

  void removeImage() async {
    try {
      SmartDialog.showLoading();
      await _profileData.editImage(profileId, '');
      _navigationService.pop(true);
    } catch (e) {
      SmartDialog.showToast(e.toString());
    } finally {
      SmartDialog.dismiss();
    }
  }
}
