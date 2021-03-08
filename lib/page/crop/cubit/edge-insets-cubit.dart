import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_camera_crop/cubit/base-cubit.dart';
import 'package:flutter_camera_crop/widget/image-crop-widget.viewmodel.dart';

class CropImageCubit extends BaseCubit<CropImageModel> {
  CropImageCubit({CropImageModel imageModel}) : super(imageModel ??= CropImageModel());

  setModel({EdgeInsets insets, Size size, int quarterTurns, Uint8List imageByte}) =>
      super.value = CropImageModel(
        insets: insets ?? value.insets,
        size: size ?? value.size,
        quarterTurns: quarterTurns ?? value.quarterTurns,
        imageBytes: imageByte ?? value.imageBytes,
      );
}