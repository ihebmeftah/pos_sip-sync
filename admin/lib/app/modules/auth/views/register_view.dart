import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/register_controller.dart';

class RegisterView extends GetView<RegisterController> {
  const RegisterView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Theme(
        data: context.theme.copyWith(
          inputDecorationTheme: InputDecorationTheme(
            filled: true,
            fillColor: Colors.grey.shade200,
            border: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey.shade500),
              borderRadius: BorderRadius.circular(8),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey.shade500),
              borderRadius: BorderRadius.circular(8),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey.shade400),
              borderRadius: BorderRadius.circular(8),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.red.shade400),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.red.shade200),
            ),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(25.0),
          child: Column(
            spacing: 10.0,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Create Account',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              const Text(
                'Please fill in the details to create an account\nnb: This form is only for business owners',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 20),
              Form(
                key: controller.formKey,
                child: Column(
                  spacing: 16.0,
                  children: [
                    Row(
                      spacing: 17,
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: controller.fName,
                            decoration: InputDecoration(
                              labelText: 'First Name',
                              prefixIcon: const Icon(
                                FluentIcons.mail_20_regular,
                              ),
                            ),
                            keyboardType: TextInputType.emailAddress,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your first name';
                              }
                              return null;
                            },
                          ),
                        ),
                        Expanded(
                          child: TextFormField(
                            controller: controller.lName,
                            decoration: InputDecoration(
                              labelText: 'Last Name',
                              prefixIcon: const Icon(
                                FluentIcons.mail_20_regular,
                              ),
                            ),
                            keyboardType: TextInputType.emailAddress,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your last name';
                              }
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),
                    TextFormField(
                      controller: controller.email,
                      decoration: InputDecoration(
                        labelText: 'Email/Username',
                        prefixIcon: const Icon(FluentIcons.mail_20_regular),
                      ),
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your email';
                        }
                        if (!GetUtils.isEmail(value)) {
                          return 'Please enter a valid email';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: controller.phone,
                      decoration: InputDecoration(
                        labelText: 'Phone Number',
                        prefixIcon: const Icon(FluentIcons.phone_20_regular),
                      ),
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your phone number';
                        }

                        return null;
                      },
                    ),
                    GetBuilder<RegisterController>(
                      id: 'obscurePassword',
                      builder: (_) {
                        return TextFormField(
                          controller: controller.password,
                          decoration: InputDecoration(
                            labelText: 'Password',
                            prefixIcon: const Icon(
                              FluentIcons.password_20_regular,
                            ),
                            suffixIcon: IconButton(
                              icon: Icon(
                                controller.obscurePassword
                                    ? FluentIcons.eye_20_filled
                                    : FluentIcons.eye_off_20_filled,
                              ),
                              onPressed: controller.toggleObscurePwd,
                            ),
                          ),
                          obscureText: controller.obscurePassword,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your password';
                            }
                            if (value.length < 6) {
                              return 'Password must be at least 6 characters';
                            }
                            return null;
                          },
                        );
                      },
                    ),
                    GetBuilder<RegisterController>(
                      id: 'obscurePassword',
                      builder: (_) {
                        return TextFormField(
                          controller: controller.cpassword,
                          decoration: InputDecoration(
                            labelText: 'Password',
                            prefixIcon: const Icon(
                              FluentIcons.password_20_regular,
                            ),
                            suffixIcon: IconButton(
                              icon: Icon(
                                controller.obscurePassword
                                    ? FluentIcons.eye_20_filled
                                    : FluentIcons.eye_off_20_filled,
                              ),
                              onPressed: controller.toggleObscurePwd,
                            ),
                          ),
                          obscureText: controller.obscurePassword,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your password';
                            }
                            if (value != controller.password.text) {
                              return 'Passwords do not match';
                            }
                            return null;
                          },
                        );
                      },
                    ),
                    ElevatedButton(
                      onPressed: controller.onRegister,
                      child: const Text('Register'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
