import 'package:flutter/material.dart';
import 'package:get/get.dart';

bottomSheet({
  required List<Widget> children,
  void Function()? onConfirm,
  String confirmeButtonText = "Confirm",
  bool topCloseButton = false,
}) => Get.bottomSheet(
  Container(
    padding: const EdgeInsets.all(20),
    child: Column(
      children: [
        ...children,
        if (onConfirm != null || !topCloseButton) Spacer(),
        if (onConfirm != null)
          ElevatedButton(onPressed: onConfirm, child: Text(confirmeButtonText)),
        if (!topCloseButton)
          TextButton(onPressed: Get.back, child: const Text("Close")),
      ],
    ),
  ),

  backgroundColor: Colors.white,
);
