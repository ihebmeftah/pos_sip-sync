import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:qr_code_scanner_plus/qr_code_scanner_plus.dart';

import '../controllers/qrscan_controller.dart';

class QrscanView extends GetView<QrscanController> {
  const QrscanView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: QRView(
        key: GlobalKey(debugLabel: 'QR'),
        onQRViewCreated: controller.onQRViewCreated,
        overlay: QrScannerOverlayShape(
          borderColor: Colors.blue.shade900,
          borderRadius: 10,
          borderLength: 30,
          borderWidth: 15,
        ),
      ),
    );
  }
}
