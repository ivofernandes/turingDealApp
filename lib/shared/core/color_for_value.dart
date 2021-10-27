import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ColorForValue {
  // Singleton
  static final ColorForValue _singleton = ColorForValue._internal();
  factory ColorForValue() {
    return _singleton;
  }
  ColorForValue._internal();

  Color getColorForPriceVariation(double value){
    return getColorForBounds(value, -20, 20);
  }


  Color getColorForBounds(double value, int min, int max) {
    if(value.isNaN || value.isInfinite){
      return Colors.black;
    }

    if(value > 0){
      double green = 256 * value / max;
      double blue = (256 - green) / 8;
      double red = (256 - green) / 8;
      return Color.fromRGBO(red.toInt(), green.toInt(), blue.toInt(), 1);
    }else{
      double red = 256 * value / (min * -1);
      double blue = (256 - red) / 8;
      double green = (256 - red) / 8;
      return Color.fromRGBO(red.toInt(), green.toInt(), blue.toInt(), 1);
    }
  }
}