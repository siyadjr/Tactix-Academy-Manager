import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:tactix_academy_manager/Controller/Controllers/user_profile_controller.dart';
import 'package:tactix_academy_manager/Core/ReusableWidgets/loading_indicator.dart';
import 'package:tactix_academy_manager/Core/Theme/app_colours.dart';
import 'package:tactix_academy_manager/View/Profiles/UserProfile/Widgets/user_profile_build_gradientcard.dart';


class UserProfileBuildProfileCard extends StatelessWidget {
  UserProfileBuildProfileCard({
    super.key,
    required this.context,
    required this.userProvider,
  });

  final BuildContext context;
  final UserProfileController userProvider;

  final TextEditingController _nameController = TextEditingController();

  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    try {
      final image = await picker.pickImage(
        source: source,
        imageQuality: 70,
      );

      if (image != null) {
        userProvider.updateImageUi(image.path);
        Navigator.pop(context);
      }
    } catch (e) {
      debugPrint('Error picking image: $e');
    }
  }

  void _showImagePickerSheet() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Take a photo'),
                onTap: () {
                  _pickImage(ImageSource.camera);
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Choose from gallery'),
                onTap: () {
                  _pickImage(ImageSource.gallery);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showEditNameDialog() {
    _nameController.text = userProvider.name ?? ''; // Pre-fill the current name

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: backGroundColor,
        title: const Text('Edit Name'),
        content: TextField(
          style: const TextStyle(color: secondTextColour),
          controller: _nameController,
          autofocus: true,
          decoration: const InputDecoration(hintText: 'Enter your name'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              if (_nameController.text.isEmpty) {
              } else {
                userProvider.updateUserName(_nameController.text);
                Navigator.pop(context);
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BuildGradientCard(
      title: 'Profile',
      icon: Icons.person,
      color: Colors.blue,
      child: Center(
        child: Column(
          children: [
            Stack(
              alignment: Alignment.bottomRight,
              children: [
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.blue,
                      width: 3,
                    ),
                  ),
                  child: ClipOval(
                    child: Consumer<UserProfileController>(
                      builder: (context, provider, child) =>
                          provider.imageLoading
                              ? const LoadingIndicator()
                              : SizedBox(
                                  width: 100,
                                  height: 100,
                                  child: provider.imagepath != null
                                      ? CachedNetworkImage(
                                          imageUrl: provider.imagepath!,
                                          fit: BoxFit.cover,
                                          placeholder: (context, url) =>
                                              const CircularProgressIndicator(),
                                          errorWidget: (context, url, error) =>
                                              const Icon(
                                            Icons.person,
                                            size: 50,
                                            color: Colors.grey,
                                          ),
                                        )
                                      : const Icon(
                                          Icons.person,
                                          size: 50,
                                          color: Colors.grey,
                                        ),
                                ),
                    ),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [
                        Colors.blue.withOpacity(0.8),
                        Colors.blue.withOpacity(0.6),
                      ],
                    ),
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.edit, size: 20, color: Colors.white),
                    onPressed: _showImagePickerSheet,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Consumer<UserProfileController>(
              builder: (context, provider, child) => GestureDetector(
                onTap: _showEditNameDialog,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    provider.nameLoading
                        ? const Center(child: CircularProgressIndicator())
                        : Text(
                            userProvider.name ?? 'Enter your name',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                    const Icon(
                      Icons.edit,
                      color: secondTextColour,
                    )
                  ],
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              userProvider.player?.email ?? '',
              style: const TextStyle(
                fontSize: 16,
                color: Colors.white70,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
