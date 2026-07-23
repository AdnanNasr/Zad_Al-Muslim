import 'dart:math' as math;
import 'package:flutter/material.dart';

/// رسم بوصلة القبلة المخصصة بالكامل بكود Dart خالص — لا توجد صور خارجية
class QiblaCompassPainter extends CustomPainter {
  /// زاوية سهم القبلة بالراديان (محسوبة مسبقاً)
  final double needleAngleRad;

  /// لون السهم الأخضر (يتجه نحو القبلة)
  final Color qiblaColor;

  /// لون الإطار الخارجي للبوصلة
  final Color ringColor;

  /// لون نص الاتجاهات (N, S, E, W)
  final Color labelColor;

  const QiblaCompassPainter({
    required this.needleAngleRad,
    required this.qiblaColor,
    required this.ringColor,
    required this.labelColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    _drawRing(canvas, center, radius);
    _drawTicks(canvas, center, radius);
    _drawCardinalLabels(canvas, center, radius);
    _drawNeedle(canvas, center, radius);
    _drawKaabaIcon(canvas, center, radius);
    _drawCenterDot(canvas, center);
  }

  /// الحلقة الخارجية
  void _drawRing(Canvas canvas, Offset center, double radius) {
    final paint = Paint()
      ..color = ringColor.withValues(alpha: .25)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5;
    canvas.drawCircle(center, radius - 4, paint);

    // حلقة داخلية خفية
    canvas.drawCircle(
      center,
      radius * 0.75,
      Paint()
        ..color = ringColor.withValues(alpha: .06)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1,
    );
  }

  /// خطوط التدريج على حافة البوصلة
  void _drawTicks(Canvas canvas, Offset center, double radius) {
    final majorPaint = Paint()
      ..color = ringColor.withValues(alpha: .5)
      ..strokeWidth = 1.5;
    final minorPaint = Paint()
      ..color = ringColor.withValues(alpha: .25)
      ..strokeWidth = 0.8;

    for (int i = 0; i < 360; i += 5) {
      final isMajor = i % 45 == 0;
      final tickLen = isMajor ? radius * 0.10 : radius * 0.05;
      final angle = i * math.pi / 180.0;

      final outer = Offset(
        center.dx + (radius - 6) * math.sin(angle),
        center.dy - (radius - 6) * math.cos(angle),
      );
      final inner = Offset(
        center.dx + (radius - 6 - tickLen) * math.sin(angle),
        center.dy - (radius - 6 - tickLen) * math.cos(angle),
      );

      canvas.drawLine(outer, inner, isMajor ? majorPaint : minorPaint);
    }
  }

  /// نصوص الاتجاهات الأربعة
  void _drawCardinalLabels(Canvas canvas, Offset center, double radius) {
    const labels = {0: 'N', 90: 'E', 180: 'S', 270: 'W'};
    const arabicLabels = {0: 'شمال', 90: 'شرق', 180: 'جنوب', 270: 'غرب'};

    labels.forEach((deg, label) {
      final arabicLabel = arabicLabels[deg]!;
      final angle = deg * math.pi / 180.0;
      final pos = Offset(
        center.dx + (radius * 0.62) * math.sin(angle),
        center.dy - (radius * 0.62) * math.cos(angle),
      );

      final textPainter = TextPainter(
        text: TextSpan(
          text: arabicLabel,
          style: TextStyle(
            color: deg == 0 ? qiblaColor.withValues(alpha: .8) : labelColor,
            fontSize: radius * 0.10,
            fontWeight: FontWeight.w700,
            fontFamily: 'Cairo',
          ),
        ),
        textDirection: TextDirection.rtl,
      );
      textPainter.layout();
      textPainter.paint(
        canvas,
        pos - Offset(textPainter.width / 2, textPainter.height / 2),
      );
    });
  }

  /// سهم القبلة (مدوّر بزاوية needleAngleRad)
  void _drawNeedle(Canvas canvas, Offset center, double radius) {
    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.rotate(needleAngleRad);

    final arrowLength = radius * 0.55;
    final arrowWidth = radius * 0.06;

    // الجزء العلوي (يشير نحو القبلة)
    final qiblaPaint = Paint()
      ..color = qiblaColor
      ..style = PaintingStyle.fill;

    final topArrow = Path()
      ..moveTo(0, -arrowLength)
      ..lineTo(-arrowWidth, 0)
      ..lineTo(arrowWidth, 0)
      ..close();
    canvas.drawPath(topArrow, qiblaPaint);

    // الجزء السفلي (الذيل)
    final tailPaint = Paint()
      ..color = labelColor.withValues(alpha: .35)
      ..style = PaintingStyle.fill;

    final bottomArrow = Path()
      ..moveTo(0, arrowLength * 0.45)
      ..lineTo(-arrowWidth * 0.7, 0)
      ..lineTo(arrowWidth * 0.7, 0)
      ..close();
    canvas.drawPath(bottomArrow, tailPaint);

    canvas.restore();
  }

  /// أيقونة الكعبة المبسطة (مرسومة بكود) عند رأس السهم
  void _drawKaabaIcon(Canvas canvas, Offset center, double radius) {
    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.rotate(needleAngleRad);

    final iconY = -(radius * 0.55) - (radius * 0.10);
    final boxSize = radius * 0.13;

    // مستطيل الكعبة (أسود مع حدة ذهبية)
    final boxRect = Rect.fromCenter(
      center: Offset(0, iconY),
      width: boxSize,
      height: boxSize * 1.1,
    );

    canvas.drawRRect(
      RRect.fromRectAndRadius(boxRect, Radius.circular(boxSize * 0.15)),
      Paint()..color = const Color(0xFF1A1A1A),
    );

    // الإطار الذهبي الخارجي
    canvas.drawRRect(
      RRect.fromRectAndRadius(boxRect, Radius.circular(boxSize * 0.15)),
      Paint()
        ..color = const Color(0xFFD4AF37)
        ..style = PaintingStyle.stroke
        ..strokeWidth = boxSize * 0.12,
    );

    // خط الغطاء الذهبي (Kiswa strip)
    canvas.drawLine(
      Offset(-boxSize / 2 + 1, iconY - boxSize * 0.15),
      Offset(boxSize / 2 - 1, iconY - boxSize * 0.15),
      Paint()
        ..color = const Color(0xFFD4AF37)
        ..strokeWidth = boxSize * 0.08,
    );

    canvas.restore();
  }

  /// النقطة المركزية
  void _drawCenterDot(Canvas canvas, Offset center) {
    canvas.drawCircle(center, 8, Paint()..color = qiblaColor);
    canvas.drawCircle(center, 4, Paint()..color = Colors.white);
  }

  @override
  bool shouldRepaint(QiblaCompassPainter oldDelegate) =>
      oldDelegate.needleAngleRad != needleAngleRad ||
      oldDelegate.qiblaColor != qiblaColor ||
      oldDelegate.ringColor != ringColor ||
      oldDelegate.labelColor != labelColor;
}
