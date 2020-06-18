import 'dart:io';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:zouqadmin/I10n/app_localizations.dart';

File selectedImg;
ImageSource imageSource;

getImageSource(BuildContext context) async {
  imageSource = await showDialog<ImageSource>(
      context: context,
      builder: (context) => AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(15))),
            title: Text(
                AppLocalizations.of(context).translate('imaPickerDialogTitle')),
            actions: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  MaterialButton(
                    child: Row(
                      children: <Widget>[
                        Icon(Icons.camera_alt),
                        Text(AppLocalizations.of(context).translate('camera')),
                      ],
                    ),
                    onPressed: () => Navigator.pop(context, ImageSource.camera),
                  ),
                  MaterialButton(
                    child: Row(
                      children: <Widget>[
                        Icon(Icons.photo),
                        Text(AppLocalizations.of(context).translate('gallery')),
                      ],
                    ),
                    onPressed: () =>
                        Navigator.pop(context, ImageSource.gallery),
                  )
                ],
              ),
            ],
          ));
}

Future <File> getImage(ImageSource src) async {
  File selectedImg = await ImagePicker.pickImage(source: src);
  selectedImg = await ImageCropper.cropImage(
      sourcePath: selectedImg.path,
      aspectRatioPresets: [
        CropAspectRatioPreset.square,
        CropAspectRatioPreset.ratio3x2,
        CropAspectRatioPreset.original,
        CropAspectRatioPreset.ratio4x3,
        CropAspectRatioPreset.ratio16x9
      ],
      androidUiSettings: AndroidUiSettings(
          toolbarColor: Colors.blue,
          activeControlsWidgetColor: Colors.blue,
          toolbarWidgetColor: Colors.white,
          initAspectRatio: CropAspectRatioPreset.original,
          lockAspectRatio: false),
      iosUiSettings: IOSUiSettings(
        minimumAspectRatio: 1.0,
      ));
  return selectedImg;
}

 selectImg(BuildContext context) async {
  File file;
  await getImageSource(context);
  file = await getImage(imageSource);
  return file;
}

Future<Position> getCurrentLocation() async {
  Position position = await Geolocator()
      .getCurrentPosition(desiredAccuracy: LocationAccuracy.medium);
  return position;
}

////////////////////////////////////////////////
/// Page Navigation pages
////////////////////////////////////////////////

void popPage(BuildContext context) {
  Navigator.of(context).pop();
}

void pushPage(BuildContext context, Widget widget) {
  Navigator.push(context, MaterialPageRoute(builder: (context) => widget));
}

void pushPageReplacement(BuildContext context, Widget widget) {
  Navigator.pushReplacement(
      context, MaterialPageRoute(builder: (context) => widget));
}

////////////////////////////////////////////////
///
////////////////////////////////////////////////
