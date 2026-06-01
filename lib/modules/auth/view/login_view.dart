import 'package:fluid_caht_app/modules/auth/view/sign_up_view.dart';
import 'package:fluid_caht_app/modules/setting/profile_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../core/widgets/app_text.dart';
import '../../../core/widgets/app_text_filed.dart';

class AuthView extends StatelessWidget {
  const AuthView({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        // Uses scaffoldBackgroundColor from AppTheme
        appBar: AppBar(
          // Uses appBarTheme from AppTheme (transparent bg, no elevation)
          elevation: 4,
          centerTitle: true,
          leading: Icon(Icons.hub, color: colorScheme.primary),
          title: CustomText(
            "Connect",
            // Uses headlineSmall from AppTheme textTheme
            variant: CustomTextVariant.headlineSmall,
            color: colorScheme.primary,
          ),
        ),
        body: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 450),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  // Tab switcher container
                  Container(
                    height: 52,
                    decoration: BoxDecoration(
                      // Uses surfaceContainerLow from colorScheme
                      color: colorScheme.surfaceContainerLow,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: TabBar(
                      dividerColor: Colors.transparent,
                      indicatorSize: TabBarIndicatorSize.tab,
                      indicator: BoxDecoration(
                        // Active tab pill → surfaceContainerLowest
                        color: colorScheme.surfaceContainerLowest,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      // Uses primary / onSurfaceVariant from colorScheme
                      labelColor: colorScheme.primary,
                      unselectedLabelColor: colorScheme.onSurfaceVariant,
                      labelStyle: textTheme.labelLarge,
                      unselectedLabelStyle: textTheme.labelLarge,
                      tabs: const [
                        Tab(text: "Login"),
                        Tab(text: "Sign Up"),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  const Expanded(
                    child: TabBarView(children: [LoginTab(), SignUpTab()]),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class LoginTab extends StatelessWidget {
  const LoginTab({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return SingleChildScrollView(
      child: Column(
        children: [
          // Uses headlineLarge from AppTheme textTheme
          const CustomText(
            "Welcome Back",
            variant: CustomTextVariant.headlineLarge,
          ),

          const SizedBox(height: 10),

          // Uses bodyMedium + onSurfaceVariant from colorScheme
          CustomText(
            "Sign in to stay connected with your network.",
            color: colorScheme.onSurfaceVariant,
          ),

          const SizedBox(height: 24),
         CustomText('Email or Phone Number'),
         SizedBox(height: 10,),
          const CustomTextFormField(hintText: "Email or Phone"),

          const SizedBox(height: 20),

          // Uses elevatedButtonTheme from AppTheme
          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ProfileSetupView(),
                  ),
                );
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomText(
                    "Continue",
                    variant: CustomTextVariant.bodyMedium,
                      color: colorScheme.onPrimary,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                  ),
                  const SizedBox(width: 8),
                  Icon(Icons.arrow_forward, color: colorScheme.onPrimary),
                ],
              ),
            ),
          ),

          const SizedBox(height: 50),

          // Divider row
          Row(
            children: [
              const Expanded(child: Divider()),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: CustomText(
                  "or continue with",
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
              const Expanded(child: Divider()),
            ],
          ),

          const SizedBox(height: 30),

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

          const SizedBox(height: 50),

          // Terms text — uses labelMedium from AppTheme textTheme
          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              style: textTheme.labelMedium?.copyWith(
                color: colorScheme.outline,
                fontSize: 16,
              ),
              children: [
                const TextSpan(text: "By continuing, you agree to our "),
                TextSpan(
                  text: "Terms of Service",
                  style: TextStyle(
                    color: colorScheme.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const TextSpan(text: " and "),
                TextSpan(
                  text: "Privacy Policy",
                  style: TextStyle(
                    color: colorScheme.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
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
