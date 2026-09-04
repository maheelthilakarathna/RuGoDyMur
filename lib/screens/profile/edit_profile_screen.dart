import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/auth_provider.dart';
import '../../services/avatar_picker_service.dart';
import '../../utils/theme.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _avatarService = AvatarPickerService();
  late final TextEditingController _nameController;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: context.read<AuthProvider>().user?.name ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _pickPhoto(bool fromCamera) async {
    final path = fromCamera
        ? await _avatarService.captureFromCamera()
        : await _avatarService.pickFromGallery();
    if (path == null || !mounted) return;
    await context.read<AuthProvider>().updateProfile(avatarPath: path);
  }

  Future<void> _save() async {
    setState(() => _saving = true);
    await context.read<AuthProvider>().updateProfile(name: _nameController.text.trim());
    if (!mounted) return;
    setState(() => _saving = false);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthProvider>().user;

    return Scaffold(
      appBar: AppBar(title: const Text('Edit Profile')),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Center(
            child: Stack(
              children: [
                CircleAvatar(
                  radius: 48,
                  backgroundColor: AppColors.tint,
                  backgroundImage: user?.avatarPath != null ? FileImage(File(user!.avatarPath!)) : null,
                  child: user?.avatarPath == null ? const Icon(Icons.person, size: 48, color: AppColors.navy) : null,
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: InkWell(
                    customBorder: const CircleBorder(),
                    onTap: () => _showPhotoSheet(context),
                    child: const CircleAvatar(radius: 16, backgroundColor: AppColors.coral, child: Icon(Icons.camera_alt, size: 16, color: Colors.white)),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          TextField(
            controller: _nameController,
            decoration: const InputDecoration(labelText: 'Full name', prefixIcon: Icon(Icons.person_outline)),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: _saving ? null : _save,
            child: _saving
                ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                : const Text('SAVE'),
          ),
        ],
      ),
    );
  }

  void _showPhotoSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (sheetContext) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt_outlined),
              title: const Text('Take a photo'),
              onTap: () {
                Navigator.of(sheetContext).pop();
                _pickPhoto(true);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library_outlined),
              title: const Text('Choose from gallery'),
              onTap: () {
                Navigator.of(sheetContext).pop();
                _pickPhoto(false);
              },
            ),
          ],
        ),
      ),
    );
  }
}
