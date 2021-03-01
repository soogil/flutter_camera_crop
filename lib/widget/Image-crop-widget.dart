import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_camera_crop/page/crop/cubit/crop-image-cubit.dart';
import 'package:flutter_camera_crop/widget/image-crop-widget.viewmodel.dart';


class ImageCropWidget extends StatefulWidget {

  const ImageCropWidget(this.imagePath);

  final String imagePath;

  @override
  _ImageCropWidgetState createState() => _ImageCropWidgetState();
}

class _ImageCropWidgetState extends State<ImageCropWidget> with TickerProviderStateMixin {

  ImageCropWidgetViewModel _viewModel;
  AnimationController _rotateController;
  double _rotateValue = 0.0;

  @override
  void initState() {
    _viewModel ??= ImageCropWidgetViewModel();
    _rotateController = AnimationController(
        duration: const Duration(milliseconds: 700),
        vsync: this,
    );
    super.initState();
  }

  @override
  void dispose() {
    _rotateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CropImageCubit, EdgeInsets>(
        builder: (context, cropModel) => _buildUI(context, cropModel)
    );
  }

  Widget _buildUI(BuildContext context, EdgeInsets insets) {
    return Stack(
      children: [
        Container(color: Colors.black87),
        Align(
          alignment: Alignment.center,
          child: InteractiveViewer(
              child: RotationTransition(
                  turns: Tween(begin: 1.0, end: 0.0).animate(_rotateController),
                  child: _buildCropPicture(context, insets)
              )
          ),
        ),
        _buildCropButtons(context),
      ],
    );
  }

  Widget _buildCropPicture(BuildContext context, EdgeInsets insets) {
    return Stack(
      children: <Widget>[
        Container(
          key: _viewModel.imageContainerKey,
          child: Image.file(File(widget.imagePath))
          // RotatedBox
        ),
        _buildOverlay(insets),
        _buildCropArea(context, insets),
        _buildHandleArea(context, insets),
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

                  context.read<CropImageCubit>().insets = EdgeInsets.fromLTRB(
                    max(insets.left + dx * 2, 0),
                    max(insets.top + dy * 2, 0),
                    max(insets.right - dx * 2, 0),
                    max(insets.bottom - dy * 2, 0),
                  );
                },
              ),
            ),
            Positioned(
              left: 0,
              top: 0,
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
            Positioned(
              top: 0,
              right: 0,
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
            Positioned(
              right: 0,
              bottom: 0,
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
            Positioned(
              left: 0,
              bottom: 0,
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

                context.read<CropImageCubit>().insets = insets.copyWith(
                  left: padding.dx,
                  top: padding.dy,
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

                context.read<CropImageCubit>().insets = insets.copyWith(
                  right: padding.dx,
                  top: padding.dy,
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

                context.read<CropImageCubit>().insets = insets.copyWith(
                  right: padding.dx,
                  bottom: padding.dy,
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
        if((_rotateValue += 0.25) > 1) {
          _rotateValue = 0.25;
          _rotateController.reset();
        }
        _rotateController.animateTo(_rotateValue);
      },
      child: Icon(
        Icons.crop_rotate, 
        color: Colors.white,
      ),
    );
  }
}