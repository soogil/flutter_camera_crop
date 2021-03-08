import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_camera_crop/page/main/camera-main-page.view.dart';
import 'package:flutter_camera_crop/page/main/cubit/image-cubit.dart';
import 'package:flutter_camera_crop/page/crop/cubit/edge-insets-cubit.dart';


class CropApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider(create: (_) => CameraImageCubit()),
          BlocProvider(create: (_) => CropImageCubit()),
        ],
        child: MaterialApp(
            theme: ThemeData(
              primarySwatch: Colors.blue,
              visualDensity: VisualDensity.adaptivePlatformDensity,
            ),
            home: CameraMainPageView()
        )
    );
  }
}