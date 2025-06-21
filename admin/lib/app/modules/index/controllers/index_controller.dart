import 'package:flutter/material.dart';
import 'package:get/get.dart';

class IndexController extends GetxController {
  final pageVCtr = PageController();
  int currBnb = 0;

  void changeBnbContent(int index) {
    currBnb = index;
    pageVCtr.jumpToPage(index);
    update(["bottomNavigationBar"]);
  }
}
