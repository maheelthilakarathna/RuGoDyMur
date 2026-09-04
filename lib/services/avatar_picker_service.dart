import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

/// Wraps image_picker's camera source and copies the captured photo into
/// the app's documents directory so the path stays valid across launches.
class AvatarPickerService {
  final ImagePicker _picker = ImagePicker();

  Future<String?> captureFromCamera() async {
    final photo = await _picker.pickImage(
      source: ImageSource.camera,
      maxWidth: 800,
      imageQuality: 85,
    );
    if (photo == null) return null;
    final dir = await getApplicationDocumentsDirectory();
    final fileName = 'avatar_${DateTime.now().millisecondsSinceEpoch}.jpg';
    final saved = await File(photo.path).copy('${dir.path}/$fileName');
    return saved.path;
  }

  Future<String?> pickFromGallery() async {
    final photo = await _picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 800,
      imageQuality: 85,
    );
    if (photo == null) return null;
    final dir = await getApplicationDocumentsDirectory();
    final fileName = 'avatar_${DateTime.now().millisecondsSinceEpoch}.jpg';
    final saved = await File(photo.path).copy('${dir.path}/$fileName');
    return saved.path;
  }
}
