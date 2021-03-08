// import 'package:flutter/material.dart';
//
// enum CropTouchPoint {
//   top_left,
//   top_right,
//   bottom_right,
//   bottom_left,
//   center,
//   none
// }
//
// class CropValue {
//   final double _size = 48.0;
//   final Rect rect;
//   final Map<CropTouchPoint, Rect> _cornersRect = {
//     CropTouchPoint.top_left: null,
//     CropTouchPoint.top_right: null,
//     CropTouchPoint.bottom_left: null,
//     CropTouchPoint.bottom_right: null
//   };
//
//   static CropValue zero = CropValue();
//
//   Map<CropTouchPoint, Rect> get corners => _cornersRect;
//
//   List<Offset> get cornerPoints =>
//       _cornersRect.values.map((it) => it.center).toList();
//
//   CropValue({this.rect = Rect.zero}) {
//     _updateCorners();
//   }
//
//   bool contains(Offset position) =>
//       containsCenter(position) || containsCorners(position);
//
//   bool containsCenter(Offset position) => rect?.contains(position) == true;
//
//   bool containsCorners(Offset position) =>
//       _cornersRect.values.map((it) => it.contains(position))?.contains(true) ==
//           true;
//
//   void _updateCorners() {
//     _cornersRect.keys.forEach((key) {
//       _cornersRect[key] = _updateCorner(key);
//     });
//   }
//
//   @override
//   bool operator ==(Object other) =>
//       identical(this, other) ||
//           other is CropValue &&
//               runtimeType == other.runtimeType &&
//               rect == other.rect;
//
//   @override
//   int get hashCode => rect.hashCode;
//
//   @override
//   String toString() {
//     return 'CropValue{crop: $rect}';
//   }
//
//   Rect _updateCorner(CropTouchPoint key) {
//     if (rect == null) return null;
//     switch (key) {
//       case CropTouchPoint.top_left:
//         return Rect.fromCenter(
//             center: rect.topLeft, width: _size, height: _size);
//       case CropTouchPoint.top_right:
//         return Rect.fromCenter(
//             center: rect.topRight, width: _size, height: _size);
//       case CropTouchPoint.bottom_left:
//         return Rect.fromCenter(
//             center: rect.bottomLeft, width: _size, height: _size);
//       case CropTouchPoint.bottom_right:
//         return Rect.fromCenter(
//             center: rect.bottomRight, width: _size, height: _size);
//       default:
//         return null;
//     }
//   }
//
//   CropTouchPoint getCropTouchPoint(Offset position) {
//     final cropTouchPoint = _cornersRect.keys.firstWhere(
//             (it) => _cornersRect[it].contains(position),
//         orElse: () => CropTouchPoint.none);
//
//     if (cropTouchPoint == CropTouchPoint.none && containsCenter(position)) {
//       return CropTouchPoint.center;
//     }
//     return cropTouchPoint;
//   }
//
//   Offset getCropTouchPointOffset(Offset position) {
//     final cropTouchPoint = getCropTouchPoint(position);
//     if (_cornersRect.containsKey(cropTouchPoint)) {
//       return _cornersRect[cropTouchPoint].center - position;
//     } else {
//       switch (cropTouchPoint) {
//         case CropTouchPoint.center:
//           return rect.center - position;
//         default:
//           return Offset.zero;
//       }
//     }
//   }
// }
//
// // class CropPainter extends CustomPainter {
// //   final CropValue cropValue;
// //   final CropBloc _bloc;
// //
// //   Paint _paintCorner;
// //   Paint _paintBackground;
// //   Paint _paintCrop;
// //
// //   Rect get bounds => _bloc.bounds;
// //
// //   Size get layout => _bloc.layoutSize;
// //
// //   CropPainter(this.cropValue, this._bloc,) {
// //     _paintCorner = Paint()
// //       ..color = Colors.black
// //       ..style = PaintingStyle.fill
// //       ..strokeWidth = 16;
// //
// //     _paintCrop = Paint()
// //       ..color = Colors.black
// //       ..style = PaintingStyle.stroke
// //       ..strokeWidth = 1;
// //
// //     _paintBackground = Paint()..color = Colors.black.withOpacity(0.5);
// //   }
// //
// //   final double cropCornerThick = 4;
// //   final double cropCornerSize = 24;
// //
// //   @override
// //   void paint(Canvas canvas, Size size) {
// //     if (cropValue.rect == null) return;
// //     if (_bloc.drawBorder) canvas.drawRect(cropValue.rect, _paintCrop);
// //     cropValue.corners.forEach((point, rect) {
// //       switch (point) {
// //         case CropTouchPoint.top_left:
// //           if (_bloc._allowZoom) {
// //             canvas.drawRect(
// //                 Rect.fromLTWH(rect.center.dx, rect.center.dy,
// //                     layout.width - rect.center.dx, -rect.center.dy),
// //                 _paintBackground);
// //           } else {
// //             canvas.drawRect(
// //                 Rect.fromLTWH(rect.center.dx, bounds.top,
// //                     bounds.right - rect.center.dx, rect.center.dy - bounds.top),
// //                 _paintBackground);
// //           }
// //
// //           /// draw corner
// //           canvas.drawRect(
// //               Rect.fromLTWH(rect.center.dx, rect.center.dy, cropCornerThick,
// //                   cropCornerSize),
// //               _paintCorner);
// //           canvas.drawRect(
// //               Rect.fromLTWH(rect.center.dx, rect.center.dy, cropCornerSize,
// //                   cropCornerThick),
// //               _paintCorner);
// //           break;
// //         case CropTouchPoint.top_right:
// //           if (_bloc._allowZoom) {
// //             canvas.drawRect(
// //                 Rect.fromLTWH(
// //                     rect.center.dx,
// //                     rect.center.dy,
// //                     layout.width - rect.center.dx,
// //                     layout.height - rect.center.dy),
// //                 _paintBackground);
// //           } else {
// //             canvas.drawRect(
// //                 Rect.fromLTWH(
// //                     rect.center.dx,
// //                     rect.center.dy,
// //                     bounds.right - rect.center.dx,
// //                     bounds.bottom - rect.center.dy),
// //                 _paintBackground);
// //           }
// //
// //           /// draw corner
// //           canvas.drawRect(
// //               Rect.fromLTWH(rect.center.dx, rect.center.dy, -cropCornerThick,
// //                   cropCornerSize),
// //               _paintCorner);
// //           canvas.drawRect(
// //               Rect.fromLTWH(rect.center.dx, rect.center.dy, -cropCornerSize,
// //                   cropCornerThick),
// //               _paintCorner);
// //           break;
// //         case CropTouchPoint.bottom_left:
// //           if (_bloc._allowZoom) {
// //             canvas.drawRect(
// //                 Rect.fromLTWH(rect.center.dx, rect.center.dy, -rect.center.dx,
// //                     -rect.center.dy),
// //                 _paintBackground);
// //           } else {
// //             canvas.drawRect(
// //                 Rect.fromLTWH(bounds.left, bounds.top,
// //                     rect.center.dx - bounds.left, rect.center.dy - bounds.top),
// //                 _paintBackground);
// //           }
// //
// //           /// draw corner
// //           canvas.drawRect(
// //               Rect.fromLTWH(rect.center.dx, rect.center.dy, cropCornerThick,
// //                   -cropCornerSize),
// //               _paintCorner);
// //           canvas.drawRect(
// //               Rect.fromLTWH(rect.center.dx, rect.center.dy, cropCornerSize,
// //                   -cropCornerThick),
// //               _paintCorner);
// //           break;
// //         case CropTouchPoint.bottom_right:
// //           if (_bloc._allowZoom) {
// //             canvas.drawRect(
// //                 Rect.fromLTWH(rect.center.dx, rect.center.dy, -rect.center.dx,
// //                     layout.height - rect.center.dy),
// //                 _paintBackground);
// //           } else {
// //             canvas.drawRect(
// //                 Rect.fromLTWH(
// //                     bounds.left,
// //                     rect.center.dy,
// //                     rect.center.dx - bounds.left,
// //                     bounds.bottom - rect.center.dy),
// //                 _paintBackground);
// //           }
// //
// //           /// draw corner
// //           canvas.drawRect(
// //               Rect.fromLTWH(rect.center.dx, rect.center.dy, -cropCornerThick,
// //                   -cropCornerSize),
// //               _paintCorner);
// //           canvas.drawRect(
// //               Rect.fromLTWH(rect.center.dx, rect.center.dy, -cropCornerSize,
// //                   -cropCornerThick),
// //               _paintCorner);
// //           break;
// //         default:
// //           break;
// //       }
// //     });
// //   }
// //
// //   @override
// //   bool shouldRepaint(CropPainter oldDelegate) {
// //     return cropValue.rect != oldDelegate.cropValue.rect ||
// //         bounds != oldDelegate.bounds;
// //   }
// //
// //   // Color get themeColor {
// //   //   switch (theme) {
// //   //     case WiseTheme.RED:
// //   //       return WiseColors.red_100;
// //   //     case WiseTheme.BLUE:
// //   //       return WiseColors.blue_100;
// //   //     case WiseTheme.YELLOW:
// //   //       return WiseColors.yellow_100;
// //   //     case WiseTheme.GREEN:
// //   //       return WiseColors.green_100;
// //   //     case WiseTheme.PURPLE:
// //   //       return WiseColors.purple_100;
// //   //     case WiseTheme.PINK:
// //   //       return WiseColors.pink_100;
// //   //     default:
// //   //       return WiseColors.black_40;
// //   //   }
// //   // }
// // }
