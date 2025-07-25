import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../../common/appformfield.dart';
import '../../../common/fileupload/views/fileupload_view.dart';
import '../controllers/staff_form_controller.dart';

class StaffFormView extends GetView<StaffFormController> {
  const StaffFormView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Staff'), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: controller.formKey,
          child: Column(
            spacing: 20,
            children: [
              FileuploadView(uploadType: UploadType.image),
              Row(
                spacing: 10,
                children: [
                  Expanded(
                    child: AppFormField.label(
                      label: "First Name",
                      hint: "Enter first name",
                      ctr: controller.fname,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "First Name is required";
                        }
                        return null;
                      },
                    ),
                  ),
                  Expanded(
                    child: AppFormField.label(
                      label: "Last Name",
                      hint: "Enter last name",
                      ctr: controller.lname,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Last Name is required";
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              AppFormField.label(
                label: "Email",
                hint: "Enter email",
                ctr: controller.email,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Email is required";
                  }
                  if (!GetUtils.isEmail(value)) {
                    return "Invalid email format";
                  }
                  return null;
                },
              ),
              AppFormField.label(
                label: "Password",
                hint: "Enter password",
                ctr: controller.password,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Password is required";
                  }
                  return null;
                },
              ),
              AppFormField.label(
                label: "Phone Number",
                hint: "Enter phone number",
                ctr: controller.phone,
                isNumeric: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Phone Number is required";
                  }
                  return null;
                },
              ),
              const Spacer(),
              ElevatedButton(
                onPressed: controller.createEmployyer,
                child: const Text("Add Employer"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
