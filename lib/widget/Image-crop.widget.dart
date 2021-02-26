import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_camera_crop/cubit/base-cubit.dart';


typedef PanGestureEnded = void Function(Size cropSize, Size viewSize);

class ImageCropWidget extends StatelessWidget {

  static const double CROP_MINIMUM_SIZE = 150;

  static const Color _CROP_EDGE_COLOR = Color.fromRGBO(255, 255, 255, 0.7);
  static const double _CROP_EDGE_SIZE = 28;
  static const double _CROP_EDGE_BORDER_WIDTH = 4;
  static const Color _CROP_HANDLE_COLOR = Colors.transparent;
  static const double _CROP_HANDLE_SIZE = 60;

  static const BorderSide _CROP_EDGE_BORDER_SIDE = BorderSide(
    width: _CROP_EDGE_BORDER_WIDTH,
    color: _CROP_EDGE_COLOR,
  );

  String _imagePath;

  int _quarterTurns;

  GlobalKey _cropAreaKey = GlobalKey();
  GlobalKey _imageContainerKey = GlobalKey();

  PanGestureEnded onPanGestureEndCallback;

  ImageCropWidget(String imagePath, {double scale: 1.0, int angle: 0, bool async: false, EdgeInsets initInsets: const EdgeInsets.all(30), this.onPanGestureEndCallback}) {
    _imagePath = imagePath;
    _quarterTurns = angle ~/ 90;
  }

  ImageCropWidget.fromBytes(Uint8List imageBytes, {double scale: 1.0,  int angle: 0,  EdgeInsets initInsets: const EdgeInsets.all(30), this.onPanGestureEndCallback}) {
    _quarterTurns = angle ~/ 90;
  }

  Future rotateImageWidget({EdgeInsets insets: const EdgeInsets.all(30)}) async {
    // _rotateCompleter = Completer();
    //
    // _quarterTurns++;
    //
    // _viewModel.resetInsets(insets: insets);
    //
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   _rotateCompleter.complete();
    // });
    //
    // return _rotateCompleter.future;
  }

  @override
  Widget build(BuildContext context) {
    return _buildImageCropper(context);
  }

  Widget _buildImageCropper(BuildContext context) {
    return BlocBuilder<CropImageCubit, EdgeInsets>(
        builder: (context, crop) {
          // print('_buildImageCropper $crop');
          return Stack(
            children: <Widget>[
              Container(
                key: _imageContainerKey,
                color: Colors.black,
                child: RotatedBox(
                    quarterTurns: _quarterTurns,
                    child: Image.file(File(_imagePath))
                ),
              ),
              _buildOverlay(crop),
              _buildCropArea(context, crop),
              _buildHandleArea(context, crop),
            ],
          );
        }
    );

    // return Stack(
    //   children: <Widget>[
    //     Container(
    //       key: _imageContainerKey,
    //       color: Colors.black,
    //       child: RotatedBox(
    //           quarterTurns: _quarterTurns,
    //           child: _image
    //       ),
    //     ),
    //     _buildOverlay(),
    //     _buildCropArea(),
    //     _buildHandleArea(),
    //   ],
    // );
  }

  Widget _buildOverlay(EdgeInsets insets) {
    final Color color = Color.fromRGBO(0, 0, 0, 0.5);
    final Border border = Border(
      left: insets.left == 0 ? BorderSide.none : BorderSide(
        width: insets.left,
        color: color,
      ),
      top: insets.top == 0 ? BorderSide.none : BorderSide(
        width: insets.top,
        color: color,
      ),
      right: insets.right == 0 ? BorderSide.none : BorderSide(
        width: insets.right,
        color: color,
      ),
      bottom: insets.bottom == 0 ? BorderSide.none : BorderSide(
        width: insets.bottom,
        color: color,
      ),
    );

    return Positioned.fill(
      child: Container(
        decoration: BoxDecoration(
            border: border
        ),
      ),
    );
  }

