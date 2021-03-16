import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_camera_crop/cubit/base-cubit.dart';
import 'package:flutter_camera_crop/widget/image-crop-widget.viewmodel.dart';

class CropImageCubit extends BaseCubit<CropImageModel> {
  CropImageCubit({CropImageModel imageModel}) : super(imageModel ??= CropImageModel());

  setCropImage({EdgeInsets insets, Size cropSize, Size imageSize, int quarterTurns, Uint8List imageByte}) {
    super.value = CropImageModel(
        insets: insets ?? value.insets,
        cropSize: cropSize ?? value.cropSize,
        quarterTurns: quarterTurns ?? value.quarterTurns,
        imageBytes: imageByte ?? value.imageBytes,
        imageSize: imageSize?? value.imageSize,
      );
  }

  EdgeInsets get insets => value.insets;

  int get quarterTurns => value.quarterTurns;
}