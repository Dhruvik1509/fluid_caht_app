// lib/modules/status/add_status_page.dart
//
// Converted from the HTML "Add Status" screen.
// Uses CustomText (app_text.dart) throughout.
// All colors from Theme.of(context).colorScheme — light/dark automatic.
// Opened as a pushed route from StatusPage (not a shell tab).

import 'package:flutter/material.dart';
import '../../../core/widgets/app_text.dart';

// ─── Action item model ────────────────────────────────────────────────────────

class _ActionItem {
  final String label;
  final IconData icon;
  final VoidCallback? onTap;

  const _ActionItem({
    required this.label,
    required this.icon,
    this.onTap,
  });
}

// ─── Main Screen ──────────────────────────────────────────────────────────────

class AddStatusPage extends StatelessWidget {
  const AddStatusPage({super.key});

  static final List<_ActionItem> _actions = [
    _ActionItem(
      label: 'Open Camera',
      icon: Icons.photo_camera_outlined,
    ),
    _ActionItem(
      label: 'Pick Image/Video',
      icon: Icons.photo_library_outlined,
    ),
    _ActionItem(
      label: 'Upload Story',
      icon: Icons.history_edu_outlined,
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
        leading: IconButton(
          icon: Icon(Icons.arrow_back_rounded, color: cs.primary),
          onPressed: () => Navigator.pop(context),
        ),
        // ✅ CustomText → headlineMedium (PlusJakartaSans 20 w600)
        title: CustomText(
          'Add Status',
          variant: CustomTextVariant.headlineMedium,
        ),
      ),

      // ── Body ───────────────────────────────────────────────────────────────
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ── Camera Preview ───────────────────────────────────────────────
            _CameraPreview(),
            const SizedBox(height: 20),

            // ── Action list ──────────────────────────────────────────────────
            Column(
              children: _actions
                  .map((a) => Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: _ActionCard(item: a),
              ))
                  .toList(),
            ),
            const SizedBox(height: 20),

            // ── Tip card ─────────────────────────────────────────────────────
            _TipCard(),
          ],
        ),
      ),
    );
  }
}

// ─── Camera Preview ───────────────────────────────────────────────────────────

class _CameraPreview extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return AspectRatio(
      aspectRatio: 3 / 4,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Background placeholder (replace with CameraPreview widget)
            Container(
              color: cs.surfaceContainerHigh,
              child: Image.network(
                'https://images.unsplash.com/photo-1558618666-fcd25c85cd64?w=600',
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  color: cs.surfaceContainerHigh,
                ),
              ),
            ),

            // Overlay
            Container(color: Colors.black.withOpacity(0.12)),

            // Center content
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Camera icon circle
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: cs.primary.withOpacity(0.90),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: cs.primary.withOpacity(0.35),
                        blurRadius: 16,
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.photo_camera_rounded,
                    size: 32,
                    color: cs.onPrimary,
                  ),
                ),
                const SizedBox(height: 10),
                // ✅ CustomText → labelLarge (Inter 13 w600) white
                CustomText(
                  'TAP TO CAPTURE',
                  variant: CustomTextVariant.labelLarge,
                  color: Colors.white,
                  letterSpacing: 1.5,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Action Card ─────────────────────────────────────────────────────────────

class _ActionCard extends StatelessWidget {
  final _ActionItem item;
  const _ActionCard({required this.item});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Material(
      color: cs.surfaceContainerLowest,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: item.onTap ?? () {},
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              // Icon circle
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: cs.primaryFixed,
                  shape: BoxShape.circle,
                ),
                child: Icon(item.icon, color: cs.primary, size: 22),
              ),
              const SizedBox(width: 14),

              // ✅ CustomText → bodyLarge (Inter 17 w400)
              Expanded(
                child: CustomText(
                  item.label,
                  variant: CustomTextVariant.bodyLarge,
                ),
              ),

              // Chevron
              Icon(
                Icons.chevron_right_rounded,
                color: cs.outlineVariant,
                size: 22,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Tip Card ─────────────────────────────────────────────────────────────────

class _TipCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: cs.secondaryFixed,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Info icon
          Icon(Icons.info_rounded, color: cs.primary, size: 22),
          const SizedBox(width: 14),

          // Text content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ✅ CustomText → labelLarge (Inter 13 w600)
                CustomText(
                  'Tip for sharing',
                  variant: CustomTextVariant.labelLarge,
                  color: cs.onSecondaryFixedVariant,
                ),
                const SizedBox(height: 4),
                // ✅ CustomText → bodyMedium (Inter 15 w400)
                CustomText(
                  'Statuses automatically disappear after 24 hours. '
                      'You can choose who sees your updates in settings.',
                  variant: CustomTextVariant.bodyMedium,
                  color: cs.onSecondaryFixedVariant.withOpacity(0.80),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}