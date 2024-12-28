import 'dart:math';
import 'package:flutter/material.dart';

class GradientUtils {
  static Alignment calculateAlignment(double angle) {
    final double radians = angle * (pi / 180);
    return Alignment(cos(radians), sin(radians));
  }
}
