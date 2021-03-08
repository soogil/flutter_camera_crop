import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:flutter_camera_crop/page/crop/crop-page.view.dart';
import 'package:flutter_camera_crop/service/camera-service.dart';


class CameraPreviewPageView extends StatelessWidget {

  CameraPreviewPageView() : cameraController =
      CameraService().cameraController ,initCamera = CameraService().initCamera;

  final CameraController cameraController;
  final Future initCamera;

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
        future: initCamera,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return CameraPreview(cameraController);
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
            await cameraController.takePicture().then((value) {
              Navigator.pushReplacement(context, MaterialPageRoute(
                  builder: (context) => CropPageView(value.path)));
              // Navigator.pop(context, {
              //   'imagePath': value.path
              // });
            });
          },
          child: Icon(Icons.camera),
        ),
      ),
    );
  }
}
