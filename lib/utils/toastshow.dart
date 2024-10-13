import 'package:flutter/material.dart';
import 'package:toastification/toastification.dart';

void showToast(String message) {
  toastification.show(
      title: Text(message),
      autoCloseDuration: const Duration(seconds: 3),
      applyBlurEffect: true,
      animationDuration: const Duration(seconds: 1),
      closeOnClick: true);
}
