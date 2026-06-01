import 'package:fluid_caht_app/core/widgets/app_text.dart';
import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

class OnboardingPage extends StatelessWidget {
  final String title;
  final String subtitle;
  final String image;

  const OnboardingPage({
    super.key,
    required this.title,
    required this.subtitle,
    required this.image,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          const Spacer(),

          Container(
            height: 320,
            width: 320,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(40)),
            clipBehavior: Clip.antiAlias,
            child: Image.asset(image, fit: BoxFit.cover),
          ),

          const SizedBox(height: 40),

          CustomText(
            title,
            textAlign: TextAlign.center,
            variant: CustomTextVariant.headlineMedium,
          ),

          const SizedBox(height: 12),

          CustomText(
            subtitle,
            textAlign: TextAlign.center,
            variant: CustomTextVariant.bodyMedium,
            maxLines: 3,
          ),

          const Spacer(),
        ],
      ),
    );
  }
}
