import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:tactix_academy_manager/Controller/Controllers/add_session_controller.dart';
import 'package:tactix_academy_manager/Core/Theme/app_colours.dart';
import 'package:tactix_academy_manager/Core/Theme/custom_scaffold.dart';
import 'package:tactix_academy_manager/View/Sessions/Widgets/add_session_image.dart';
import 'package:tactix_academy_manager/View/Sessions/Widgets/sessions_form_fields.dart';

class AddSessions extends StatelessWidget {
  const AddSessions({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AddSessionController(),
      child: Consumer<AddSessionController>(
        builder: (context, controller, _) => CustomScaffold(
          appBar: AppBar(
            title: const Text('Add Session', style: secondaryTextTheme),
            centerTitle: true,
          ),
          body: Stack(
            children: [
              _buildForm(controller, context),
              // _buildSaveButton(controller, context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildForm(AddSessionController controller, BuildContext context) {
    return Form(
      key: controller.formKey,
      child: ListView(
        padding: const EdgeInsets.only(
          top: 16,
          left: 16,
          right: 16,
          bottom: 100, // Extra padding for the save button
        ),
        children: [
          ImagePickerField(
            image: controller.image,
            onTap: () => _showImagePickerModal(context, controller),
          ),
          const SizedBox(height: 24),
          FormFields(controller: controller),
        ],
      ),
    );
  }

  

  void _showImagePickerModal(
      BuildContext context, AddSessionController controller) {
    showModalBottomSheet(
      context: context,
      backgroundColor: backGroundColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Add Photo',
                style: TextStyle(
                  color: secondTextColour,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color:
                        Theme.of(context).colorScheme.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.photo_library,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                title: const Text(
                  'Choose from Gallery',
                  style: TextStyle(color: secondTextColour),
                ),
                onTap: () {
                  Navigator.pop(context);
                  controller.pickImage(ImageSource.gallery);
                },
              ),
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color:
                        Theme.of(context).colorScheme.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.camera_alt,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                title: const Text(
                  'Take a Photo',
                  style: TextStyle(color: secondTextColour),
                ),
                onTap: () {
                  Navigator.pop(context);
                  controller.pickImage(ImageSource.camera);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
