import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_camera_crop/cubit/base-cubit.dart';
import 'package:flutter_camera_crop/widget/image-crop-widget.viewmodel.dart';


class ImageCropWidget extends StatelessWidget {

  ImageCropWidget(this.imagePath, {this.angle = 0});

  final String imagePath;
  final int angle;

  ImageCropWidgetViewModel _viewModel;

  @override
  Widget build(BuildContext context) {
    _viewModel ??= ImageCropWidgetViewModel(angle);

    return BlocBuilder<CropImageCubit, EdgeInsets>(
        builder: (context, insets) => _buildUI(context, insets)
    );
  }

  Widget _buildUI(BuildContext context, EdgeInsets insets) {
    return Stack(
      children: <Widget>[
        Container(
          key: _viewModel.imageContainerKey,
          color: Colors.black,
          child: RotatedBox(
              quarterTurns: _viewModel.quarterTurns,
              child: Image.file(File(imagePath))
          ),
        ),
        _buildOverlay(insets),
        _buildCropArea(context, insets),
        _buildHandleArea(context, insets),
        // _buildCropButtons(),
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

                  context.read<CropImageCubit>().value = EdgeInsets.fromLTRB(
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

  _buildCropButtons() {
    return Container();
  }
}

class CropImageCubit extends BaseCubit<EdgeInsets> {
  CropImageCubit({EdgeInsets insets = const EdgeInsets.all(30)}) : super(insets);

  EdgeInsets get insets => super.value;
  set insets(EdgeInsets value) => super.value = value;
}
