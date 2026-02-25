import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:recipemate/utils/color_var.dart';

class RecipeMateCirclePainter extends CustomPainter {

  @override
  void paint(Canvas canvas, Size size) {

    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    final paintMain = Paint()
      ..color = HexColor(ColorVar.appColor)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 12
      ..strokeCap = StrokeCap.round;

    final paintLight = Paint()
      ..color = HexColor(ColorVar.appColor).withValues(alpha: 0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 10
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius - 10),
      -math.pi / 2,
      math.pi * 0.7,
      false,
      paintMain,
    );

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius - 10),
      math.pi * 0.4,
      math.pi * 0.5,
      false,
      paintLight,
    );

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius - 35),
      -math.pi / 3,
      math.pi * 0.6,
      false,
      paintLight,
    );

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius - 35),
      math.pi * 0.5,
      math.pi * 0.7,
      false,
      paintMain,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}