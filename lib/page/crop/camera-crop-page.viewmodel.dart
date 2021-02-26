import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_camera_crop/util/image-util.dart';
import 'package:flutter_camera_crop/widget/Image-crop.widget.dart';


class CameraCropPageViewModel {

 CameraCropPageViewModel(dynamic params)
     : _imagePath = params['imagePath'],
       _imageBytes = params['imageBytes'],
       _prevPhoto = params['isPhoto'] {

   _loadCropData = _getCropDatas();
   _appbarHeight = _appbarHeight ?? 70;

   // SystemChromeService.setDelayedLightStatusBarText(milliseconds: 350);
 }

 static const double MIN_LOW_QUALITY_SIZE = 600;

 final GlobalKey cropViewKey = GlobalKey();

 List<int> _imageBytes;
 Future _loadCropData;
 ImageCropWidget _imageCropWidget;

 String _lowQualityMessage = "";
 String _imagePath;
 double _appbarHeight;
 int _imageWidth = 0;
 int _imageHeight = 0;
 bool _prevPhoto;

 Future<void> _getCropDatas() async {
   Completer completer = Completer();

   if(_imageBytes == null) {
//      AlbumService.getAlbumOriginal(
//          _imagePath, _imagePath, CommonConstants.PHOTO_MIN_SIZE,
//          CommonConstants.IMAGE_QUALITY, isPhoto: _prevPhoto,
//          callback: (_, __, ByteData byteData) {
//            if (byteData.buffer == null) {
//
//            } else {
//              _imageBytes = byteData.buffer.asUint8List();
//              _setCrop();
//              completer.complete();
//            }
//          }
//      );
   } else {
     _setCrop();
     completer.complete();
   }

   return completer.future;
 }

 _setCrop(){
   _imageCropWidget = ImageCropWidget.fromBytes(_imageBytes,
     onPanGestureEndCallback: _onPanEnded,);

   if (_imageWidth == 0 && _imageHeight == 0) {
     getImageSize(_imageBytes).then((size) {
       _imageWidth = size[0].toInt();
       _imageHeight = size[1].toInt();
     });
   }
 }

 _onPanEnded(Size cropSize, Size viewSize) {
   setLowQualityMessage();
 }

 onBackButtonPressed(BuildContext context) {
   Navigator.pop(context);
   // RouteService.pop(context);
   // SystemChromeService.setDarkStatusBarText();
 }

 onRotateButtonPressed() {
   _imageCropWidget.rotateImageWidget().then((_){
     setLowQualityMessage();
   });
 }

 onOkButtonPressed(BuildContext context) {
   // if (_imageCropWidget.isShortFall) {
   //   AbstractDialog.show(context, AlertCommonDialog(
   //     StringConstants.map[StringKeys.CAMERACROP_FAIL_CROP],
   //   ));
   //   return;
   // }
   //
   // final cropBaseData = _imageCropWidget.getCropBaseData();
   //
   // LogService.d('cropBaseData.size:  ${cropBaseData.size.height}, ${cropBaseData.size.width} ');

//    WisePlugin.cropImageWithBytes(
//        bytes: _imageBytes,
//        rawSize: cropBaseData.size,
//        area: cropBaseData.rect,
//        scale: 0.1,
//        angle: cropBaseData.angle
//    ).then((imageBytes) {
//      RouteService.pop(context, {
//        'previewHeight': cropBaseData.rect.size.height,
//        'imageBytes': imageBytes,
//        'imagePath': _imagePath,
//      });
//    });
 }

 setLowQualityMessage() {
   Size viewSize = _imageCropWidget.viewAreaSize;
   Size cropSize = _imageCropWidget.cropAreaSize;

   int calcImageWidth = _imageCropWidget.turnAngle == 1 ? _imageWidth : _imageHeight;
   int calcImageHeight = _imageCropWidget.turnAngle == 1 ? _imageHeight : _imageWidth;

   double ratioW = calcImageWidth / viewSize.width;
   double ratioH = calcImageHeight / viewSize.height;
   double realWidth = cropSize.width * ratioW;
   double realHeight = cropSize.height * ratioH;

   if (realWidth * realHeight < MIN_LOW_QUALITY_SIZE * MIN_LOW_QUALITY_SIZE) {
     _lowQualityMessage = '화질구지입니다.';
   }
   else {
     _lowQualityMessage = "";
   }

   // notifyListeners();
 }

 double get appbarHeight => _appbarHeight;

 String get lowQualityMessage => _lowQualityMessage;

 Widget get imageCropWidget => _imageCropWidget;

 Future get loadCropData => _loadCropData;
}

