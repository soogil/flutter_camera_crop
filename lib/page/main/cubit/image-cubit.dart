import 'package:flutter_bloc/flutter_bloc.dart';


class CameraImageCubit extends Cubit<String> {
  CameraImageCubit() : super(null);

  void setImagePath(String imagePath) => emit(imagePath);
  String getImagePath() => state;
}