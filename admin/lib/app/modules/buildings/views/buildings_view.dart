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
      appBar: AppBar(
        title: const Text('Your Buildings'),
        actions: [
          GetBuilder<BuildingsController>(
            builder: (_) {
              return Switch.adaptive(
                activeColor: Colors.grey.shade300,
                thumbIcon: WidgetStateProperty.resolveWith(
                  (states) => states.contains(WidgetState.selected)
                      ? const Icon(FluentIcons.list_24_regular)
                      : const Icon(FluentIcons.grid_24_regular),
                ),
                value: controller.dispList,
                onChanged: (_) => controller.toggleDisplay(),
              );
            },
          ),
        ],
      ),
      body: controller.obx(
        (state) => controller.dispList
            ? GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                ),
                itemCount: state?.length ?? 0,
                itemBuilder: (context, index) {
                  final building = state![index];
                  return Card(
                    child: Column(
                      children: [
                        CircleAvatar(
                          backgroundImage: building.logo != null
                              ? NetworkImage(
                                  "http://localhost:3000/${building.logo!}",
                                )
                              : null,
                          child: building.logo == null
                              ? const Icon(FluentIcons.building_24_regular)
                              : null,
                        ),
                        Text(building.name),
                        Text(building.location),
                        Text(
                          '${building.openingTime} - ${building.closingTime}',
                          style: const TextStyle(fontSize: 12),
                        ),
                      ],
                    ),
                  );
                },
              )
            : ListView.builder(
                itemCount: state?.length ?? 0,
                itemBuilder: (context, index) {
                  final building = state![index];
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundImage: building.logo != null
                          ? NetworkImage(
                              "http://localhost:3000/${building.logo!}",
                            )
                          : null,
                      child: building.logo == null
                          ? const Icon(FluentIcons.building_24_regular)
                          : null,
                    ),
                    title: Text(building.name),
                    subtitle: Text(
                      '${building.location} ${building.openingTime} - ${building.closingTime}',
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
      ),
    );
  }
}
