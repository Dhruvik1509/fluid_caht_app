import 'dart:io';

import 'package:fluid_caht_app/modules/bottom_nav/bottom_nav_view.dart';
import 'package:fluid_caht_app/modules/chat/view/chat_view.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../../core/widgets/app_text.dart';
import '../../../core/widgets/app_text_filed.dart';

class ProfileSetupView extends StatefulWidget {
  const ProfileSetupView({super.key});

  @override
  State<ProfileSetupView> createState() => _ProfileSetupViewState();
}

class _ProfileSetupViewState extends State<ProfileSetupView> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController bioController = TextEditingController();
  final ImagePicker picker = ImagePicker();
  File? selectedImage;

  Future<void> pickImage() async {
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() => selectedImage = File(image.path));
    }
  }

  void finishProfile() {
    if (nameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        // SnackBar uses snackBarTheme from AppTheme
        const SnackBar(content: Text("Please enter display name")),
      );
      return;
    }
    debugPrint("Display Name : ${nameController.text}");
    debugPrint("Bio : ${bioController.text}");
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Profile Setup Complete")),
    );
    Navigator.push(context, MaterialPageRoute(builder: (context) => InboxScreen(),));
  }

  @override
  void dispose() {
    nameController.dispose();
    bioController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      // Uses scaffoldBackgroundColor from AppTheme (AppColors.background)
      appBar: AppBar(
        // Uses appBarTheme from AppTheme (transparent, no elevation, PlusJakartaSans title)
        centerTitle: true,
        leading: Icon(Icons.hub, color: colorScheme.primary),
        title: const Text("Connect"),
      ),

      body: Stack(
        children: [
          // Background decorative circles — use colorScheme colors with opacity
          Positioned(
            top: -100,
            left: -100,
            child: Container(
              width: 240,
              height: 240,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: colorScheme.secondary.withOpacity(.08),
              ),
            ),
          ),

          Positioned(
            bottom: -120,
            right: -120,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: colorScheme.primary.withOpacity(.08),
              ),
            ),
          ),

          Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 500),
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    const SizedBox(height: 10),

                    // Uses headlineLarge from AppTheme textTheme
                    const CustomText(
                      "Set up your profile",
                      variant: CustomTextVariant.headlineLarge,
                      textAlign: TextAlign.center,
                    ),

                    const SizedBox(height: 8),

                    // Uses bodyMedium + onSurfaceVariant from colorScheme
                    CustomText(
                      "Let others know who they're talking to by providing your details below.",
                      textAlign: TextAlign.center,
                      variant: CustomTextVariant.bodyMedium,
                      color: colorScheme.onSurfaceVariant,
                    ),

                    const SizedBox(height: 32),

                    /// Avatar picker
                    Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Container(
                          width: 130,
                          height: 130,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            // Uses surfaceContainer from colorScheme
                            color: colorScheme.surfaceContainer,
                          ),
                          child: ClipOval(
                            child: selectedImage != null
                                ? Image.file(selectedImage!, fit: BoxFit.cover)
                                : Image.network(
                              "https://images.unsplash.com/photo-1500648767791-00dcc994a43e",
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),

                        Positioned(
                          right: 0,
                          bottom: 0,
                          child: InkWell(
                            onTap: pickImage,
                            borderRadius: BorderRadius.circular(100),
                            child: Container(
                              width: 44,
                              height: 44,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                // Uses primary from colorScheme
                                color: colorScheme.primary,
                              ),
                              child: Icon(
                                Icons.photo_camera,
                                // Uses onPrimary from colorScheme
                                color: colorScheme.onPrimary,
                                size: 20,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 40),

                    // Label: uses labelLarge from AppTheme textTheme
                    Align(
                      alignment: Alignment.centerLeft,
                      child: CustomText(
                        "Display Name",
                        variant: CustomTextVariant.labelLarge,
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),

                    const SizedBox(height: 8),

                    // Uses inputDecorationTheme from AppTheme
                    CustomTextFormField(
                      controller: nameController,
                      hintText: "How should we call you?",
                    ),

                    const SizedBox(height: 24),

                    Align(
                      alignment: Alignment.centerLeft,
                      child: CustomText(
                        "About",
                        variant: CustomTextVariant.labelLarge,
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),

                    const SizedBox(height: 8),

                    // Uses inputDecorationTheme from AppTheme automatically
                    TextFormField(
                      controller: bioController,
                      maxLines: 4,
                      decoration: const InputDecoration(
                        hintText: "Tell the community a bit about yourself...",
                      ),
                    ),

                    const SizedBox(height: 32),

                    // Uses elevatedButtonTheme from AppTheme
                    SizedBox(
                      height: 56,
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: finishProfile,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Finish",
                              style: textTheme.bodyMedium?.copyWith(
                                color: colorScheme.onPrimary,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Icon(
                              Icons.arrow_forward,
                              color: colorScheme.onPrimary,
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 12),

                    // Uses labelMedium + onSurfaceVariant from colorScheme
                    CustomText(
                      "By finishing, you agree to our Terms of Service.",
                      textAlign: TextAlign.center,
                      variant: CustomTextVariant.labelMedium,
                      color: colorScheme.onSurfaceVariant,
                    ),

                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}