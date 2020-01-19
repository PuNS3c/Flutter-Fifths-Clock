import 'package:flutter/material.dart';

class GenericCircleProperties {
  GenericCircleProperties(
      {@required this.dottedLine,
      this.numberOfLines = 1,
      this.spaceBetweenLines = 0,
      @required this.colorOfLines,
      @required this.thicknessOfLines,
      @required this.circleRadius,
      @required this.circleStroke,
      this.keyNames, 
      this.coloredKeys=false,
      this.angleRadians=1.0
      });

  bool dottedLine;
  dynamic spaceBetweenLines;
  double circleRadius;
  PaintingStyle circleStroke;
  int numberOfLines;
  List<Color> colorOfLines;
  List<double> thicknessOfLines;
  List<String> keyNames;
  bool coloredKeys;
  double angleRadians; 


}

class ScaleKeys {
  ScaleKeys ({@required this.startingKey});

  String startingKey;

  Color keyBgClolr;
  Color keyTextColor;
  double keyRadius;

  List<String> _fifths = [
    'C',
    'G',
    'D',
    'A',
    'E',
    'B',
    'F#',
    'C#',
    'G#',
    'Db',
    'Bb',
    'F',
  ];

  List<String> getFifthsList() {
    int indexOfStartingKey = _fifths.indexOf(startingKey);
    int listEnd = _fifths.length;
    return _fifths.sublist(indexOfStartingKey, listEnd)
      ..addAll(_fifths.sublist(0, indexOfStartingKey));
  }
}


