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
