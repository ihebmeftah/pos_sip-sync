import 'package:admin/app/common/appemptyscreen.dart';
import 'package:admin/themes/apptheme.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/staff_details_controller.dart';

class StaffDetailsView extends GetView<StaffDetailsController> {
  const StaffDetailsView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Staff Details'), centerTitle: true),
      body: controller.obx(
        (state) {
          final employer = controller.employer!;
          return SingleChildScrollView(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Profile Card
                Container(
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
                      // Header with gradient background
                      Container(
                        height: 150,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              AppTheme().primary,
                              AppTheme().primary.withValues(alpha: 0.7),
                            ],
                          ),
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(16),
                            topRight: Radius.circular(16),
                          ),
                        ),
                      ),
                      // Profile Avatar (overlapping)
                      Transform.translate(
                        offset: const Offset(0, -50),
                        child: Column(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.white,
                                  width: 5,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.15),
                                    blurRadius: 15,
                                    offset: const Offset(0, 5),
                                  ),
                                ],
                              ),
                              child: CircleAvatar(
                                radius: 60,
                                backgroundColor: AppTheme().primary,
                                foregroundColor: Colors.white,
                                backgroundImage: employer.photo != null
                                    ? NetworkImage(employer.photo!)
                                    : null,
                                child: employer.photo == null
                                    ? Text(
                                        '${employer.firstname[0].toUpperCase()}${employer.lastname[0].toUpperCase()}',
                                        style: const TextStyle(
                                          fontSize: 40,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      )
                                    : null,
                              ),
                            ),
                            const SizedBox(height: 16),
                            // Name
                            Text(
                              '${employer.firstname} ${employer.lastname}',
                              style: Theme.of(context).textTheme.headlineMedium
                                  ?.copyWith(fontWeight: FontWeight.bold),
                              textAlign: TextAlign.center,
                            ),
                            if (employer.username != null) ...[
                              const SizedBox(height: 4),
                              Text(
                                '@${employer.username}',
                                style: Theme.of(context).textTheme.titleMedium
                                    ?.copyWith(
                                      color: AppTheme().primary,
                                      fontWeight: FontWeight.w500,
                                    ),
                              ),
                            ],
                            const SizedBox(height: 8),
                            // Role Badge
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: AppTheme().primary.withValues(
                                  alpha: 0.1,
                                ),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                employer.type.name.toUpperCase(),
                                style: Theme.of(context).textTheme.labelMedium
                                    ?.copyWith(
                                      color: AppTheme().primary,
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                // Contact Information Card
                Container(
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
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            FluentIcons.info_20_regular,
                            color: AppTheme().primary,
                            size: 24,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Contact Information',
                            style: Theme.of(context).textTheme.titleLarge
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      _buildInfoRow(
                        context,
                        icon: FluentIcons.mail_20_regular,
                        label: 'Email',
                        value: employer.email,
                      ),
                      const Divider(height: 32),
                      _buildInfoRow(
                        context,
                        icon: FluentIcons.call_20_regular,
                        label: 'Phone',
                        value: employer.phone,
                      ),
                      if (employer.building != null) ...[
                        const Divider(height: 32),
                        _buildInfoRow(
                          context,
                          icon: FluentIcons.building_20_regular,
                          label: 'Building',
                          value: employer.building!.name,
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                // Account Information Card
                Container(
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
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            FluentIcons.person_accounts_20_regular,
                            color: AppTheme().primary,
                            size: 24,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Account Information',
                            style: Theme.of(context).textTheme.titleLarge
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      _buildInfoRow(
                        context,
                        icon: FluentIcons.person_20_regular,
                        label: 'User ID',
                        value: employer.id ?? 'N/A',
                      ),
                      const Divider(height: 32),
                      _buildInfoRow(
                        context,
                        icon: FluentIcons.shield_person_20_regular,
                        label: 'Role',
                        value: employer.type.name,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
        onLoading: const Center(child: CircularProgressIndicator()),
        onEmpty: Appemptyscreen(),
      ),
    );
  }

  Widget _buildInfoRow(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppTheme().primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, size: 20, color: AppTheme().primary),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.grey.shade600,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: Theme.of(
                  context,
                ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
