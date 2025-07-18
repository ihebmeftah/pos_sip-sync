import 'package:admin/app/common/appformfield.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/table_form_controller.dart';

class TableFormView extends GetView<TableFormController> {
  const TableFormView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('TableFormView'), centerTitle: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: controller.obx(
          (s) => Column(
            spacing: 10,
            children: [
              ...List.generate(
                controller.tables.length,
                (index) => Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      spacing: 20,
                      children: [
                        Expanded(
                          child: Divider(
                            color: Colors.grey.shade300,
                            height: 40,
                          ),
                        ),
                        Row(
                          children: [
                            Text(
                              "Zone ${index + 1}",
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                            if (controller.tables.length > 1)
                              IconButton(
                                style: IconButton.styleFrom(
                                  padding: EdgeInsets.zero,
                                  tapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                  foregroundColor: Colors.red,
                                ),
                                onPressed: () => controller.removeZone(index),
                                icon: const Icon(Icons.delete),
                              ),
                          ],
                        ),
                        Expanded(
                          child: Divider(
                            color: Colors.grey.shade300,
                            height: 60,
                          ),
                        ),
                      ],
                    ),
                    Form(
                      key: controller.tables[index].tableformKey,
                      child: Column(
                        spacing: 10,
                        children: [
                          AppFormField.label(
                            label: "Table number",
                            ctr: controller.tables[index].nb,
                            isNumeric: true,
                            pIcon: IconButton(
                              onPressed: controller.tables[index].incrementNb,
                              icon: const Icon(Icons.add),
                            ),
                            sIcon: IconButton(
                              onPressed: controller.tables[index].decrementNb,
                              icon: const Icon(Icons.remove),
                            ),
                          ),
                          AppFormField.label(
                            label: "Number of Seats",
                            ctr: controller.tables[index].nbSeat,
                            isNumeric: true,
                            pIcon: IconButton(
                              onPressed:
                                  controller.tables[index].incrementNbSeat,
                              icon: const Icon(Icons.add),
                            ),
                            sIcon: IconButton(
                              onPressed:
                                  controller.tables[index].decrementNbSeat,
                              icon: const Icon(Icons.remove),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              TextButton(
                onPressed: controller.addZone,
                child: Text("Add Zone Number ${controller.tables.length + 1}"),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: controller.createTables,
                child: const Text("Save"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
