import 'package:flutter/material.dart';
import 'package:flutter_camera_crop/cubit/base-cubit.dart';


class CropImageCubit extends BaseCubit<EdgeInsets> {
  CropImageCubit({EdgeInsets insets = const EdgeInsets.all(20)}) : super(insets);

  EdgeInsets get insets => super.value;

  set insets(EdgeInsets value) => super.value = value;

  double get insetsTop => super.value.top;

  double get insetsLeft => super.value.left;

  double get insetsRight => super.value.right;

  double get insetsBottom => super.value.bottom;
}
