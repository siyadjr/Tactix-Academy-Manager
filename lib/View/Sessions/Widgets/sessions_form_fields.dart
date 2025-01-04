import 'package:flutter/material.dart';
import 'package:tactix_academy_manager/Controller/add_session_controller.dart';
import 'package:tactix_academy_manager/Core/Theme/app_colours.dart';
import 'package:tactix_academy_manager/View/Sessions/Widgets/add_session_custom_textfields.dart';

class FormFields extends StatelessWidget {
  final AddSessionController controller;

  const FormFields({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Session Details',
          style: theme.textTheme.titleLarge?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 24),
        buildTextField(
          maxLines: 1,
          controller: controller.nameController,
          label: 'Session Name',
          hint: 'Enter session name',
          prefixIcon: Icons.sports_outlined,
          validator: (value) {
            // Check if value is empty or consists of spaces only and whether trimming should happen
            if (value?.isEmpty == true || (value!.trim().isEmpty)) {
              return 'Please enter a Session name';
            }
            return null; // No error
          },
        ),
        const SizedBox(height: 20),
        buildTextField(
          controller: controller.descriptionController,
          label: 'Description',
          hint: 'Enter session description',
          prefixIcon: Icons.description_outlined,
          validator: (value) {
            // Check if value is empty or consists of spaces only and whether trimming should happen
            if (value?.isEmpty == true || (value!.trim().isEmpty)) {
              return 'Please enter a description';
            }
            return null; // No error
          },
        ),
        const SizedBox(height: 20),
        buildTextField(
          maxLines: 1,
          controller: controller.locationController,
          label: 'Location',
          hint: 'Enter session location',
          prefixIcon: Icons.location_on_outlined,
          validator: (value) {
            // Check if value is empty or consists of spaces only and whether trimming should happen
            if (value?.isEmpty == true || (value!.trim().isEmpty)) {
              return 'Please enter a Location ';
            }
            return null; // No error
          },
        ),
        const SizedBox(height: 20),
        _buildTypeDropdown(context, controller),
        const SizedBox(
          height: 20,
        ),
        const SizedBox(height: 20),
        _buildDateField(context, controller),
        const SizedBox(
          height: 20,
        ),
        const SizedBox(height: 20),
        _buildSaveButton(controller, context)
      ],
    );
  }

  Widget _buildTypeDropdown(
      BuildContext context, AddSessionController controller) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 8),
          child: Text(
            'Session Type',
            style: TextStyle(
              color: Colors.white.withOpacity(0.9),
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        DropdownButtonFormField<String>(
          value: controller.type,
          style: const TextStyle(color: Colors.white),
          dropdownColor: backGroundColor,
          icon: Icon(
            Icons.keyboard_arrow_down_rounded,
            color: theme.colorScheme.primary,
          ),
          decoration: InputDecoration(
            prefixIcon: Icon(
              Icons.category_outlined,
              color: theme.colorScheme.primary,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.white.withOpacity(0.3)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.white.withOpacity(0.3)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: theme.colorScheme.primary,
                width: 2,
              ),
            ),
            filled: true,
            fillColor: Colors.white.withOpacity(0.1),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
          ),
          items: [
            _buildDropdownItem(context, 'Training', Icons.fitness_center),
            _buildDropdownItem(context, 'Match', Icons.sports_soccer),
            _buildDropdownItem(context, 'Other', Icons.more_horiz),
          ],
          onChanged: (value) {
            if (value != null) {
              controller.type = value;
              controller.notifyListeners();
            }
          },
        ),
      ],
    );
  }

  DropdownMenuItem<String> _buildDropdownItem(
    BuildContext context,
    String value,
    IconData icon,
  ) {
    return DropdownMenuItem(
      value: value,
      child: Row(
        children: [
          Icon(
            icon,
            size: 20,
            color: Theme.of(context).colorScheme.primary,
          ),
          const SizedBox(width: 12),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSaveButton(
      AddSessionController controller, BuildContext context) {
    return Container(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: controller.isSubmitting
            ? null
            : () => controller.submitSession(context),
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: controller.isSubmitting
            ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                ),
              )
            : const Text(
                'Save Session',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
      ),
    );
  }

  Widget _buildDateField(
      BuildContext context, AddSessionController controller) {
    return GestureDetector(
      onTap: () async {
        final pickedDate = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(2000),
          lastDate: DateTime(2100),
        );
        if (pickedDate != null) {
          controller.selectedDate = pickedDate;
          controller.notifyListeners();
        }
      },
      child: AbsorbPointer(
        child: TextFormField(
          controller: TextEditingController(
            text: controller.selectedDate != null
                ? '${controller.selectedDate!.day}/${controller.selectedDate!.month}/${controller.selectedDate!.year}'
                : '',
          ),
          style: const TextStyle(color: secondTextColour),
          decoration: InputDecoration(
            labelStyle: const TextStyle(color: Colors.white),
            labelText: 'Select Date',
            hintText: 'Pick a date',
            prefixIcon: const Icon(
              Icons.calendar_today,
              color: mainTextColour,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.white),
            ),
            filled: true,
            fillColor: Colors.white.withOpacity(0.1),
          ),
        ),
      ),
    );
  }
}
