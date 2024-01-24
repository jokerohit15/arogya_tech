import 'package:arogya_tech/utils/constants/colors_value.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';



class ProgressIndicatorWidget extends StatelessWidget {
  final List<int> quadrants;

  const ProgressIndicatorWidget({super.key, required this.quadrants});

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: SizedBox(
        height: 0.10.sh,
        width: 0.10.sh,
        child: CustomPaint(
          painter: ArcPainter(quadrants: quadrants),
        ),
      ),
    );
  }
}



class ArcPainter extends CustomPainter {
  final List<int> quadrants;

  ArcPainter({required this.quadrants});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = ColorsValue.progressIndicatorColor // Color of the arc
      ..style = PaintingStyle.stroke // This ensures it's only an outline
      ..strokeWidth = 15.0; // Width of the arc

    final centerX = size.width / 2;
    final centerY = size.height / 2;

    final radius = size.width / 2;

    for (final quadrant in quadrants) {
      double startAngle, sweepAngle;

      switch (quadrant) {
        case 1:
          startAngle = 0;
          sweepAngle = -1.5708; // -90 degrees in radians
          break;
        case 2:
          startAngle = -1.5708; // -90 degrees in radians
          sweepAngle = -1.5708; // -90 degrees in radians
          break;
        case 3:
          startAngle = -3.1416; // -180 degrees in radians
          sweepAngle = -1.5708; // -90 degrees in radians
          break;
        case 4:
          startAngle = 1.5708; // 90 degrees in radians
          sweepAngle = -1.5708; // -90 degrees in radians
          break;
        default:
          startAngle = 0;
          sweepAngle = 0;
          break;
      }

      canvas.drawArc(
        Rect.fromCircle(center: Offset(centerX, centerY), radius: radius),
        startAngle,
        sweepAngle,
        false, // Set this to false to only draw an arc outline
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
