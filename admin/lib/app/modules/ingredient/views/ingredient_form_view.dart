import 'package:admin/app/common/appdropdown.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../../common/appformfield.dart';
import '../../../data/model/enums/units_type.dart';
import '../controllers/ingredient_form_controller.dart';

class IngredientFormView extends GetView<IngredientFormController> {
  const IngredientFormView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('IngredientFormView'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: controller.ingFormKey,
          child: Column(
            spacing: 20,
            children: [
              AppFormField.label(
                label: "Ingredient Name",
                hint: "Enter ingredient name",
                ctr: controller.name,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Name is required";
                  }
                  return null;
                },
              ),
              AppDropdown.label(
                items: UnitsType.values
                    .map(
                      (e) => DropdownMenuItem<UnitsType>(
                        value: e,
                        child: Text(e.name),
                      ),
                    )
                    .toList(),
                selectedItem: controller.selectedUnit,
                onChanged: controller.selectUnit,
                label: "Unit Type",
                hint: "Select unit type",
                validator: (value) {
                  if (value == null) {
                    return "Unit type is required";
                  }
                  return null;
                },
              ),
              Row(
                spacing: 5,
                children: [
                  Expanded(
                    child: AppFormField.label(
                      label: "Current Stock",
                      hint: "Enter current stock",
                      ctr: controller.currentStock,
                      isNumeric: true,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Current stock is required";
                        }
                        if (num.tryParse(value) == null) {
                          return "Enter a valid number";
                        }
                        return null;
                      },
                    ),
                  ),
                  Expanded(
                    child: AppFormField.label(
                      label: "Minimum Stock",
                      hint: "Enter minimum stock",
                      ctr: controller.minimumStock,
                      isNumeric: true,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Minimum stock is required";
                        }
                        if (num.tryParse(value) == null) {
                          return "Enter a valid number";
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              AppFormField.label(
                label: "Description",
                hint: "Enter ingredient description",
                minLines: 3,
                ctr: controller.desc,
              ),
              Spacer(),
              ElevatedButton(
                onPressed: controller.createIngredient,
                child: const Text("Add Ingredient"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
