import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:io';

import '../../providers/auth_provider.dart';
import '../../providers/theme_provider.dart';
import '../../utils/theme.dart';
import '../orders/order_history_screen.dart';
import '../profile/edit_profile_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final user = auth.user;
    final themeProvider = context.watch<ThemeProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 32,
                backgroundColor: AppColors.tint,
                backgroundImage: user?.avatarPath != null ? FileImage(File(user!.avatarPath!)) : null,
                child: user?.avatarPath == null
                    ? const Icon(Icons.person, size: 32, color: AppColors.navy)
                    : null,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(user?.name ?? '', style: Theme.of(context).textTheme.titleMedium),
                    Text(user?.email ?? '', style: const TextStyle(color: Colors.grey)),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.edit_outlined),
                onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const EditProfileScreen()),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          const Text('Appearance', style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          SegmentedButton<ThemeMode>(
            segments: const [
              ButtonSegment(value: ThemeMode.system, icon: Icon(Icons.brightness_auto), label: Text('Auto')),
              ButtonSegment(value: ThemeMode.light, icon: Icon(Icons.light_mode), label: Text('Light')),
              ButtonSegment(value: ThemeMode.dark, icon: Icon(Icons.dark_mode), label: Text('Dark')),
            ],
            selected: {themeProvider.mode},
            onSelectionChanged: (selection) => themeProvider.setMode(selection.first),
          ),
          const SizedBox(height: 24),
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.receipt_long_outlined, color: AppColors.navy),
                  title: const Text('Order history'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const OrderHistoryScreen()),
                  ),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.pets, color: AppColors.navy),
                  title: const Text('Edit profile & photo'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const EditProfileScreen()),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          OutlinedButton.icon(
            onPressed: () => auth.logout(),
            icon: const Icon(Icons.logout, color: AppColors.coral),
            label: const Text('Log out', style: TextStyle(color: AppColors.coral)),
          ),
        ],
      ),
    );
  }
}