  Widget _buildCropArea(BuildContext context, EdgeInsets insets) {
    return Positioned.fill(
      child: Container(
        padding: insets,
        child: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            Positioned.fill(
              child: GestureDetector(
                child: Container(
                  key: _cropAreaKey,
                  decoration: BoxDecoration(
                      border: Border.all(
                        color: _CROP_EDGE_COLOR,
                      )
                  ),
                ),
                onPanUpdate: (drag) {
                  double dx = drag.delta.dx;
                  double dy = drag.delta.dy;

                  if ((insets.left == 0 && drag.delta.dx < 0)
                      || (insets.right == 0 && drag.delta.dx > 0)) {
                    dx = 0;
                  }

                  if ((insets.top == 0 && drag.delta.dy < 0)
                      || (insets.bottom == 0 && drag.delta.dy > 0)) {
                    dy = 0;
                  }

                  if (dx == 0 && dy == 0) {
                    return;
                  }

                  context.read<CropImageCubit>().value = EdgeInsets.fromLTRB(
                    max(insets.left + dx, 0),
                    max(insets.top + dy, 0),
                    max(insets.right - dx, 0),
                    max(insets.bottom - dy, 0),
                  );
                },
              ),
            ),
            Positioned(
              left: 0,
              top: 0,
              child: Container(
                width: _CROP_EDGE_SIZE,
                height: _CROP_EDGE_SIZE,
                decoration: BoxDecoration(
                  border: Border(
                    left: _CROP_EDGE_BORDER_SIDE,
                    top: _CROP_EDGE_BORDER_SIDE,
                  ),
                ),
              ),
            ),
            Positioned(
              top: 0,
              right: 0,
              child: Container(
                width: _CROP_EDGE_SIZE,
                height: _CROP_EDGE_SIZE,
                decoration: BoxDecoration(
                  border: Border(
                    right: _CROP_EDGE_BORDER_SIDE,
                    top: _CROP_EDGE_BORDER_SIDE,
                  ),
                ),
              ),
            ),
            Positioned(
              right: 0,
              bottom: 0,
              child: Container(
                width: _CROP_EDGE_SIZE,
                height: _CROP_EDGE_SIZE,
                decoration: BoxDecoration(
                  border: Border(
                    right: _CROP_EDGE_BORDER_SIDE,
                    bottom: _CROP_EDGE_BORDER_SIDE,
                  ),
                ),
              ),
            ),
            Positioned(
              left: 0,
              bottom: 0,
              child: Container(
                width: _CROP_EDGE_SIZE,
                height: _CROP_EDGE_SIZE,
                decoration: BoxDecoration(
                  border: Border(
                    left: _CROP_EDGE_BORDER_SIDE,
                    bottom: _CROP_EDGE_BORDER_SIDE,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Size _getImageSize() {
    return _imageContainerKey.currentContext.size;
  }

  Size _getCropAreaSize() {
    return _cropAreaKey.currentContext.size;
  }

  Widget _buildHandleArea(BuildContext context, EdgeInsets insets) {
    return Positioned.fill(
      child: Stack(
        children: <Widget>[
          Positioned(
            top: insets.top - (_CROP_HANDLE_SIZE / 3),
            left: insets.left - (_CROP_HANDLE_SIZE / 3),
            child: GestureDetector(
              onPanEnd: (details) {
                if(null != onPanGestureEndCallback) {
                  onPanGestureEndCallback(_getCropAreaSize(), _getImageSize());
                }
              },
              child: Container(
                width: _CROP_HANDLE_SIZE,
                height: _CROP_HANDLE_SIZE,
                color: _CROP_HANDLE_COLOR,
              ),
              onPanUpdate: (drag) {
                final padding = _getCalcPadding(
                    px: insets.left,
                    py: insets.top,
                    offsetX: insets.right,
                    offsetY: insets.bottom,
                    dragDx: drag.delta.dx,
                    dragDy: drag.delta.dy
                );

                context.read<CropImageCubit>().insets = insets.copyWith(
                  left: padding.dx,
                  top: padding.dy,
                );
              },
            ),
          ),
          Positioned(
            top: insets.top - (_CROP_HANDLE_SIZE / 3),
            right: insets.right - (_CROP_HANDLE_SIZE / 3),
            child: GestureDetector(
              onPanEnd: (details) {
                if(null != onPanGestureEndCallback) {
                  onPanGestureEndCallback(_getCropAreaSize(), _getImageSize());
                }
              },
              child: Container(
                width: _CROP_HANDLE_SIZE,
                height: _CROP_HANDLE_SIZE,
                color: _CROP_HANDLE_COLOR,
              ),
              onPanUpdate: (drag) {
                final padding = _getCalcPadding(
                    px: insets.right,
                    py: insets.top,
                    offsetX: insets.left,
                    offsetY: insets.bottom,
                    dragDx: -drag.delta.dx,
                    dragDy: drag.delta.dy
                );

                context.read<CropImageCubit>().insets = insets.copyWith(
                  right: padding.dx,
                  top: padding.dy,
                );
              },
            ),
          ),
          Positioned(
            bottom: insets.bottom - (_CROP_HANDLE_SIZE / 3),
            right: insets.right - (_CROP_HANDLE_SIZE / 3),
            child: GestureDetector(
              onPanEnd: (details) {
                if(null != onPanGestureEndCallback) {
                  onPanGestureEndCallback(_getCropAreaSize(), _getImageSize());
                }
              },
              child: Container(
                width: _CROP_HANDLE_SIZE,
                height: _CROP_HANDLE_SIZE,
                color: _CROP_HANDLE_COLOR,
              ),
              onPanUpdate: (drag) {
                final padding = _getCalcPadding(
                    px: insets.right,
                    py: insets.bottom,
                    offsetX: insets.left,
                    offsetY: insets.top,
                    dragDx: -drag.delta.dx,
                    dragDy: -drag.delta.dy
                );

                context.read<CropImageCubit>().insets = insets.copyWith(
                  right: padding.dx,
                  bottom: padding.dy,
                );
              },
            ),
          ),
          Positioned(
            bottom: insets.bottom - (_CROP_HANDLE_SIZE / 3),
            left: insets.left - (_CROP_HANDLE_SIZE / 3),
            child: GestureDetector(
              onPanEnd: (details) {
                if(null != onPanGestureEndCallback) {
                  onPanGestureEndCallback(_getCropAreaSize(), _getImageSize());
                }
              },
              child: Container(
                width: _CROP_HANDLE_SIZE,
                height: _CROP_HANDLE_SIZE,
                color: _CROP_HANDLE_COLOR,
              ),
              onPanUpdate: (drag) {
                final padding = _getCalcPadding(
                    px: insets.left,
                    py: insets.bottom,
                    offsetX: insets.right,
                    offsetY: insets.top,
                    dragDx: drag.delta.dx,
                    dragDy: -drag.delta.dy
                );

                context.read<CropImageCubit>().insets = insets.copyWith(
                  left: padding.dx,
                  bottom: padding.dy,
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Offset _getCalcPadding(
      {double px, double py, double offsetX, double offsetY, double dragDx, double dragDy}) {
    final cropSize = _getCropAreaSize();
    final imageSize = _getImageSize();
    double paddingX = 0.0;
    double paddingY = 0.0;

    if (cropSize.width - dragDx < CROP_MINIMUM_SIZE) {
      paddingX = max(imageSize.width - offsetX - CROP_MINIMUM_SIZE, 0);
    } else {
      paddingX = max(px + dragDx, 0);
    }

    if (cropSize.height - dragDy < CROP_MINIMUM_SIZE) {
      paddingY = max(imageSize.height - offsetY - CROP_MINIMUM_SIZE, 0);
    } else {
      paddingY = max(py + dragDy, 0);
    }

    return new Offset(paddingX, paddingY);
  }

  bool get isShortFall =>
      _getImageSize().width < CROP_MINIMUM_SIZE ||
          _getImageSize().height < CROP_MINIMUM_SIZE ||
          _getCropAreaSize().width < CROP_MINIMUM_SIZE ||
          _getCropAreaSize().height < CROP_MINIMUM_SIZE;

  Size  get viewAreaSize => _getImageSize();

  Size get cropAreaSize => _getCropAreaSize();

  int get turnAngle => _quarterTurns % 2;
}

class CropImageCubit extends BaseCubit<EdgeInsets> {
  CropImageCubit({EdgeInsets insets = const EdgeInsets.all(20)}) : super(insets);

  EdgeInsets get insets => super.value;
  set insets(EdgeInsets value) => super.value = value;
}
