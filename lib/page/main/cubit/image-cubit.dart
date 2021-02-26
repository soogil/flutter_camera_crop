import 'package:flutter_camera_crop/cubit/base-cubit.dart';


class CameraImageCubit extends BaseCubit<String> {
  CameraImageCubit() : super(null);

  set imagePath(String path) => super.value = path;
  get imagePath => super.value;
}