import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/material.dart';


class ImageCropWidgetViewModel {
  ImageCropWidgetViewModel() : quarterTurns = 0;
  final GlobalKey _cropAreaKey = GlobalKey();
  final GlobalKey _imageContainerKey = GlobalKey();

  final Color cropEdgeColor = const Color.fromRGBO(255, 255, 255, 0.7);
  final Color cropEdgeHandleColor = Colors.transparent;
  final double cropMinimumSize = 150;
  final double cropEdgeSize = 28;
  final double cropEdgeBorderWidth = 4;
  final double cropHandleSize = 60;

  int quarterTurns;

  Offset getCalcPadding({
    double px,
    double py,
    double offsetX,
    double offsetY,
    double dragDx,
    double dragDy,
  }) {
    double paddingX = 0.0;
    double paddingY = 0.0;
    final cropSize = getCropSize();
    final imageSize = getImageSize();

    if (cropSize.width - dragDx < cropMinimumSize) {
      paddingX = max(imageSize.width - offsetX - cropMinimumSize, 0);
    } else {
      paddingX = max(px + dragDx, 0);
    }

    if (cropSize.height - dragDy < cropMinimumSize) {
      paddingY = max(imageSize.height - offsetY - cropMinimumSize, 0);
    } else {
      paddingY = max(py + dragDy, 0);
    }
    return Offset(paddingX, paddingY);
  }

  bool get isHorizontal => quarterTurns % 2 == 1;

  GlobalKey get cropAreaKey => _cropAreaKey;

  GlobalKey get imageContainerKey => _imageContainerKey;

  Size get originCropSize => _cropAreaKey.currentContext.size;

  Size getCropSize() =>_cropAreaKey.currentContext.size;

  Size get originImageSize => _imageContainerKey.currentContext.size;

  Size getImageSize() => Size(
    isHorizontal ? originImageSize.height : originImageSize.width,
    isHorizontal ? originImageSize.width : originImageSize.height,
  );
}

class CropImageModel {
  CropImageModel({
    this.imageSize,
    this.imageBytes,
    this.insets = const EdgeInsets.all(20),
    this.cropSize,
    this.quarterTurns = 0,
  });

  Uint8List imageBytes;
  int quarterTurns;
  EdgeInsets insets;
  Size imageSize;
  Size cropSize;

  Rect get rect => Rect.fromLTWH(
      insets.left,
      insets.top,
      cropSize.width,
      cropSize.height
  );
  bool get horizontal => quarterTurns % 2 == 1;
  int get angle => quarterTurns * 90 + 90;
}