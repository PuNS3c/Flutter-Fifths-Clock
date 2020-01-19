
import 'dart:math';
import 'package:flutter/widgets.dart';

const int _DefaultDashes = 60;
const Color _DefaultColor = Color(0);
const double _DefaultGapSize = 1.0;
const double _DefaultStrokeWidth = 2.5;

class MyDashedCircle extends StatelessWidget {
  final int dashes;
  final Color color;
  final double gapSize;
  final double strokeWidth;
  final Widget child;
  final double radSize;

  MyDashedCircle(
      {this.child,
      this.dashes = _DefaultDashes,
      this.color = _DefaultColor,
      this.gapSize = _DefaultGapSize,
      @required this.radSize,
      this.strokeWidth = _DefaultStrokeWidth});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        children: <Widget>[
          SizedBox.expand(
                child: CustomPaint(
              painter: MyDashedCirclePainter(
                  radSize: radSize,
                  dashes: dashes,
                  color: color,
                  gapSize: gapSize,
                  strokeWidth: strokeWidth),
            ),
          ),
        ],
      ),
    );
  }
}

class MyDashedCirclePainter extends CustomPainter {
  final int dashes;
  final Color color;
  final double gapSize;
  final double strokeWidth;
  final double radSize;

  MyDashedCirclePainter(
      {this.dashes = _DefaultDashes,
      this.color = _DefaultColor,
      this.radSize,
      this.gapSize = _DefaultGapSize,
      this.strokeWidth = _DefaultStrokeWidth});

  @override
  void paint(Canvas canvas, Size size) {
    final double gap = pi / 90 * gapSize;
    final double singleAngle = (pi * 2) / dashes;
    var middleOf = Offset(size.width / 2, size.height / 2);
    var realRadSize = radSize * size.height;
    var leftRectPoint = Offset(middleOf.dx-realRadSize, middleOf.dy-realRadSize);
    var rightRectPoint = Offset(middleOf.dx+realRadSize, middleOf.dy+realRadSize);
    

    for (int i = 0; i < dashes; i++) {
      final Paint paint = Paint()
        ..color = color
        ..strokeWidth = strokeWidth
        ..style = PaintingStyle.stroke;
        print ("shed: "+size.height.toString());
        // canvas.drawRect(Rect.fromLTRB(leftRectPoint.dx, leftRectPoint.dy, rightRectPoint.dx, rightRectPoint.dy), paint);
      canvas.drawArc(Rect.fromLTRB(leftRectPoint.dx, leftRectPoint.dy, rightRectPoint.dx, rightRectPoint.dy), gap + singleAngle * i,
          singleAngle - gap * 2, false, paint);
    }

    
  }

  @override
  bool shouldRepaint(MyDashedCirclePainter oldDelegate) {
    return dashes != oldDelegate.dashes || color != oldDelegate.color;
  }
}
