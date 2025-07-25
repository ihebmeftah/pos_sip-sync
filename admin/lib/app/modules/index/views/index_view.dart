import 'package:admin/app/data/local/local_storage.dart';
import 'package:admin/app/modules/inventory/views/inventory_view.dart';
import 'package:admin/app/modules/order/controllers/pass_order_controller.dart';
import 'package:admin/app/modules/order/views/order_view.dart';
import 'package:admin/app/modules/tables/views/tables_view.dart';
import 'package:admin/app/routes/app_pages.dart';
import 'package:admin/main.dart';
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
      floatingActionButton: FloatingActionButton(
        onPressed: () => Get.toNamed(Routes.PASS_ORDER),
        child: GetBuilder<PassOrderController>(
          id: "table",
          builder: (passOrderCtr) {
            return Badge(
              isLabelVisible: passOrderCtr.table != null,
              label: Text("!", style: TextStyle(color: Colors.white)),
              child: SvgPicture.asset(
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
            );
          },
        ),
      ),
      drawer: Drawer(
        child: Column(
          children: [
            UserAccountsDrawerHeader(
              currentAccountPicture: CircleAvatar(),
              accountName: Text(
                '${LocalStorage().user!.firstname} ${LocalStorage().user!.lastname}',
              ),
              accountEmail: Text(LocalStorage().user!.email),
            ),
            ListTile(
              leading: Icon(Icons.place),
              title: Text('Buildings'),
              onTap: () => Get.offAllNamed(Routes.BUILDINGS),
            ),
            ListTile(
              leading: Icon(Icons.person),
              title: Text('Staff'),
              onTap: () => Get.toNamed(Routes.STAFF),
            ),
            Spacer(),
            SafeArea(
              child: ListTile(
                textColor: Colors.red,
                iconColor: Colors.red,
                leading: Icon(Icons.logout),
                title: Text('Logout'),
                onTap: () async {
                  await LocalStorage().clear();
                  Get.offAllNamed(Routes.AUTH);
                },
              ),
            ),
          ],
        ),
      ),

      appBar: AppBar(
        actions: [
          CircleAvatar(
            backgroundImage: LocalStorage().building?.logo != null
                ? NetworkImage(url + LocalStorage().building!.logo!)
                : null,
          ),
        ],
      ),
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
        children: [HomeView(), OrderView(), InventoryView(), TablesView()],
      ),
    );
  }
}
