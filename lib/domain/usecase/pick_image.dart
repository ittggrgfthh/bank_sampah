import 'dart:io';

import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

/// Return a [Future] of [File] or [Null]
class PickImage {
  const PickImage(this._imagePicker, this._imageCropper);

  final ImagePicker _imagePicker;
  final ImageCropper _imageCropper;

  Future<File?> call() async {
    final xfile = await _imagePicker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 1024,
      maxHeight: 1024,
    );

    if (xfile != null) {
      final croppedFile = await _imageCropper.cropImage(
        sourcePath: xfile.path,
        aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
        cropStyle: CropStyle.circle,
        uiSettings: [
          AndroidUiSettings(
            toolbarTitle: 'Foto Profil',
            lockAspectRatio: true,
          ),
          IOSUiSettings(
            title: 'Foto Profil',
            doneButtonTitle: 'Simpan',
            cancelButtonTitle: 'Batal',
            aspectRatioPickerButtonHidden: true,
            aspectRatioLockEnabled: true,
          ),
        ],
      );

      if (croppedFile == null) return null;

      return File(croppedFile.path);
    }

    return null;
  }
}
