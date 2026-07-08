// ignore_for_file: deprecated_member_use
import 'package:flutter/material.dart';

class ZoomableWidget extends StatefulWidget {
  final Widget child;
  final bool doubleTapZoomEnabled;

  const ZoomableWidget({
    super.key,
    required this.child,
    required this.doubleTapZoomEnabled,
  });

  @override
  State<ZoomableWidget> createState() => _ZoomableWidgetState();
}

class _ZoomableWidgetState extends State<ZoomableWidget> {
  final TransformationController _transformationController = TransformationController();
  TapDownDetails? _doubleTapDetails;
  bool _isZoomed = false;

  @override
  void initState() {
    super.initState();
    _transformationController.addListener(_onTransformationChanged);
  }

  @override
  void dispose() {
    _transformationController.removeListener(_onTransformationChanged);
    _transformationController.dispose();
    super.dispose();
  }

  void _onTransformationChanged() {
    // Check if current scale is greater than 1.0
    final currentScale = _transformationController.value.row0.r;
    final isZoomedNow = currentScale > 1.0;
    if (isZoomedNow != _isZoomed) {
      setState(() {
        _isZoomed = isZoomedNow;
      });
    }
  }

  void _handleDoubleTap() {
    if (!widget.doubleTapZoomEnabled) return;

    if (_transformationController.value != Matrix4.identity()) {
      // Zoom out
      _transformationController.value = Matrix4.identity();
    } else {
      // Zoom in at double-tap position
      final position = _doubleTapDetails?.localPosition ?? Offset.zero;
      _transformationController.value = Matrix4.identity()
        ..translate(-position.dx * 1.5, -position.dy * 1.5)
        ..scale(2.5);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onDoubleTapDown: (details) => _doubleTapDetails = details,
      onDoubleTap: _handleDoubleTap,
      child: InteractiveViewer(
        transformationController: _transformationController,
        maxScale: 4.0,
        minScale: 1.0,
        panEnabled: _isZoomed, // Only enable pan gesture interception when zoomed
        scaleEnabled: true,
        child: widget.child,
      ),
    );
  }
}
