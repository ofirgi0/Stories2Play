import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'dart:math' as math;


class PageTurnEffect extends CustomPainter {
  PageTurnEffect({
    required this.amount,
    required this.image,
    this.backgroundColor = const Color(0xFFFFFFCC),
    this.radius = 0.18,
  });

  final Animation<double> amount;
  final ui.Image image;
  final Color backgroundColor;
  final double radius;

  @override
  void paint(Canvas canvas, Size size) {
    final pos = amount.value;
    final movX = (1.0 - pos) * 0.85;
    final calcR = (movX < 0.20) ? radius * movX * 5 : radius;
    final wHRatio = 1 - calcR;
    final hWRatio = image.height / image.width;
    final hWCorrection = (hWRatio - 1.0) / 2.0;

    final w = size.width;
    final h = size.height;
    final c = canvas;

    final shadowXf = (wHRatio - movX);
    final shadowSigma = Shadow.convertRadiusToSigma(8.0 + (32.0 * (1.0 - shadowXf)));

    final pageRect = Rect.fromLTRB(0.0, 0.0, w * shadowXf, h);
    c.drawRect(pageRect, Paint()..color = backgroundColor);
    c.drawRect(
      pageRect,
      Paint()
        ..color = Colors.black54
        ..maskFilter = MaskFilter.blur(BlurStyle.outer, shadowSigma),
    );

    canvas.drawRect(
      Offset.zero & size,
      Paint()..color = Colors.white, // Full white background
    );

    final paint = Paint();


// scale width of visible area based on animation
    final visibleWidth = w * (1.0 - amount.value * 0.7);

    final src = Rect.fromLTWH(0, 0, image.width.toDouble(), image.height.toDouble());
    final dst = Rect.fromLTWH(0, 0, visibleWidth, h);

    canvas.drawImageRect(image, src, dst, paint);

// add a "folding edge" color to simulate depth
    canvas.drawRect(
      Rect.fromLTWH(visibleWidth - 5, 0, 5, h),
      Paint()..color = Colors.black.withOpacity(0.2),
    );

  }

  @override
  bool shouldRepaint(PageTurnEffect oldDelegate) {
    return oldDelegate.image != image || oldDelegate.amount.value != amount.value;
  }
}
