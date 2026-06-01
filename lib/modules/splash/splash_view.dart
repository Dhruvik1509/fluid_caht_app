import 'package:fluid_caht_app/modules/onboding/view/onboading_view.dart';
import 'package:flutter/material.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView>
    with SingleTickerProviderStateMixin {
  late AnimationController _loadingController;

  @override
  void initState() {
    super.initState();
    _loadingController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat();

    Future.delayed(const Duration(milliseconds: 2200), () {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const OnboardingView()),
        );
      }
    });
  }

  @override
  void dispose() {
    _loadingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      // Uses scaffoldBackgroundColor from AppTheme (AppColors.background)
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo Container
              Container(
                width: 128,
                height: 128,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: colorScheme.shadow.withOpacity(0.05),
                      blurRadius: 24,
                      offset: const Offset(0, 8),
                    ),
                  ],
                  // Uses surfaceContainerLowest from colorScheme
                  color: colorScheme.surfaceContainerLowest,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Image.asset(
                    'assets/images/logo.png',
                    fit: BoxFit.contain,
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Brand Name — uses headlineSmall from textTheme (PlusJakartaSans, w700)
              // with primary color override
              Text(
                'Connect',
                style: textTheme.headlineSmall?.copyWith(
                  color: colorScheme.primary,
                ),
              ),

              const SizedBox(height: 24),

              // Loading Bar Container
              Container(
                width: 120,
                height: 4,
                decoration: BoxDecoration(
                  // Track uses surfaceContainer from colorScheme
                  color: colorScheme.surfaceContainer,
                  borderRadius: BorderRadius.circular(9999),
                ),
                child: AnimatedBuilder(
                  animation: _loadingController,
                  builder: (context, child) {
                    final progress = (_loadingController.value * 2) % 1.0;
                    final widthFactor = Curves.easeInOut.transform(progress);
                    return Align(
                      alignment: Alignment.centerLeft,
                      child: Container(
                        width: 120 * widthFactor,
                        height: 4,
                        decoration: BoxDecoration(
                          // Fill uses primary from colorScheme
                          color: colorScheme.primary,
                          borderRadius: BorderRadius.circular(9999),
                        ),
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 16),

              // Footer Text — uses labelMedium from textTheme
              Text(
                'Initializing secure connection...',
                style: textTheme.labelMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant.withOpacity(0.6),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}