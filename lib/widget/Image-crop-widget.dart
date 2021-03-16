import 'dart:async';
import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_camera_crop/page/crop/cubit/crop-image-cubit.dart';
import 'package:flutter_camera_crop/widget/image-crop-widget.viewmodel.dart';


class ImageCropWidget extends StatefulWidget {
  const ImageCropWidget({@required this.imageBytes});

  final Uint8List imageBytes;

  @override
  _ImageCropWidgetState createState() => _ImageCropWidgetState();
}

class _ImageCropWidgetState extends State<ImageCropWidget> with TickerProviderStateMixin {

  ImageCropWidgetViewModel _viewModel;
  // AnimationController _rotateController;
  // double _rotateAnimationValue = 0;
  bool _isVertical = true;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback(_afterLayout);
    _viewModel ??= ImageCropWidgetViewModel();
    context.read<CropImageCubit>().setCropImage(
        imageByte: widget.imageBytes,
        quarterTurns: _viewModel.quarterTurns,
        insets: EdgeInsets.all(20)
    );
    // _rotateController = AnimationController(
    //   duration: const Duration(milliseconds: 700),
    //   vsync: this,
    // );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(color: Colors.black87),
        _buildCropView(),
        _buildCropButtons(context),
      ],
    );
  }

  _buildCropView() {
    return BlocBuilder<CropImageCubit, CropImageModel>(
      builder: (_, model) {
        return Align(
          alignment: Alignment.center,
          child: _buildCrop(context, model),
        );
      },
    );
  }

  Widget _buildCrop(BuildContext context, CropImageModel model) {
    return Stack(
      children: <Widget>[
        RotatedBox(
          quarterTurns: model.quarterTurns,
          child: Container(
            key: _viewModel.imageContainerKey,
            child: Image.memory(widget.imageBytes),
          ),
        ),
        _buildOverlay(model.insets),
        _buildCropArea(context, model.insets),
        // _buildHandleArea(context, insets),
      ],
    );
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
        decoration: BoxDecoration(border: border),
      ),
    );
  }

  Widget _buildCropArea(BuildContext context, EdgeInsets insets) {
    final borderSide = BorderSide(
      width: _viewModel.cropEdgeBorderWidth,
      color: _viewModel.cropEdgeColor,
    );
    final cropEdgeColor = _viewModel.cropEdgeColor;
    final cropEdgeSize = _viewModel.cropEdgeSize;

    return Positioned.fill(
      child: Container(
        padding: insets,
        child: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            Positioned.fill(
              child: GestureDetector(
                child: Container(
                  key: _viewModel.cropAreaKey,
                  decoration: BoxDecoration(
                      border: Border.all(color: cropEdgeColor)
                  ),
                ),
                onPanUpdate: (detail) {
                  double dx = detail.delta.dx;
                  double dy = detail.delta.dy;

                  if ((insets.left == 0 && dx < 0)
                      || (insets.right == 0 && dx > 0)
                      || (insets.left + dx < 0)
                      || (insets.right - dx < 0)) {
                    dx = 0;
                  }

                  if ((insets.top == 0 && dy < 0)
                      || (insets.bottom == 0 && dy > 0)
                      || (insets.top + dy < 0)
                      || (insets.bottom - dy < 0)) {
                    dy = 0;
                  }

                  if (dx == 0 && dy == 0) {
                    return;
                  }

                  context.read<CropImageCubit>().setCropImage(
                    insets: EdgeInsets.fromLTRB(
                      max(insets.left + dx, 0),
                      max(insets.top + dy, 0),
                      max(insets.right - dx, 0),
                      max(insets.bottom - dy, 0),
                    ),
                    cropSize: _viewModel.getCropSize(),
                    imageSize: _viewModel.getImageSize(),
                  );
                },
              ),
            ),
            Positioned(
              left: 0,
              top: 0,
              child: GestureDetector(
                onPanUpdate: (drag) {
                  final padding = _viewModel.getCalcPadding(
                      px: insets.left,
                      py: insets.top,
                      offsetX: insets.right,
                      offsetY: insets.bottom,
                      dragDx: drag.delta.dx,
                      dragDy: drag.delta.dy
                  );

                  context.read<CropImageCubit>().setCropImage(
                    insets: insets.copyWith(
                      left: padding.dx,
                      top: padding.dy,
                    ),
                    cropSize: _viewModel.getCropSize(),
                    imageSize: _viewModel.getImageSize(),
                  );
                },
                child: Container(
                  width: cropEdgeSize,
                  height: cropEdgeSize,
                  decoration: BoxDecoration(
                    border: Border(
                      left: borderSide,
                      top: borderSide,
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              top: 0,
              right: 0,
              child: GestureDetector(
                onPanUpdate: (drag) {
                  final padding = _viewModel.getCalcPadding(
                      px: insets.right,
                      py: insets.top,
                      offsetX: insets.left,
                      offsetY: insets.bottom,
                      dragDx: -drag.delta.dx,
                      dragDy: drag.delta.dy
                  );

                  context.read<CropImageCubit>().setCropImage(
                    insets: insets.copyWith(
                      right: padding.dx,
                      top: padding.dy,
                    ),
                    cropSize: _viewModel.getCropSize(),
                    imageSize: _viewModel.getImageSize(),
                  );
                },
                child: Container(
                  width: cropEdgeSize,
                  height: cropEdgeSize,
                  decoration: BoxDecoration(
                    border: Border(
                      right: borderSide,
                      top: borderSide,
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              right: 0,
              bottom: 0,
              child: GestureDetector(
                onPanUpdate: (drag) {
                  final padding = _viewModel.getCalcPadding(
                      px: insets.right,
                      py: insets.bottom,
                      offsetX: insets.left,
                      offsetY: insets.top,
                      dragDx: -drag.delta.dx,
                      dragDy: -drag.delta.dy
                  );

                  context.read<CropImageCubit>().setCropImage(
                    insets: insets.copyWith(
                      right: padding.dx,
                      bottom: padding.dy,
                    ),
                    cropSize: _viewModel.getCropSize(),
                    imageSize: _viewModel.getImageSize(),
                  );
                },
                child: Container(
                  width: cropEdgeSize,
                  height: cropEdgeSize,
                  decoration: BoxDecoration(
                    border: Border(
                      right: borderSide,
                      bottom: borderSide,
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              left: 0,
              bottom: 0,
              child: GestureDetector(
                onPanUpdate: (drag) {
                  final padding = _viewModel.getCalcPadding(
                      px: insets.left,
                      py: insets.bottom,
                      offsetX: insets.right,
                      offsetY: insets.top,
                      dragDx: drag.delta.dx,
                      dragDy: -drag.delta.dy
                  );

                  context.read<CropImageCubit>().setCropImage(
                    insets: insets.copyWith(
                      left: padding.dx,
                      bottom: padding.dy,
                    ),
                    cropSize: _viewModel.getCropSize(),
                    imageSize: _viewModel.getImageSize(),
                  );
                },
                child: Container(
                  width: cropEdgeSize,
                  height: cropEdgeSize,
                  decoration: BoxDecoration(
                    border: Border(
                      left: borderSide,
                      bottom: borderSide,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHandleArea(BuildContext context, EdgeInsets insets) {
    final cropHandleSize = _viewModel.cropHandleSize;
    final cropEdgeHandleColor = _viewModel.cropEdgeHandleColor;

    return Positioned.fill(
      child: Stack(
        children: <Widget>[
          Positioned(
            top: insets.top - (cropHandleSize / 3),
            left: insets.left - (cropHandleSize / 3),
            child: GestureDetector(
              child: Container(
                width: cropHandleSize,
                height: cropHandleSize,
                color: cropEdgeHandleColor,
              ),
              onPanUpdate: (drag) {
                final padding = _viewModel.getCalcPadding(
                    px: insets.left,
                    py: insets.top,
                    offsetX: insets.right,
                    offsetY: insets.bottom,
                    dragDx: drag.delta.dx,
                    dragDy: drag.delta.dy
                );

                context.read<CropImageCubit>().setCropImage(
                  insets: insets.copyWith(
                    left: padding.dx,
                    top: padding.dy,
                  ),
                  cropSize: _viewModel.getCropSize(),
                  imageSize: _viewModel.getImageSize(),
                );
              },
            ),
          ),
          Positioned(
            top: insets.top - (cropHandleSize / 3),
            right: insets.right - (cropHandleSize / 3),
            child: GestureDetector(
              child: Container(
                width: cropHandleSize,
                height: cropHandleSize,
                color: cropEdgeHandleColor,
              ),
              onPanUpdate: (drag) {
                final padding = _viewModel.getCalcPadding(
                    px: insets.right,
                    py: insets.top,
                    offsetX: insets.left,
                    offsetY: insets.bottom,
                    dragDx: -drag.delta.dx,
                    dragDy: drag.delta.dy
                );

                context.read<CropImageCubit>().setCropImage(
                  insets: insets.copyWith(
                    right: padding.dx,
                    top: padding.dy,
                  ),
                  cropSize: _viewModel.getCropSize(),
                  imageSize: _viewModel.getImageSize(),
                );
              },
            ),
          ),
          Positioned(
            bottom: insets.bottom - (cropHandleSize / 3),
            right: insets.right - (cropHandleSize / 3),
            child: GestureDetector(
              child: Container(
                width: cropHandleSize,
                height: cropHandleSize,
                color: cropEdgeHandleColor,
              ),
              onPanUpdate: (drag) {
                final padding = _viewModel.getCalcPadding(
                    px: insets.right,
                    py: insets.bottom,
                    offsetX: insets.left,
                    offsetY: insets.top,
                    dragDx: -drag.delta.dx,
                    dragDy: -drag.delta.dy
                );

                context.read<CropImageCubit>().setCropImage(
                  insets: insets.copyWith(
                    right: padding.dx,
                    bottom: padding.dy,
                  ),
                  cropSize: _viewModel.getCropSize(),
                  imageSize: _viewModel.getImageSize(),
                );
              },
            ),
          ),
          Positioned(
            bottom: insets.bottom - (cropHandleSize / 3),
            left: insets.left - (cropHandleSize / 3),
            child: GestureDetector(
              child: Container(
                width: cropHandleSize,
                height: cropHandleSize,
                color: cropEdgeHandleColor,
              ),
              onPanUpdate: (drag) {
                final padding = _viewModel.getCalcPadding(
                    px: insets.left,
                    py: insets.bottom,
                    offsetX: insets.right,
                    offsetY: insets.top,
                    dragDx: drag.delta.dx,
                    dragDy: -drag.delta.dy
                );

                context.read<CropImageCubit>().setCropImage(
                  insets: insets.copyWith(
                    left: padding.dx,
                    bottom: padding.dy,
                  ),
                  cropSize: _viewModel.getCropSize(),
                  imageSize: _viewModel.getImageSize(),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  _buildCropButtons(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        padding: EdgeInsets.all(15),
        margin: EdgeInsets.only(
          bottom: 30
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          color: Colors.black,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          mainAxisSize: MainAxisSize.min,
          children: [
            _getRotatePictureButton(context),
          ],
        ),
      ),
    );
  }

  _getRotatePictureButton(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _rotateImage();
      },
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          shape: BoxShape.circle
        ),
        child: Icon(
          Icons.crop_rotate,
          color: Colors.white,
        ),
      ),
    );
  }

  _rotateImage() {
    _viewModel.quarterTurns++;
    // _isVertical = !_isVertical;
    // if((_rotateAnimationValue += 0.25) > 1) {
    //   _rotateAnimationValue = 0.25;
    //   _rotateController.reset();
    // }
    // _rotateController.animateTo(_rotateAnimationValue);

    final insets = EdgeInsets.all(20);

    context.read<CropImageCubit>().setCropImage(
        insets: insets,
        quarterTurns: _viewModel.quarterTurns,
    );
  }

  //todo addPostFrameCallback으로 image Size 초기화 해주려고했는데 딜레이를 안주니 Size가 0으로 나옴
  //이미지 사이즈를 미리 가져오는 방법도 있음
  _afterLayout(Duration duration) {
    Future.delayed(Duration(milliseconds: 30)).then((_) {
      final RenderBox cropBox = _viewModel.cropAreaKey.currentContext.findRenderObject();
      final RenderBox imageBox = _viewModel.imageContainerKey.currentContext.findRenderObject();

      context.read<CropImageCubit>().setCropImage(
          imageSize: imageBox.size,
          cropSize: cropBox.size
      );
    });
  }
}