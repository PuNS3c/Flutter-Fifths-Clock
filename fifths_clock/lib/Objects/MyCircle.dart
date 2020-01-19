import 'dart:ui';

import 'dart:math';
import 'package:flutter/widgets.dart';
import 'package:analog_clock/Objects/ObjectClasses.dart';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:vector_math/vector_math_64.dart' show radians;

// import 'package:dashed_circle/dashed_circle.dart';

class MyCircle extends StatelessWidget {
  MyCircle({Key key, @required this.circleProperties}) : super(key: key);

  final GenericCircleProperties circleProperties;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        children: <Widget>[
          SizedBox.expand(
            child: CustomPaint(
              painter: CirclePainter(circleProperties: circleProperties),
            ),
          ),
        ],
      ),
    );
  }
}

class CirclePainter extends CustomPainter {
  CirclePainter({@required this.circleProperties});

  GenericCircleProperties circleProperties;
  @override
  void paint(Canvas canvas, Size size) {
    // Do this here so height will be of canvas and nt device
    circleProperties.circleRadius = circleProperties.circleRadius * size.height;
    for (int i = 0; i < circleProperties.thicknessOfLines.length; i++) {
      circleProperties.thicknessOfLines[i] =
          circleProperties.thicknessOfLines[i] * size.height;
    }
    circleProperties.spaceBetweenLines =
        (circleProperties.spaceBetweenLines * size.height).toInt();

    // Vars for calculations
    var middleOf = Offset(size.width / 2, size.height / 2);
    var radForLetters;
    final center = (Offset.zero & size).center;
    final radiansPerHour = radians((360 / 12));
    final smallRadius =
        size.height * 0.030 + circleProperties.circleRadius * 5 * 0.006;

    circleProperties.numberOfLines == 3
        ? radForLetters =
            circleProperties.circleRadius + circleProperties.spaceBetweenLines
        : radForLetters = circleProperties.circleRadius;

    // Paint Lines
    returnPaintLines(canvas, middleOf, size);

    // Draw circular Key Names
    returnDrawCircKeyNames(
        smallRadius, center, radiansPerHour, radForLetters, canvas);
  }

  void returnDrawCircKeyNames(double smallRadius, Offset center,
      double radiansPerHour, radForLetters, Canvas canvas) {
    if (circleProperties.keyNames != null ||
        circleProperties.coloredKeys == true) {
      var smallPaintFill = new Paint()
        ..style = PaintingStyle.fill
        ..color = Colors.black;
      var smallPaintBorder = new Paint()
        ..style = PaintingStyle.stroke
        ..color = Colors.white
        ..strokeWidth = smallRadius * 0.20;

      final paragraphStyle = new ui.ParagraphStyle(
        fontSize: smallRadius,
        textAlign: TextAlign.left,
      );

      final paragraphBuilder = new ui.ParagraphBuilder(paragraphStyle)
        ..pushStyle(new ui.TextStyle(
          color: Colors.white,
          fontSize: smallRadius,
        ));

      List<Color> colors = [
        Color(0xff3366ff),
        Color(0xff2170ba),
        Color(0xff07acec),
        Color(0xff2db590),
        Color(0xff2db475),
        Color(0xffd1de1c),
        Color(0xfff15e27),
        Color(0xffec1b24),
        Color(0xffb81830),
        Color(0xff9c1a62),
        Color(0xff922585),
        Color(0xff632c90),
      ];

      // Draw the Key Circles
      for (int i = 0; i <= 11; i++) {
        var position = center +
            Offset(math.cos(radiansPerHour * i), math.sin(radiansPerHour * i)) *
                radForLetters;

        // Draw Key Circle
        if (circleProperties.coloredKeys == true) {
          canvas.drawCircle(
              position, smallRadius, smallPaintBorder..color = colors[i]);
        }
        canvas.drawCircle(position, smallRadius, smallPaintFill);
        canvas.drawCircle(position, smallRadius, smallPaintBorder);

        if (circleProperties.keyNames.length > 1) {
          // Buil paragraph
          paragraphBuilder..addText(circleProperties.keyNames[i]);
          var paragraph = paragraphBuilder.build();
          paragraph.layout(new ui.ParagraphConstraints(width: smallRadius * 2));
          // Algiment is diffrent due to key name
          if (circleProperties.keyNames[i].length == 2) {
            canvas.drawParagraph(
              paragraph,
              Offset(position.dx - smallRadius * 0.6,
                  position.dy - smallRadius * 0.55),
            );
          } else {
            canvas.drawParagraph(
              paragraph,
              Offset(position.dx - smallRadius * 0.35,
                  position.dy - smallRadius * 0.55),
            );
          }
        }
      }
    }
  }

  void returnPaintLines(Canvas canvas, Offset middleOf, Size size) {
    for (int i = 0; i < circleProperties.numberOfLines; i++) {
      var fillColor = new Paint()
        ..style = circleProperties.circleStroke
        ..strokeWidth = circleProperties.thicknessOfLines[i]
        ..color = circleProperties.colorOfLines[i];

      // Check if dotted or not
      if (circleProperties.dottedLine == false) {
        canvas.drawCircle(middleOf, circleProperties.circleRadius, fillColor);
      } else {
        final gapSize = 1.0;
        final dashes = 60;

        final double gap = pi / 90 * gapSize;
        final double singleAngle = (pi * 2) / dashes;
        var middleOf = Offset(size.width / 2, size.height / 2);
        var realRadSize = circleProperties.circleRadius;
        var leftRectPoint =
            Offset(middleOf.dx - realRadSize, middleOf.dy - realRadSize);
        var rightRectPoint =
            Offset(middleOf.dx + realRadSize, middleOf.dy + realRadSize);

        for (int i = 0; i < dashes; i++) {
          final Paint paint = Paint()
            ..color = circleProperties.colorOfLines[0]
            ..strokeWidth = circleProperties.thicknessOfLines[0]
            ..style = PaintingStyle.stroke;
          // print("This is dashed: " + size.height.toString());
          // canvas.drawRect(Rect.fromLTRB(leftRectPoint.dx, leftRectPoint.dy, rightRectPoint.dx, rightRectPoint.dy), paint);
          canvas.drawArc(
              Rect.fromLTRB(leftRectPoint.dx, leftRectPoint.dy,
                  rightRectPoint.dx, rightRectPoint.dy),
              gap + singleAngle * i,
              singleAngle - gap * 2,
              false,
              paint);
        }
      }

      circleProperties.circleRadius =
          circleProperties.circleRadius + circleProperties.spaceBetweenLines;
    }
  }

  @override
  bool shouldRepaint(CirclePainter oldDelegate) => false;

  @override
  bool shouldRebuildSemantics(CirclePainter oldDelegate) => false;
}
