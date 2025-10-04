import 'package:flutter/material.dart';
import 'package:get/get.dart';

void bottomSheet({
  required List<Widget> children,
  void Function()? onConfirm,
  String confirmeButtonText = "Confirm",
  bool topCloseButton = false,
}) => Get.bottomSheet(
  Container(
    width: double.infinity,
    padding: const EdgeInsets.all(20),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 20,
      children: [
        if (topCloseButton)
          Align(
            alignment: Alignment.topRight,
            child: IconButton(
              onPressed: Get.back,
              icon: Icon(Icons.close),
              color: Colors.red,
            ),
          ),
        ...children,
        if (onConfirm != null || !topCloseButton) Spacer(),
        if (onConfirm != null)
          Center(
            child: ElevatedButton(
              onPressed: onConfirm,
              child: Text(confirmeButtonText),
            ),
          ),
        if (!topCloseButton)
          Center(
            child: TextButton(onPressed: Get.back, child: const Text("Close")),
          ),
      ],
    ),
  ),
  backgroundColor: Colors.white,
);
