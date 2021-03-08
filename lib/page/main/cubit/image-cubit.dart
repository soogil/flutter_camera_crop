import 'dart:typed_data';

import 'package:flutter_camera_crop/cubit/base-cubit.dart';


class CameraImageCubit extends BaseCubit<Uint8List> {
  CameraImageCubit() : super(null);

  set imageBytes(Uint8List bytes) => super.value = bytes;
  get imageBytes => super.value;
}