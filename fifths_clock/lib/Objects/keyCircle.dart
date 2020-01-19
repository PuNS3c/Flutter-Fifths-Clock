import 'dart:ui';

import 'package:flutter/material.dart';
import 'dart:ui' as ui;

class KeyCircle extends StatelessWidget {
  const KeyCircle({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Container(
        child: CustomPaint(
          painter: KeyCirclePainter(),
          child: Text("Eb"),
        ),
      ),
    );
  }
}

class KeyCirclePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var cPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..color = Colors.orange;

    // var par = ParagraphBuilder(ParagraphStyle(textDirection: TextDirection.ltr))..addText("text");
    // var parB = par.build()..layout(constraints);

    final ui.ParagraphBuilder paragraphBuilder = ui.ParagraphBuilder(
      ui.ParagraphStyle(textDirection: ui.TextDirection.ltr),
    )..addText('Eb');
    final ui.Paragraph paragraph = paragraphBuilder.build()
      ..layout(ui.ParagraphConstraints(width: 25));

    canvas.drawCircle(Offset(100, 10), 10, cPaint);
    canvas.drawParagraph(paragraph, Offset(100, 10));
  }

  @override
  bool shouldRepaint(KeyCirclePainter oldDelegate) => false;

  @override
  bool shouldRebuildSemantics(KeyCirclePainter oldDelegate) => false;
}
