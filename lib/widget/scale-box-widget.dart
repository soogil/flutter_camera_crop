import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class ScaleBox extends SingleChildRenderObjectWidget {
  const ScaleBox({
    Key key,
    this.isVertical = true,
    Widget child,
  }) : assert(isVertical != null),
        super(key: key, child: child);

  final bool isVertical;

  @override
  RenderRotatedBox2 createRenderObject(BuildContext context) => RenderRotatedBox2(isVertical: isVertical);

  @override
  void updateRenderObject(BuildContext context, RenderRotatedBox2 renderObject) {
    renderObject.isVertical = !isVertical;
  }
}

class RenderRotatedBox2 extends RenderBox with RenderObjectWithChildMixin<RenderBox> {
  RenderRotatedBox2({
    @required bool isVertical,
    RenderBox child,
  }) : assert(isVertical != null),
        _isVertical = isVertical {
    this.child = child;
  }

  bool _isVertical;

  set isVertical(bool value) {
    if (_isVertical == value) return;
    _isVertical = value;
    markNeedsLayout();
  }

  bool get isVertical => _isVertical;

  @override
  double computeMinIntrinsicWidth(double height) {
    if (child == null)
      return 0.0;
    return _isVertical ? child?.getMinIntrinsicHeight(height) : child?.getMinIntrinsicWidth(height);
  }

  @override
  double computeMaxIntrinsicWidth(double height) {
    if (child == null)
      return 0.0;
    return _isVertical ? child?.getMaxIntrinsicHeight(height) : child?.getMaxIntrinsicWidth(height);
  }

  @override
  double computeMinIntrinsicHeight(double width) {
    if (child == null)
      return 0.0;
    return _isVertical ? child?.getMinIntrinsicWidth(width) : child?.getMinIntrinsicHeight(width);
  }

  @override
  double computeMaxIntrinsicHeight(double width) {
    if (child == null)
      return 0.0;
    return _isVertical ? child?.getMaxIntrinsicWidth(width) : child?.getMaxIntrinsicHeight(width);
  }

  Matrix4 _paintTransform;

  @override
  void performLayout() {
    _paintTransform = null;
    if (child != null) {
      child?.layout(_isVertical ? constraints.flipped : constraints, parentUsesSize: true);
      size = _isVertical ? Size(child?.size.height, child?.size.width) : child?.size;
      _paintTransform = Matrix4.identity()
        ..translate(size.width / 2.0, size.height / 2.0)
        ..translate(-child?.size.width / 2.0, -child?.size.height / 2.0);
    } else {
      performResize();
    }
  }

  @override
  bool hitTestChildren(BoxHitTestResult result, { @required Offset position }) {
    assert(_paintTransform != null || debugNeedsLayout || child == null);
    if (child == null || _paintTransform == null)
      return false;
    return result.addWithPaintTransform(
      transform: _paintTransform,
      position: position,
      hitTest: (BoxHitTestResult result, Offset position) {
        return child?.hitTest(result, position: position);
      },
    );
  }

  void _paintChild(PaintingContext context, Offset offset) {
    context.paintChild(child, offset);
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    if (child != null)
      context.pushTransform(needsCompositing, offset, _paintTransform, _paintChild);
  }

  @override
  void applyPaintTransform(RenderBox child, Matrix4 transform) {
    if (_paintTransform != null)
      transform.multiply(_paintTransform);
    super.applyPaintTransform(child, transform);
  }
}
