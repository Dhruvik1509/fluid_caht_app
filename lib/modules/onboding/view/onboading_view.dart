import 'package:fluid_caht_app/core/widgets/app_text.dart';
import 'package:fluid_caht_app/modules/auth/view/login_view.dart';
import 'package:flutter/material.dart';

import '../model/onboardingModel.dart';
import '../widget/onboarding_widget.dart';

class OnboardingView extends StatefulWidget {
  const OnboardingView({super.key});

  @override
  State<OnboardingView> createState() => _OnboardingViewState();
}

class _OnboardingViewState extends State<OnboardingView> {
  final PageController pageController = PageController();
  int currentPage = 0;

  final pages = [
    OnboardingModel(
      title: "Stay Connected",
      subtitle:
      "Real-time messaging that brings you\ncloser to the people who matter most\nanywhere in the world..",
      image: "assets/images/stay connected.png",
    ),
    OnboardingModel(
      title: "Voice & Video Calls",
      subtitle:
      "Crystal-clear audio and video quality that makes you feel like you're together.",
      image: "assets/images/vioice&videocall.png",
    ),
    OnboardingModel(
      title: "Fast Messaging",
      subtitle:
      "Messages are delivered instantly with lightning-fast performance.",
      image: "assets/images/fast messaging.png",
    ),
    OnboardingModel(
      title: "Secure Chats",
      subtitle: "Every conversation is protected with end-to-end encryption.",
      image: "assets/images/securechats.png",
    ),
  ];

  void nextPage() {
    if (currentPage == pages.length - 1) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const AuthView()),
      );
      return;
    }
    pageController.nextPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.ease,
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      // Uses scaffoldBackgroundColor → AppColors.background via AppTheme
      body: SafeArea(
        child: Column(
          children: [
            /// Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  currentPage == 0
                      ? Row(
                    children: [
                      Icon(Icons.hub, color: colorScheme.primary),
                      const SizedBox(width: 10),
                      CustomText(
                        "Connect",
                        variant: CustomTextVariant.headlineSmall,
                        color: colorScheme.primary,
                      ),
                    ],
                  )
                      : const SizedBox(),

                  // TextButton uses textButtonTheme from AppTheme (primary foreground)
                  TextButton(
                    onPressed: () {
                      Navigator.pushReplacementNamed(context, "/login");
                    },
                    child: const CustomText(
                      "Skip",
                      variant: CustomTextVariant.bodyMedium,
                    ),
                  ),
                ],
              ),
            ),

            /// Pages
            Expanded(
              child: PageView.builder(
                controller: pageController,
                itemCount: pages.length,
                onPageChanged: (value) => setState(() => currentPage = value),
                itemBuilder: (_, index) {
                  final page = pages[index];
                  return OnboardingPage(
                    title: page.title,
                    subtitle: page.subtitle,
                    image: page.image,
                  );
                },
              ),
            ),

            /// Page Indicator
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                pages.length,
                    (index) => AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  height: 8,
                  width: currentPage == index ? 28 : 8,
                  decoration: BoxDecoration(
                    // Active → primary, Inactive → outlineVariant via colorScheme
                    color: currentPage == index
                        ? colorScheme.primary
                        : colorScheme.outlineVariant,
                    borderRadius: BorderRadius.circular(100),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 30),

            /// Next Button — styled via elevatedButtonTheme in AppTheme
            Padding(
              padding: const EdgeInsets.all(20),
              child: SizedBox(
                height: 56,
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: nextPage,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        currentPage == pages.length - 1
                            ? "Get Started"
                            : "Next",
                        // Uses onPrimary from colorScheme (white on primary bg)
                        style: textTheme.bodyMedium?.copyWith(
                          color: colorScheme.onPrimary,
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Icon(Icons.arrow_forward, color: colorScheme.onPrimary),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}