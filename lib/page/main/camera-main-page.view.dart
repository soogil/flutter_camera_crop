import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_camera_crop/page/camera/camera-preview-page.view.dart';
import 'package:flutter_camera_crop/page/crop/cubit/edge-insets-cubit.dart';
import 'package:flutter_camera_crop/page/main/cubit/image-cubit.dart';


class CameraMainPageView extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _getAppBar(),
      body: _getBody(),
      floatingActionButton: _getCameraView(context),
    );
  }

  _getAppBar() {
    return AppBar(
      title: Text('Flutter_camera_crop'),
    );
  }

  _getBody() {
    return BlocBuilder<CameraImageCubit, Uint8List>(
        builder: (context, state) {
          print('CameraMainPageView $state');
          if(state == null) {
            return Container();
          } else {
            return Center(child: Image.memory(state));
          }
        }
    );
  }

  _getCameraView(BuildContext context) {
    return FloatingActionButton(
        onPressed: () async {
          final data = await Navigator.push(context, MaterialPageRoute(builder: (context) => CameraPreviewPageView()));

          if (data == null) return;

          final imageBytes = data['imageBytes'];

          context.read<CameraImageCubit>().imageBytes = imageBytes;
        },
      child: Icon(Icons.camera_alt_outlined),
    );
  }
}
