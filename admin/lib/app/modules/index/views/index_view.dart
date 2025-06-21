import 'package:admin/app/modules/tables/views/tables_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'package:get/get.dart';

import '../../home/views/home_view.dart';
import '../controllers/index_controller.dart';

class IndexView extends GetView<IndexController> {
  const IndexView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: GetBuilder<IndexController>(
        id: "bottomNavigationBar",
        builder: (_) {
          return BottomNavigationBar(
            items: [
              BottomNavigationBarItem(
                icon: SvgPicture.asset(
                  "assets/images/svg/dashboard.svg",
                  colorFilter: ColorFilter.mode(
                    controller.currBnb == 0
                        ? Theme.of(
                            context,
                          ).bottomNavigationBarTheme.selectedItemColor!
                        : Theme.of(
                            context,
                          ).bottomNavigationBarTheme.unselectedItemColor!,
                    BlendMode.srcIn,
                  ),
                ),
                label: 'Dashboard',
              ),
              BottomNavigationBarItem(
                icon: SvgPicture.asset(
                  "assets/images/svg/order.svg",
                  colorFilter: ColorFilter.mode(
                    controller.currBnb == 1
                        ? Theme.of(
                            context,
                          ).bottomNavigationBarTheme.selectedItemColor!
                        : Theme.of(
                            context,
                          ).bottomNavigationBarTheme.unselectedItemColor!,
                    BlendMode.srcIn,
                  ),
                ),
                label: 'Orders',
              ),
              BottomNavigationBarItem(
                icon: SvgPicture.asset(
                  "assets/images/svg/inventory.svg",
                  colorFilter: ColorFilter.mode(
                    controller.currBnb == 2
                        ? Theme.of(
                            context,
                          ).bottomNavigationBarTheme.selectedItemColor!
                        : Theme.of(
                            context,
                          ).bottomNavigationBarTheme.unselectedItemColor!,
                    BlendMode.srcIn,
                  ),
                ),
                label: 'Inventory',
              ),
              BottomNavigationBarItem(
                icon: SvgPicture.asset(
                  "assets/images/svg/table.svg",
                  colorFilter: ColorFilter.mode(
                    controller.currBnb == 3
                        ? Theme.of(
                            context,
                          ).bottomNavigationBarTheme.selectedItemColor!
                        : Theme.of(
                            context,
                          ).bottomNavigationBarTheme.unselectedItemColor!,
                    BlendMode.srcIn,
                  ),
                ),
                label: 'Tables',
              ),
            ],
            currentIndex: controller.currBnb,
            onTap: controller.changeBnbContent,
          );
        },
      ),
      body: PageView(
        onPageChanged: controller.changeBnbContent,
        controller: controller.pageVCtr,
        children: [
          HomeView(),
          Center(child: Text('Orders View')),
          Center(child: Text('Inventory View')),
          TablesView(),
        ],
      ),
    );
  }
}
