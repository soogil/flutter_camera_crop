import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_camera_crop/page/camera/camera-page.view.dart';
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
    return BlocBuilder<CameraImageCubit, String>(
        builder: (context, state) {
          print('BlocBuilder $state');
          if(state == null) {
            return Container();
          } else {
            return Center(child: Image.file(File(state)));
          }
        }
    );
  }

  _getCameraView(BuildContext context) {
    return FloatingActionButton(
        onPressed: () async {
          final data = await Navigator.push(context, MaterialPageRoute(builder: (context) => CameraPageView()));

          if (data == null) return;

          final path = data['imagePath'];

          context.read<CameraImageCubit>().setImagePath(path);
        },
      child: Icon(Icons.camera_alt_outlined),
    );
  }
}
