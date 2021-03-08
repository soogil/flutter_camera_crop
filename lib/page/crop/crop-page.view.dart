import 'dart:io';
import 'dart:typed_data';

import 'package:crop_plugin/crop_plugin.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_camera_crop/page/crop/cubit/edge-insets-cubit.dart';
import 'package:flutter_camera_crop/page/main/cubit/image-cubit.dart';
import 'package:flutter_camera_crop/widget/Image-crop-widget.dart';


class CropPageView extends StatelessWidget {

  CropPageView(String imgPath) : viewModel = CropPageViewModel(imgPath);

  final CropPageViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _getAppBar(context),
      body: _getBody(context),
    );
  }

  _getAppBar(BuildContext context) {
    return AppBar(
      title: Text(
        'Crop page',
      ),
      actions: [
        _getCompleteButton(context),
      ],
    );
  }

  _getCompleteButton(BuildContext context) {
    return FlatButton(
        onPressed: () async {
          final model = context.read<CropImageCubit>().value;

          print(model.angle);
          final cropImageByte = await CropPlugin.cropImage(
            bytes: model.imageBytes,
            rawSize: model.imageSize,
            area: model.rect,
            scale: 0.1,
            angle: model.angle,
          );
          context.read<CameraImageCubit>().imageBytes = cropImageByte;
          Navigator.pop(context);
        },
        child: Text(
          '완료',
          style: TextStyle(
              color: Colors.white
          ),
        )
    );
  }

  _getBody(BuildContext context) {
    return Align(
        alignment: Alignment.topCenter,
        child: FutureBuilder(
          future: viewModel.imageByte,
          builder: (context, snapShot) {
            if(snapShot.hasData) {
              return ImageCropWidget(imageBytes: snapShot.data,);
            } else {
              return Text('이미지 로딩에 실패했습니다.');
            }
          },
        )
    );
  }
}

class CropPageViewModel {
  CropPageViewModel(this.imagePath);

  final String imagePath;

  Future<Uint8List> get imageByte async {
    Uri myUri = Uri.parse(imagePath);
    File imageFile = new File.fromUri(myUri);
    Uint8List bytes;
    await imageFile.readAsBytes().then((value) {
      bytes = Uint8List.fromList(value);
      print('reading of bytes is completed');
    }).catchError((onError) {
      print('Exception Error while reading audio from path:' + onError.toString());
    });
    return bytes;
  }
}
