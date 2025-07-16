import 'package:admin/app/common/appbottomsheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:get/get.dart';

import '../../../data/model/enums/table_status.dart';
import '../controllers/tables_controller.dart';
import '../widgets/tableitemwidget.dart';
import '../widgets/tablestatuswidget.dart';

class TablesView extends GetView<TablesController> {
  const TablesView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: controller.obx(
          (_) => Column(
            children: [
              Row(
                spacing: 20,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TableStatusWidget(
                    color: Colors.greenAccent,
                    status: "Available (${controller.availableNb})",
                  ),
                  TableStatusWidget(
                    color: Colors.brown.shade700,
                    status: "Occupied (${controller.occupiedNb})",
                  ),
                  //   TableStatusWidget(color: Colors.red, status: "Reserved (3)"),
                ],
              ),
              Expanded(
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10,
                  ),
                  itemCount: controller.tables.length,
                  itemBuilder: (context, index) => TableItemWidget(
                    onTap: () {
                      bottomSheet(
                        onConfirm: () {},
                        confirmeButtonText: "Pass Order",
                        children: [
                          Row(
                            spacing: 20,
                            children: [
                              SvgPicture.asset(
                                'assets/images/svg/table.svg',
                                width: 30,
                                height: 30,
                                colorFilter: ColorFilter.mode(
                                  Colors.black,
                                  BlendMode.srcIn,
                                ),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    controller.tables[index].name
                                        .split('.')
                                        .first,
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  Text(
                                    "Max seats ${controller.tables[index].seatsMax}",
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.grey.shade600,
                                    ),
                                  ),
                                ],
                              ),
                              Spacer(),
                              Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color:
                                      controller.tables[index].status ==
                                          TableStatus.occupied
                                      ? Colors.red.shade700
                                      : Colors.greenAccent.shade700,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Center(
                                  child: Text(
                                    "${controller.tables[index].status.name.capitalize}",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          ListTile(
                            leading: Icon(Icons.music_note),
                            title: Text('View & Edit'),
                            onTap: () => {},
                          ),
                          ListTile(
                            leading: Icon(Icons.videocam),
                            title: Text('Video'),
                            onTap: () => {},
                          ),
                        ],
                      );
                    },
                    table: controller.tables[index],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
