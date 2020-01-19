// Copyright 2019 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';

import 'package:analog_clock/Objects/DrawHands.dart';
import 'package:analog_clock/Objects/MyCircle.dart';
import 'package:analog_clock/Objects/MyDashedCircle.dart';
import 'package:analog_clock/Objects/ObjectClasses.dart';
import 'package:flutter_clock_helper/model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:intl/intl.dart';
import 'package:vector_math/vector_math_64.dart' show radians;

// import 'container_hand.dart';
// import 'drawn_hand.dart';

/// Total distance traveled by a second or a minute hand, each second or minute,
/// respectively.
final radiansPerTick = radians(360 / 60);

/// Total distance traveled by an hour hand, each hour, in radians.
final radiansPerHour = radians(360 / 12);

/// A basic analog clock.
///
/// You can do better than this!
class AnalogClock extends StatefulWidget {
  const AnalogClock(this.model);

  final ClockModel model;

  @override
  _AnalogClockState createState() => _AnalogClockState();
}

class _AnalogClockState extends State<AnalogClock> {
  var _now = DateTime.now();
  var _temperature = '';
  var _temperatureRange = '';
  var _condition = '';
  var _location = '';
  Timer _timer;

  @override
  void initState() {
    super.initState();
    widget.model.addListener(_updateModel);
    // Set the initial values.
    _updateTime();
    _updateModel();
  }

  @override
  void didUpdateWidget(AnalogClock oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.model != oldWidget.model) {
      oldWidget.model.removeListener(_updateModel);
      widget.model.addListener(_updateModel);
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    widget.model.removeListener(_updateModel);
    super.dispose();
  }

  void _updateModel() {
    setState(() {
      _temperature = widget.model.temperatureString;
      _temperatureRange = '(${widget.model.low} - ${widget.model.highString})';
      _condition = widget.model.weatherString;
      _location = widget.model.location;
    });
  }

  void _updateTime() {
    setState(() {
      _now = DateTime.now();
      // Update once per second. Make sure to do it at the beginning of each
      // new second, so that the clock is accurate.
      _timer = Timer(
        Duration(seconds: 1) - Duration(milliseconds: _now.millisecond),
        _updateTime,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    
    final time = DateFormat.Hms().format(DateTime.now());
    // print(time);
    final weatherInfo = DefaultTextStyle(
      style: TextStyle(color: Colors.white),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(_temperature),
          Text(_temperatureRange),
          Text(_condition),
          Text(_location),
        ],
      ),
    );
    final maxHeight = 0.95 * 0.46;
    final referenceHeight = 1; 
    final referenceThickness = referenceHeight * 0.004;

    return Semantics.fromProperties(
      properties: SemanticsProperties(
        label: 'Analog clock with time $time',
        value: time,
      ),
      child: Container(
        color: Color(0xFF3C4043),
        child: Stack(
          children: [
            DrawHands(
              angleRadians: radiansPerHour,
              size: maxHeight,
              thickness: 1,
              color: Colors.white
            ),
            MyCircle(
              circleProperties: new GenericCircleProperties(
                  circleRadius: referenceHeight * 0.03,
                  circleStroke: PaintingStyle.fill,
                  dottedLine: false,
                  colorOfLines: <Color>[Colors.white],
                  thicknessOfLines: <double>[0.0]),
            ),
            MyCircle(
              circleProperties: new GenericCircleProperties(
                circleRadius: referenceHeight * 0.10,
                circleStroke: PaintingStyle.stroke,
                numberOfLines: 1,
                spaceBetweenLines: (referenceHeight * 0.011),
                colorOfLines: <Color>[Colors.white],
                dottedLine: false,
                thicknessOfLines: <double>[
                  referenceThickness,
                ],
              ),
            ),
            MyCircle(
              circleProperties: GenericCircleProperties(
                  circleRadius: referenceHeight * 0.16,
                  circleStroke: PaintingStyle.stroke,
                  colorOfLines: <Color>[Color(0xffFF8C00), Color(0xffFF8C00)],
                  dottedLine: false,
                  numberOfLines: 2,
                  spaceBetweenLines: referenceHeight * 0.017,
                  thicknessOfLines: <double>[
                    referenceThickness * 1,
                    referenceThickness * 1
                  ]),
            ),

            Transform.rotate(
              child: MyCircle(
                circleProperties: GenericCircleProperties(
                    circleRadius: maxHeight * 0.45,
                    circleStroke: PaintingStyle.stroke,
                    coloredKeys: true,
                    spaceBetweenLines: (referenceHeight * 0.050),
                    colorOfLines: <Color>[
                      Colors.white,
                      Colors.transparent,
                      Colors.white,
                    ],
                    keyNames: ScaleKeys(startingKey: 'F#').getFifthsList(),
                    numberOfLines: 3,
                    dottedLine: false,
                    thicknessOfLines: <double>[
                      referenceThickness * 1.7,
                      referenceThickness * 2.5,
                      referenceThickness * 1.7
                    ]),
              ),
              angle: -_now.minute * radiansPerTick,
            ),
            MyCircle(
              circleProperties: GenericCircleProperties(
                  circleRadius: maxHeight * 0.82,
                  spaceBetweenLines: (referenceHeight * 0.02),
                  circleStroke: PaintingStyle.stroke,
                  numberOfLines: 1,
                  colorOfLines: <Color>[
                    Color(0xffA99F96),
                    Color(0xffA99F96),
                  ],
                  dottedLine: false,
                  thicknessOfLines: <double>[
                    referenceThickness,
                    referenceThickness,
                  ]),
            ),
            Transform.rotate(
              child: MyCircle(
                circleProperties: GenericCircleProperties(
                  circleRadius: maxHeight * 0.85,
                  circleStroke: PaintingStyle.stroke,
                  spaceBetweenLines: (referenceHeight * 0.049),
                  numberOfLines: 3,
                  colorOfLines: <Color>[
                    Color(0xffDDA77B),
                    Colors.transparent,
                    Color(0xffDDA77B),
                  ],
                  coloredKeys: true,
                  dottedLine: false,
                  keyNames: ScaleKeys(startingKey: 'F#').getFifthsList(),
                  thicknessOfLines: <double>[
                    referenceThickness,
                    referenceThickness,
                    referenceThickness
                  ],
                ),
              ),
              angle: _now.hour * radiansPerHour,
            ),
            Transform.rotate(
              child: MyDashedCircle(
                radSize: maxHeight * 0.85 + ((referenceHeight * 0.049) * 2.3),
                color: Colors.white70,
                strokeWidth: 0.4,
              ),
              angle: _now.second * radiansPerTick,
            ),
            Positioned(
              left: 0,
              bottom: 0,
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: weatherInfo,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
