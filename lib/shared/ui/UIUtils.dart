import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UIUtils{

  static void bottomSheet(Widget bottomsheet){
    Get.bottomSheet(
        bottomsheet,
        backgroundColor: Theme.of(Get.context!).canvasColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
      enableDrag: true,
      elevation: 10
    );
  }

  static void snackBarError(String message) {
    Get.snackbar('', message,
        colorText: Theme.of(Get.context!).errorColor,
        snackPosition: SnackPosition.BOTTOM
    );
  }
}