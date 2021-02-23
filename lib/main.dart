import 'package:flutter/material.dart';
import 'package:flutter_camera_crop/app/crop_app.dart';
import 'package:flutter_camera_crop/service/camera-service.dart';


void main() {
  WidgetsFlutterBinding.ensureInitialized();
  CameraService().init();

  runApp(CropApp());
}
