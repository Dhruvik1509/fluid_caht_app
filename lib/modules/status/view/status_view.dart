// lib/modules/status/status_page.dart
//
// Converted from the HTML "Connect – Status" screen.
// Uses CustomText (app_text.dart) throughout.
// All colors from Theme.of(context).colorScheme — light/dark automatic.
// BottomNavigationBar is NOT included — lives in MainShell.

import 'package:flutter/material.dart';
import '../../../core/widgets/app_text.dart';
import 'add_status_view.dart';

// ─── Data model ───────────────────────────────────────────────────────────────

class _StatusContact {
  final String name;
  final String time;
  final String avatarUrl;

  const _StatusContact({
    required this.name,
    required this.time,
    required this.avatarUrl,
  });
}

// ─── Sample data ──────────────────────────────────────────────────────────────

final List<_StatusContact> _recentUpdates = [
  _StatusContact(
    name: 'Sarah Wilson',
    time: '2 minutes ago',
    avatarUrl: 'https://i.pravatar.cc/150?img=5',
  ),
  _StatusContact(
    name: 'Michael Chen',
    time: '15 minutes ago',
    avatarUrl: 'https://i.pravatar.cc/150?img=12',
  ),
  _StatusContact(
    name: 'Elena Rodriguez',
    time: '1 hour ago',
    avatarUrl: 'https://i.pravatar.cc/150?img=9',
  ),
  _StatusContact(
    name: 'David Park',
    time: '3 hours ago',
    avatarUrl: 'https://i.pravatar.cc/150?img=15',
  ),
];

// ─── Main Screen ──────────────────────────────────────────────────────────────

class StatusPage extends StatelessWidget {
  const StatusPage({super.key});

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
            backgroundColor: cs.surfaceContainer,
            backgroundImage: const NetworkImage(
              'https://i.pravatar.cc/150?img=3',
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

      // ── FAB ────────────────────────────────────────────────────────────────
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const AddStatusPage()),
        ),
        backgroundColor: cs.primary,
        foregroundColor: cs.onPrimary,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: const Icon(Icons.camera, size: 28),
      ),

      // ── Body ───────────────────────────────────────────────────────────────
      body: CustomScrollView(
        slivers: [
          // Page title
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 4),
            sliver: SliverToBoxAdapter(
              // ✅ CustomText → headlineLarge (PlusJakartaSans 24 w700)
              child: CustomText(
                'Status',
                variant: CustomTextVariant.headlineLarge,
              ),
            ),
          ),

          // ── MY STATUS section ──────────────────────────────────────────────
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
            sliver: SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ✅ CustomText → labelLarge (Inter 13 w600) + onSurfaceVariant
                  CustomText(
                    'MY STATUS',
                    variant: CustomTextVariant.labelLarge,
                    color: cs.onSurfaceVariant,
                  ),
                  const SizedBox(height: 12),
                  _MyStatusCard(),
                ],
              ),
            ),
          ),

          // ── RECENT UPDATES section ─────────────────────────────────────────
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 28, 20, 0),
            sliver: SliverToBoxAdapter(
              // ✅ CustomText → labelLarge + onSurfaceVariant
              child: CustomText(
                'RECENT UPDATES',
                variant: CustomTextVariant.labelLarge,
                color: cs.onSurfaceVariant,
              ),
            ),
          ),

          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
            sliver: SliverList.separated(
              itemCount: _recentUpdates.length,
              separatorBuilder: (_, __) => const SizedBox(height: 8),
              itemBuilder: (ctx, i) =>
                  _StatusContactCard(contact: _recentUpdates[i]),
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 80)),
        ],
      ),
    );
  }
}

// ─── My Status Card ───────────────────────────────────────────────────────────

class _MyStatusCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Material(
      color: cs.surfaceContainerLowest,
      borderRadius: BorderRadius.circular(16),
      elevation: 0,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {},
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              // Avatar with "+" badge
              Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: cs.outlineVariant,
                        width: 2,
                      ),
                    ),
                    child: const CircleAvatar(
                      radius: 26,
                      backgroundImage:
                      NetworkImage('https://i.pravatar.cc/150?img=47'),
                    ),
                  ),
                  // "+" button
                  Positioned(
                    bottom: -2,
                    right: -2,
                    child: Container(
                      width: 22,
                      height: 22,
                      decoration: BoxDecoration(
                        color: cs.primary,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: cs.surfaceContainerLowest,
                          width: 2,
                        ),
                      ),
                      child: Icon(
                        Icons.add_rounded,
                        size: 14,
                        color: cs.onPrimary,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 14),

              // Name + hint
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ✅ CustomText → titleMedium (PlusJakartaSans 17 w600)
                  CustomText(
                    'Alex Thompson',
                    variant: CustomTextVariant.titleMedium,
                  ),
                  const SizedBox(height: 2),
                  // ✅ CustomText → bodyMedium (Inter 15 w400) + onSurfaceVariant
                  CustomText(
                    'Tap to add status update',
                    variant: CustomTextVariant.bodyMedium,
                    color: cs.onSurfaceVariant,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Status Contact Card ──────────────────────────────────────────────────────

class _StatusContactCard extends StatelessWidget {
  final _StatusContact contact;
  const _StatusContactCard({required this.contact});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Material(
      color: cs.surfaceContainerLowest,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {},
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              // Avatar with primary status ring
              Container(
                width: 56,
                height: 56,
                padding: const EdgeInsets.all(3),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: cs.primary,
                    width: 2,
                  ),
                ),
                child: CircleAvatar(
                  backgroundImage: NetworkImage(contact.avatarUrl),
                ),
              ),
              const SizedBox(width: 14),

              // Name + time
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ✅ CustomText → titleMedium (PlusJakartaSans 17 w600)
                    CustomText(
                      contact.name,
                      variant: CustomTextVariant.titleMedium,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    // ✅ CustomText → bodyMedium (Inter 15 w400) + onSurfaceVariant
                    CustomText(
                      contact.time,
                      variant: CustomTextVariant.bodyMedium,
                      color: cs.onSurfaceVariant,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}