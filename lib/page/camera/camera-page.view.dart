import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:flutter_camera_crop/service/camera-service.dart';


class CameraPageView extends StatelessWidget {

  CameraPageView() {
    _cameraController = CameraService().cameraController;
    _initCamera = CameraService().initCamera;
  }

  CameraController _cameraController;
  Future _initCamera;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _getBody(context),
    );
  }

  _getBody(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        _getCameraView(),
        _getCameraCaptureButton(context),
      ],
    );
  }

  _getCameraView() {
    return FutureBuilder(
        future: _initCamera,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return CameraPreview(_cameraController);
          } else {
            return CircularProgressIndicator();
          }
        });
  }

  _getCameraCaptureButton(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        padding: EdgeInsets.only(
          bottom: 10,
        ),
        child: FloatingActionButton(
          onPressed: () async {
            await _cameraController.takePicture().then((value) {
              print('take Picture ${value.path}');
              Navigator.pop(context, {
                'imagePath': value.path
              });
            });
          },
          child: Icon(Icons.camera),
        ),
      ),
    );
  }
}
