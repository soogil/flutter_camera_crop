import 'dart:math';

import 'package:flutter/material.dart';


class ImageCropWidgetViewModel {

  ImageCropWidgetViewModel(int angle) {
    _quarterTurns = angle ~/ 90;
  }

  final GlobalKey _cropAreaKey = GlobalKey();
  final GlobalKey _imageContainerKey = GlobalKey();
  
  final Color cropEdgeColor = const Color.fromRGBO(255, 255, 255, 0.7);
  final Color cropEdgeHandleColor = Colors.transparent;
  final double cropMinimumSize = 150;
  final double cropEdgeSize = 28;
  final double cropEdgeBorderWidth = 4;
  final double cropHandleSize = 60;

  int _quarterTurns;
  
  Offset getCalcPadding({
    double px,
    double py,
    double offsetX,
    double offsetY,
    double dragDx,
    double dragDy
  }) {
    double paddingX = 0.0;
    double paddingY = 0.0;

    if (cropSize.width - dragDx < cropMinimumSize) {
      paddingX = max(imageSize.width - offsetX - cropMinimumSize, 0);
    } else {
      paddingX = max(px + dragDx * 2, 0);
    }

    if (cropSize.height - dragDy < cropMinimumSize) {
      paddingY = max(imageSize.height - offsetY - cropMinimumSize, 0);
    } else {
      paddingY = max(py + dragDy * 2, 0);
    }

    return Offset(paddingX, paddingY);
  }
  
  rotateImageWidget({EdgeInsets insets: const EdgeInsets.all(30)}) async {
    // rotate image
  }

  int get quarterTurns => _quarterTurns;

  GlobalKey get cropAreaKey => _cropAreaKey;

  GlobalKey get imageContainerKey => _imageContainerKey;

  Size get cropSize => _cropAreaKey.currentContext.size;
  
  Size get imageSize => _imageContainerKey.currentContext.size;
}