import 'package:admin/app/common/appbottomsheet.dart';
import 'package:admin/app/common/appemptyscreen.dart';
import 'package:admin/app/data/local/local_storage.dart';
import 'package:admin/app/routes/app_pages.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/buildings_controller.dart';

class BuildingsView extends GetView<BuildingsController> {
  const BuildingsView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () => Get.toNamed(Routes.BUILDING_ADD),
        child: const Icon(FluentIcons.add_24_regular),
      ),
      appBar: AppBar(title: const Text('Your Buildings')),
      body: controller.obx(
        (state) => ListView.builder(
          itemCount: state?.length ?? 0,
          itemBuilder: (context, index) {
            final building = state![index];
            return ListTile(
              onTap: () async {
                bottomSheet(
                  children: [
                    Text(
                      "Building: ${building.name}",
                      style: context.textTheme.titleLarge,
                    ),
                    /*        if (building.photos != null)
                      SizedBox(
                        height: 200,
                        width: double.infinity,
                        child: CarouselView(
                          itemExtent: 350,
                          children: List.generate(
                            controller.buildings[index].photos!.length,
                            (i) => Image.network(
                              "$url${controller.buildings[index].photos![i]}",
                              fit: BoxFit.fill,
                            ),
                          ),
                        ),
                      ), */
                  ],
                );
              },
              leading: CircleAvatar(
                child: const Icon(FluentIcons.building_24_regular),
              ),
              title: Text(building.name),
              subtitle: Text(
                '${building.location} ${building.openAt} - ${building.closeAt}',
              ),
              trailing: TextButton(
                onPressed: () async {
                  await LocalStorage().saveBuilding(building);
                  Get.offAllNamed(Routes.INDEX);
                },
                child: Text("Consult"),
              ),
            );
          },
        ),
        onEmpty: Appemptyscreen(),
      ),
    );
  }
}
