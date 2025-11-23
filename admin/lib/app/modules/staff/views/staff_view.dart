import 'package:admin/app/common/appemptyscreen.dart';
import 'package:admin/app/routes/app_pages.dart';
import 'package:admin/themes/apptheme.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/staff_controller.dart';

class StaffView extends GetView<StaffController> {
  const StaffView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Staff Management'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: IconButton(
              color: Colors.white,
              onPressed: () => Get.toNamed(Routes.STAFF_FORM),
              style: IconButton.styleFrom(
                backgroundColor: AppTheme().primary,
                padding: const EdgeInsets.all(12),
              ),
              icon: const Icon(FluentIcons.add_12_filled, size: 20),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: controller.obx(
          (state) => GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.75,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
            ),
            itemCount: controller.employers.length,
            itemBuilder: (context, index) {
              final employer = controller.employers[index];
              return InkWell(
                onTap: () =>
                    Get.toNamed("${Routes.STAFF_DETAILS}/${employer.id}"),
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.08),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      // Header Section with Avatar
                      Container(
                        height: 120,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              AppTheme().primary.withValues(alpha: 0.1),
                              AppTheme().primary.withValues(alpha: 0.05),
                            ],
                          ),
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(16),
                            topRight: Radius.circular(16),
                          ),
                        ),
                        child: Center(
                          child: Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 3),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.1),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: CircleAvatar(
                              radius: 40,
                              backgroundColor: AppTheme().primary,
                              foregroundColor: Colors.white,
                              backgroundImage: employer.photo != null
                                  ? NetworkImage(employer.photo!)
                                  : null,
                              child: employer.photo == null
                                  ? Text(
                                      '${employer.firstname[0].toUpperCase()}${employer.lastname[0].toUpperCase()}',
                                      style: const TextStyle(
                                        fontSize: 28,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    )
                                  : null,
                            ),
                          ),
                        ),
                      ),
                      // Content Section
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // Full Name
                              Text(
                                '${employer.firstname} ${employer.lastname}',
                                style: Theme.of(context).textTheme.titleMedium
                                    ?.copyWith(fontWeight: FontWeight.bold),
                                textAlign: TextAlign.center,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 8),
                              // Username
                              if (employer.username != null)
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      FluentIcons.person_12_regular,
                                      size: 14,
                                      color: AppTheme().primary,
                                    ),
                                    const SizedBox(width: 4),
                                    Flexible(
                                      child: Text(
                                        '@${employer.username}',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodySmall
                                            ?.copyWith(
                                              color: AppTheme().primary,
                                              fontWeight: FontWeight.w500,
                                            ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                              const SizedBox(height: 6),
                              // Email
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    FluentIcons.mail_12_regular,
                                    size: 12,
                                    color: Colors.grey.shade600,
                                  ),
                                  const SizedBox(width: 4),
                                  Flexible(
                                    child: Text(
                                      employer.email,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodySmall
                                          ?.copyWith(
                                            color: Colors.grey.shade600,
                                          ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 6),
                              // Phone
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    FluentIcons.call_12_regular,
                                    size: 12,
                                    color: Colors.grey.shade600,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    employer.phone,
                                    style: Theme.of(context).textTheme.bodySmall
                                        ?.copyWith(color: Colors.grey.shade600),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
          onEmpty: const Appemptyscreen(),
        ),
      ),
    );
  }
}
