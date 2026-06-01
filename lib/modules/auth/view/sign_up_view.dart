import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../core/widgets/app_text.dart';
import '../../../core/widgets/app_text_filed.dart';

class SignUpTab extends StatelessWidget {
  const SignUpTab({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return SingleChildScrollView(
      child: Column(
        children: [
          // Uses headlineLarge from AppTheme textTheme
          const CustomText(
            "Create Account",
            variant: CustomTextVariant.headlineLarge,
          ),

          const SizedBox(height: 10),

          // Uses onSurfaceVariant from colorScheme
          CustomText(
            "Create a new account.",
            color: colorScheme.onSurfaceVariant,
          ),

          const SizedBox(height: 24),

          // All fields use inputDecorationTheme from AppTheme
          const CustomTextFormField(hintText: "Full Name"),
          const SizedBox(height: 16),
          const CustomTextFormField(hintText: "Email"),
          const SizedBox(height: 16),
          const CustomTextFormField(hintText: "Password", obscureText: true),
          const SizedBox(height: 16),
          const CustomTextFormField(
            hintText: "Confirm Password",
            obscureText: true,
          ),

          const SizedBox(height: 24),

          // Uses elevatedButtonTheme from AppTheme
          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              onPressed: () {
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(
                //     builder: (context) => const ProfileSetupView(),
                //   ),
                // );
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomText(
                    "Create Account",
                    variant: CustomTextVariant.bodyMedium,
                    color: colorScheme.onPrimary,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                  const SizedBox(width: 8),
                ],
              ),
            ),
          ),

          const SizedBox(height: 24),

          // Divider row
          Row(
            children: [
              const Expanded(child: Divider()),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: CustomText(
                  "or sign up with",
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
              const Expanded(child: Divider()),
            ],
          ),

          const SizedBox(height: 24),

          Row(
            children: [
              Expanded(
                child: _socialButton(
                  context,
                  'assets/icons/google.svg',
                  'Google',
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _socialButton(
                  context,
                  'assets/icons/apple.svg',
                  'Apple',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _socialButton(BuildContext context, String icon, String title) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      height: 48,
      decoration: BoxDecoration(
        // Uses surfaceContainerLow / outlineVariant from colorScheme
        color: colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colorScheme.outlineVariant),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(icon),
          const SizedBox(width: 5),
          CustomText(title),
        ],
      ),
    );
  }
}
