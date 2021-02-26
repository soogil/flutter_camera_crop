import 'dart:async';
import 'dart:math';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';


Future<dynamic> getImageSize(List<int> bytes) async {
  final Completer completer = Completer<List>();
  final ImageStream stream = MemoryImage(Uint8List.fromList(bytes))
      .resolve(const ImageConfiguration());
  final listener = ImageStreamListener((info, synchronousCall) {
    if (!completer.isCompleted)
      completer.complete(
          [info.image.width.toDouble(), info.image.height.toDouble()]);
  });
  stream.addListener(listener);
  completer.future.then((_) {
    stream.removeListener(listener);
  });
  return completer.future;
}

double containsScale(Size layout, Size image, {double defaultScale = 1.0}) {
  final containScale =
  min(layout.height / image.height, layout.width / image.width);
  final reverseScale =
  min(layout.height / image.width, layout.width / image.height);

  final scale = min(containScale, reverseScale);

  final minScale = min(defaultScale, scale);

  return max(scale / 2, minScale);
}
// Future<ImageInfo> getImageInfo(ImageProvider imageProvider) {
//   final Completer completer = Completer<ImageInfo>();
//   final ImageStream stream = imageProvider.resolve(const ImageConfiguration());
//   final listener = ImageStreamListener((info, synchronousCall) {
//     if (!completer.isCompleted) completer.complete(info);
//   });
//   stream.addListener(listener);
//   completer.future.then((_) {
//     stream.removeListener(listener);
//   });
//   return completer.future;
// }
//
// class CropSource {
//   final Uint8List targetByte;
//   final Size targetSize;
//   final CropInfo crop;
//
//   CropSource(this.targetByte, this.targetSize, this.crop);
// }
//
// Future<Uint8List> cropWithDart(
//     Uint8List targetByte, Size targetSize, CropInfo crop) async {
//   if (crop == null) return targetByte;
//   try {
//     final double scale = crop.sourceSize.width / targetSize.width;
//     final degree = intDegree(crop.rotation);
//
//     final cropWidth = crop.area.width ~/ scale;
//     final cropHeight = crop.area.height ~/ scale;
//
//     if (degree == 0 &&
//         targetSize.width == cropWidth &&
//         targetSize.height == cropHeight) return targetByte;
//
//     final origin = decodeImage(targetByte);
//     final rotateImage = copyRotate(origin, degree);
//
//     final imageTranslate = crop.translate ?? Offset.zero;
//     final x = rotateImage.width / 2 +
//         (crop.area.topLeft.dx + imageTranslate.dx) / scale;
//     final y = rotateImage.height / 2 +
//         (crop.area.topLeft.dy + imageTranslate.dy) / scale;
//     final cropImage = copyCrop(rotateImage, x.toInt(), y.toInt(),
//         (crop.area.width ~/ scale), (crop.area.height ~/ scale));
//
//     return encodeJpg(cropImage);
//   } catch (e) {}
//   return targetByte;
// }
//
// Future<CropImageInfo> cropWithNative(
//     Uint8List targetByte, Size targetSize, CropInfo crop) async {
//   if (crop == null) return CropImageInfo(targetByte, targetSize);
//   try {
//     final double scale = crop.sourceSize.width / targetSize.width;
//     final imageTranslate = crop.translate ?? Offset.zero;
//     final degree = intDegree(crop.rotation);
//     final targetWidth = targetSize.width.toInt();
//     final targetHeight = targetSize.height.toInt();
//     final cropDx = (crop.area.topLeft.dx + imageTranslate.dx) ~/ scale;
//     final cropDy = (crop.area.topLeft.dy + imageTranslate.dy) ~/ scale;
//     final cropWidth = crop.area.width ~/ scale;
//     final cropHeight = crop.area.height ~/ scale;
//
//     if (degree == 0 && targetWidth == cropWidth && targetHeight == cropHeight)
//       return CropImageInfo(targetByte, targetSize);
//
//     final result = await WiseGalleryPlugin.crop(targetByte,
//         width: targetWidth,
//         height: targetHeight,
//         rotation: degree,
//         cropDx: cropDx,
//         cropDy: cropDy,
//         cropWidth: cropWidth,
//         cropHeight: cropHeight,
//         alignCenter: true);
//     return result;
//   } catch (e) {}
//   return CropImageInfo(targetByte, targetSize);
// }
//
// Future<Uint8List> resizeImage(
//     Uint8List source, Size sourceSize, int targetSize) async {
//   try {
//     final scaleFactor = max(1.0, sourceSize.shortestSide / targetSize);
//     if (scaleFactor == 1) {
//       return source;
//     }
//     final origin = decodeImage(source);
//     final resizedImage = copyResize(origin,
//         width: (sourceSize.width ~/ scaleFactor),
//         height: (sourceSize.height ~/ scaleFactor));
//     return encodeJpg(resizedImage);
//   } catch (e) {}
//   return source;
// }
//
// Future<Uint8List> networkImageToByte(Uri uri) async {
//   HttpClient httpClient = HttpClient();
//   final request = await httpClient.getUrl(uri);
//   final response = await request.close();
//   final bytes = await consolidateHttpClientResponseBytes(response);
//   return bytes;
// }
//
// int intDegree(double radian) {
//   double current = radian % (2 * pi);
//   if (current < 0) {
//     current = 2 * pi + current;
//   }
//   current = current * (180 / pi);
//   return current.round() % 360;
// }
//
//
// Size cropWidgetSize(BuildContext ctx,
//     {bool isSingle = false,
//     double cropPreviewHeight = WiseCropPreviewHeight,
//     double cropToolbarHeight = WiseCropToolbarHeight}) {
//   final query = MediaQuery.of(ctx);
//   final viewSize = query.size;
//   final statusBar = query.padding.top;
//   final bottomSafe = query.padding.bottom;
//   final extraHeight = (kToolbarHeight * 2) +
//       statusBar +
//       bottomSafe +
//       cropToolbarHeight +
//       (isSingle ? 0 : cropPreviewHeight);
//   return Size(viewSize.width, viewSize.height - extraHeight);
// }
//
// Rect defaultCropRect(BuildContext ctx, Size it, [bool isSingle = false]) {
//   final layoutSize = cropWidgetSize(ctx, isSingle: isSingle);
//   final ratio = containsScale(layoutSize, it);
//   return Rect.fromCenter(
//       center: Offset(layoutSize.width / 2, layoutSize.height / 2),
//       width: it.width.toDouble() * ratio,
//       height: it.height.toDouble() * ratio);
// }
//
// class LoadedImageInfo {
//   final Size size;
//   final Uint8List bytes;
//
//   LoadedImageInfo(this.size, this.bytes);
//
//   WiseImageInfo toWise() => WiseImageInfo(bytes, size);
// }
//
// Future<LoadedImageInfo> getImageFromSource(dynamic source,
//     {int targetSize = 720}) {
//   try {
//     if (source is Photo) {
//       return WiseGalleryPlugin.getOriginImage(source.uriString,
//               targetSize: targetSize)
//           .then((it) {
//         final info = it as NativeImageInfo;
//         return LoadedImageInfo(info.size, info.imageBytes);
//       });
//     } else if (source is File) {
//       return WiseGalleryPlugin.alignRotation(source.path,
//               targetSize: targetSize)
//           .then((it) {
//         final info = it as NativeImageInfo;
//         return LoadedImageInfo(info.size, info.imageBytes);
//       });
//     } else if (source is Uri && source.host.startsWith("http")) {
//       return networkImageToByte(source)
//           .then((bytes) => _getInfoFromMemory(bytes, targetSize));
//     } else if (source is String) {
//       ///  Android Image Path : /data/user/0/{packageName}/app_flutter/Pictures/{appID}/{milliseconds}.jpg
//       ///  iOS Image Path : /var/mobile/Containers/Data/Application/{packageName}/Documents/Pictures/{appID}/{milliseconds}.jpg
//       final isLocalPath =
//           source.indexOf("/Pictures/") > 0 && source.lastIndexOf("jpg") > 0;
//       if (isLocalPath) {
//         return WiseGalleryPlugin.alignRotation(source, targetSize: targetSize)
//             .then((it) {
//           final info = it as NativeImageInfo;
//           return LoadedImageInfo(info.size, info.imageBytes);
//         });
//       }
//
//       final imageUri = Uri.tryParse(source);
//       if (imageUri == null || !imageUri.host.startsWith("http"))
//         throw Exception();
//       return networkImageToByte(imageUri)
//           .then((bytes) => _getInfoFromMemory(bytes, targetSize));
//     } else if (source is Uint8List) {
//       return _getInfoFromMemory(source, targetSize);
//     } else {
//       throw Exception();
//     }
//   } catch (e) {
//     throw Exception();
//   }
// }
//
// Future<LoadedImageInfo> _getInfoFromMemory(Uint8List bytes, int targetSize) {
//   return getImageInfo(MemoryImage(bytes)).then((info) {
//     final imageSize =
//         Size(info.image.width.toDouble(), info.image.height.toDouble());
//     final scaleFactor = max(1.0, imageSize.shortestSide / targetSize);
//     if (scaleFactor == 1.0 || targetSize < 0) {
//       return LoadedImageInfo(imageSize, bytes);
//     }
//     return resizeImage(bytes, imageSize, targetSize).then((resizedByes) async {
//       return LoadedImageInfo(imageSize / scaleFactor, resizedByes);
//     });
//   });
// }
