import 'package:flutter/material.dart';
import 'package:flutter_camera_crop/widget/Image-crop-widget.dart';


class CropPageView extends StatelessWidget {

  const CropPageView(this.path);

  final String path;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _getAppBar(),
      body: _getBody(context),
    );
  }

  _getAppBar() {
    return AppBar(
      title: Text(
        'CropPage'
      ),
    );
  }

  _getBody(BuildContext context) {
    return Align(
        alignment: Alignment.topCenter,
        child: ImageCropWidget(path)
    );
  }
}
