// lib/modules/profile/profile_page.dart
//
// Converted from the HTML "Connect – Profile/Settings" screen.
// Uses CustomText (app_text.dart) throughout.
// All colors from Theme.of(context).colorScheme — light/dark automatic.
// BottomNavigationBar is NOT included — lives in MainShell.

import 'package:flutter/material.dart';
import '../../core/widgets/app_text.dart';

// ─── Settings menu item model ─────────────────────────────────────────────────

class _SettingItem {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color Function(ColorScheme cs) iconBgColor;
  final Color Function(ColorScheme cs) iconFgColor;
  final VoidCallback? onTap;

  const _SettingItem({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.iconBgColor,
    required this.iconFgColor,
    this.onTap,
  });
}

// ─── Main Screen ──────────────────────────────────────────────────────────────

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  static final List<_SettingItem> _settings = [
    _SettingItem(
      title: 'Personal Info',
      subtitle: 'Name, email, and phone',
      icon: Icons.person_outlined,
      iconBgColor: (cs) => cs.primaryFixed,
      iconFgColor: (cs) => cs.onPrimaryFixedVariant,
    ),
    _SettingItem(
      title: 'Notifications',
      subtitle: 'Mute, sounds, and alerts',
      icon: Icons.notifications_active_outlined,
      iconBgColor: (cs) => cs.secondaryFixed,
      iconFgColor: (cs) => cs.onSecondaryFixedVariant,
    ),
    _SettingItem(
      title: 'Privacy & Security',
      subtitle: 'Two-factor and data',
      icon: Icons.shield_outlined,
      iconBgColor: (cs) => cs.tertiaryFixed,
      iconFgColor: (cs) => cs.onTertiaryFixedVariant,
    ),
    _SettingItem(
      title: 'Appearance',
      subtitle: 'Theme and wallpaper',
      icon: Icons.palette_outlined,
      iconBgColor: (cs) => cs.surfaceContainerHighest,
      iconFgColor: (cs) => cs.onSurfaceVariant,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: cs.surface,

      // ── Top App Bar ────────────────────────────────────────────────────────
      appBar: AppBar(
        backgroundColor: cs.surface.withOpacity(0.85),
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 1,
        leadingWidth: 56,
        leading: Padding(
          padding: const EdgeInsets.only(left: 16),
          child: CircleAvatar(
            radius: 20,
            backgroundColor: cs.surfaceContainerHigh,
            backgroundImage: const NetworkImage(
              'https://i.pravatar.cc/150?img=47',
            ),
          ),
        ),
        // ✅ CustomText → headlineMedium (PlusJakartaSans 20 w600) + primary
        title: CustomText(
          'Connect',
          variant: CustomTextVariant.headlineMedium,
          color: cs.primary,
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.search_rounded, color: cs.primary),
            onPressed: () {},
          ),
          const SizedBox(width: 4),
        ],
      ),

      // ── Body ───────────────────────────────────────────────────────────────
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 24, 20, 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ── Profile Hero ───────────────────────────────────────────────
            _ProfileHero(),
            const SizedBox(height: 28),

            // ── Settings Grid ──────────────────────────────────────────────
            // Using a Column instead of GridView to keep it simple & scrollable
            // Wrap in two-column rows to match the HTML grid-cols-2 on md+
            _SettingsGrid(items: _settings),
            const SizedBox(height: 28),

            // ── Logout button ──────────────────────────────────────────────
            _LogoutButton(),
          ],
        ),
      ),
    );
  }
}

// ─── Profile Hero Section ─────────────────────────────────────────────────────

class _ProfileHero extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Column(
      children: [
        // Avatar + edit button
        Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              width: 96,
              height: 96,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: cs.surfaceContainerLowest,
                  width: 4,
                ),
                boxShadow: [
                  BoxShadow(
                    color: cs.shadow.withOpacity(0.12),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: const CircleAvatar(
                radius: 48,
                backgroundImage: NetworkImage(
                  'https://i.pravatar.cc/150?img=47',
                ),
              ),
            ),
            // Edit button
            Positioned(
              bottom: 0,
              right: 0,
              child: GestureDetector(
                onTap: () {},
                child: Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: cs.primary,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: cs.primary.withOpacity(0.35),
                        blurRadius: 8,
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.edit_rounded,
                    size: 16,
                    color: cs.onPrimary,
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),

        // Name
        // ✅ CustomText → headlineLarge (PlusJakartaSans 28 w700)
        CustomText(
          'Alex Thompson',
          variant: CustomTextVariant.headlineLarge,
          // uses textTheme.headlineLarge color (onSurface) by default
        ),
        const SizedBox(height: 6),

        // Status row
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                color: cs.primary,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 6),
            // ✅ CustomText → labelMedium (Inter 12 w500) + onSurfaceVariant
            CustomText(
              'Focusing on Deep Work',
              variant: CustomTextVariant.labelMedium,
              color: cs.onSurfaceVariant,
            ),
          ],
        ),
      ],
    );
  }
}

// ─── Settings List (vertical, 1 column) ──────────────────────────────────────

class _SettingsGrid extends StatelessWidget {
  final List<_SettingItem> items;
  const _SettingsGrid({required this.items});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: items
          .map(
            (item) => Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: _SettingCard(item: item),
        ),
      )
          .toList(),
    );
  }
}

// ─── Single Setting Card ──────────────────────────────────────────────────────

class _SettingCard extends StatelessWidget {
  final _SettingItem item;
  const _SettingCard({required this.item});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Material(
      color: cs.surfaceContainerLow,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: item.onTap ?? () {},
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: cs.outlineVariant.withOpacity(0.6)),
          ),
          child: Row(
            children: [
              // Icon circle
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: item.iconBgColor(cs),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  item.icon,
                  size: 20,
                  color: item.iconFgColor(cs),
                ),
              ),
              const SizedBox(width: 10),

              // Text
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ✅ CustomText → titleSmall (PlusJakartaSans 15 w600)
                    CustomText(
                      item.title,
                      variant: CustomTextVariant.titleSmall,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    // ✅ CustomText → bodySmall (Inter 13 w400) + onSurfaceVariant
                    CustomText(
                      item.subtitle,
                      variant: CustomTextVariant.bodySmall,
                      color: cs.onSurfaceVariant,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),

              // Chevron
              Icon(
                Icons.chevron_right_rounded,
                size: 20,
                color: cs.outline,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Logout Button ────────────────────────────────────────────────────────────

class _LogoutButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Material(
      color: cs.errorContainer,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {
          // TODO: handle logout
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.logout_rounded, color: cs.onErrorContainer, size: 20),
              const SizedBox(width: 8),
              // ✅ CustomText → labelLarge (Inter 13 w600) + onErrorContainer
              //    hover state handled by InkWell splash
              CustomText(
                'Logout',
                variant: CustomTextVariant.labelLarge,
                color: cs.onErrorContainer,
              ),
            ],
          ),
        ),
      ),
    );
  }
}