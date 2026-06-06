// lib/modules/calls/calls_page.dart
//
// Converted from the HTML "Connect – Calls" screen.
// Uses CustomText (app_text.dart) — all colors from Theme (light/dark auto).
// No CustomTextFormField needed here (no input fields on this screen).
// BottomNavigationBar is NOT included — add it in your shell/scaffold.

import 'package:flutter/material.dart';
import '../../../core/widgets/app_text.dart';

// ─── Data model ───────────────────────────────────────────────────────────────

enum _CallType { missed, outgoing, incoming, videoOutgoing }

class _CallItem {
  final String name;
  final String time;
  final _CallType type;
  final String? avatarUrl;
  final String initials; // fallback when no avatar

  const _CallItem({
    required this.name,
    required this.time,
    required this.type,
    this.avatarUrl,
    this.initials = '',
  });
}

// ─── Sample data ──────────────────────────────────────────────────────────────

final List<_CallItem> _calls = [
  _CallItem(
    name: 'Sarah Jenkins',
    time: 'Today, 10:45 AM',
    type: _CallType.missed,
    avatarUrl: 'https://i.pravatar.cc/150?img=5',
  ),
  _CallItem(
    name: 'David Chen',
    time: 'Yesterday, 4:20 PM',
    type: _CallType.outgoing,
    avatarUrl: 'https://i.pravatar.cc/150?img=12',
  ),
  _CallItem(
    name: 'Elena Rodriguez',
    time: 'Wednesday, 11:15 AM',
    type: _CallType.incoming,
    avatarUrl: 'https://i.pravatar.cc/150?img=9',
  ),
  _CallItem(
    name: 'Marcus Knight',
    time: 'May 12, 9:00 PM',
    type: _CallType.videoOutgoing,
    initials: 'MK',
  ),
  _CallItem(
    name: 'Oliver Sykes',
    time: 'May 10, 2:15 PM',
    type: _CallType.missed,
    avatarUrl: 'https://i.pravatar.cc/150?img=15',
  ),
];

// ─── Filter tabs ──────────────────────────────────────────────────────────────

const List<String> _filterTabs = ['All', 'Missed', 'Recordings'];

// ─── Main Screen ──────────────────────────────────────────────────────────────

class CallsPage extends StatefulWidget {
  const CallsPage({super.key});

  @override
  State<CallsPage> createState() => _CallsPageState();
}

class _CallsPageState extends State<CallsPage> {
  int _selectedFilter = 0;

  List<_CallItem> get _filtered {
    if (_selectedFilter == 1) {
      return _calls.where((c) => c.type == _CallType.missed).toList();
    }
    // "Recordings" — empty for now
    if (_selectedFilter == 2) return [];
    return _calls;
  }

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
        leading: Padding(
          padding: const EdgeInsets.only(left: 16),
          child: Icon(Icons.hub_rounded, color: cs.primary, size: 26),
        ),
        // ✅ CustomText → headlineLarge (PlusJakartaSans 28 w700) + primary
        title: CustomText(
          'Calls',
          variant: CustomTextVariant.headlineLarge,
          color: cs.primary,
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.search, color: cs.onSurfaceVariant),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(Icons.add_call, color: cs.onSurfaceVariant),
            onPressed: () {},
          ),
          const SizedBox(width: 4),
        ],
      ),

      // ── Body ───────────────────────────────────────────────────────────────
      body: CustomScrollView(
        slivers: [
          // ── Filter chips ─────────────────────────────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: List.generate(_filterTabs.length, (i) {
                    final active = i == _selectedFilter;
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: _FilterChip(
                        label: _filterTabs[i],
                        isActive: active,
                        onTap: () => setState(() => _selectedFilter = i),
                      ),
                    );
                  }),
                ),
              ),
            ),
          ),

          // ── "Recent Calls" header ─────────────────────────────────────────
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
            sliver: SliverToBoxAdapter(
              // ✅ CustomText → labelLarge (Inter 13 w600 tracking 0.05) + outline
              child: CustomText(
                'RECENT CALLS',
                variant: CustomTextVariant.labelLarge,
                color: cs.outline,
              ),
            ),
          ),

          // ── Call list ─────────────────────────────────────────────────────
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            sliver: SliverList.separated(
              itemCount: _filtered.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (ctx, i) => _CallCard(item: _filtered[i]),
            ),
          ),

          // ── Pro Tip bento card ────────────────────────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 28, 16, 24),
              child: _ProTipCard(),
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 80)),
        ],
      ),
    );
  }
}

// ─── Filter Chip ──────────────────────────────────────────────────────────────

class _FilterChip extends StatelessWidget {
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _FilterChip({
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        decoration: BoxDecoration(
          color: isActive ? cs.primary : cs.surfaceContainerLow,
          borderRadius: BorderRadius.circular(999),
          boxShadow: isActive
              ? [BoxShadow(color: cs.primary.withOpacity(0.25), blurRadius: 8)]
              : null,
        ),
        // ✅ CustomText → labelLarge (Inter 13 w600)
        child: CustomText(
          label,
          variant: CustomTextVariant.labelLarge,
          color: isActive ? cs.onPrimary : cs.onSurfaceVariant,
        ),
      ),
    );
  }
}

// ─── Call Card ────────────────────────────────────────────────────────────────

class _CallCard extends StatelessWidget {
  final _CallItem item;
  const _CallCard({required this.item});

  // Icon + color per call type
  IconData get _directionIcon {
    switch (item.type) {
      case _CallType.missed:
        return Icons.call_missed_rounded;
      case _CallType.outgoing:
        return Icons.call_made_rounded;
      case _CallType.incoming:
        return Icons.call_received_rounded;
      case _CallType.videoOutgoing:
        return Icons.videocam_rounded;
    }
  }

  // Action button icon
  IconData get _actionIcon {
    switch (item.type) {
      case _CallType.videoOutgoing:
        return Icons.videocam_rounded;
      default:
        return Icons.call_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isMissed = item.type == _CallType.missed;
    final nameColor = isMissed ? cs.error : cs.onSurface;
    final iconColor = isMissed
        ? cs.error
        : (item.type == _CallType.incoming ? cs.outline : cs.primary);

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
              // ── Avatar ──────────────────────────────────────────────────
              Stack(
                children: [
                  item.avatarUrl != null
                      ? CircleAvatar(
                    radius: 28,
                    backgroundImage: NetworkImage(item.avatarUrl!),
                  )
                      : CircleAvatar(
                    radius: 28,
                    backgroundColor: cs.secondaryContainer,
                    // ✅ CustomText → titleMedium + onSecondaryContainer
                    child: CustomText(
                      item.initials,
                      variant: CustomTextVariant.titleMedium,
                      color: cs.onSecondaryContainer,
                    ),
                  ),
                  // Red dot for missed calls
                  if (isMissed)
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        width: 14,
                        height: 14,
                        decoration: BoxDecoration(
                          color: cs.error,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: cs.surfaceContainerLowest,
                            width: 2,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(width: 14),

              // ── Name + call info ─────────────────────────────────────────
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ✅ CustomText → titleMedium (PlusJakartaSans 17 w600)
                    //    error color for missed, onSurface otherwise
                    CustomText(
                      item.name,
                      variant: CustomTextVariant.titleMedium,
                      color: nameColor,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(_directionIcon, color: iconColor, size: 16),
                        const SizedBox(width: 4),
                        // ✅ CustomText → labelMedium (Inter 12 w500) + onSurfaceVariant
                        CustomText(
                          item.time,
                          variant: CustomTextVariant.labelMedium,
                          color: cs.onSurfaceVariant,
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // ── Action button ────────────────────────────────────────────
              Material(
                color: cs.surfaceContainerLow,
                shape: const CircleBorder(),
                child: InkWell(
                  customBorder: const CircleBorder(),
                  onTap: () {},
                  child: SizedBox(
                    width: 40,
                    height: 40,
                    child: Icon(_actionIcon, color: cs.primary, size: 20),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Pro Tip Bento Card ───────────────────────────────────────────────────────

class _ProTipCard extends StatelessWidget {
  const _ProTipCard();

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: Stack(
        children: [
          // Background + glow blob
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: cs.primaryContainer.withOpacity(0.10),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: cs.primary.withOpacity(0.20)),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Left content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // "PRO TIP" badge
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: cs.primary,
                          borderRadius: BorderRadius.circular(999),
                        ),
                        // ✅ CustomText → labelSmall (Inter 10 w700)
                        child: CustomText(
                          'PRO TIP',
                          variant: CustomTextVariant.labelSmall,
                          color: cs.onPrimary,
                          letterSpacing: 1.2,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 8),
                      // ✅ CustomText → headlineMedium (PlusJakartaSans 20 w600) + primary
                      CustomText(
                        'Crystal Clear Video',
                        variant: CustomTextVariant.headlineMedium,
                        color: cs.primary,
                      ),
                      const SizedBox(height: 6),
                      // ✅ CustomText → bodyMedium (Inter 15 w400) + onSurfaceVariant
                      CustomText(
                        'Upgrade to HD calling for your next business meeting.',
                        variant: CustomTextVariant.bodyMedium,
                        color: cs.onSurfaceVariant,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 16),
                      // "Learn More" button
                      GestureDetector(
                        onTap: () {},
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            color: cs.primary,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          // ✅ CustomText → labelLarge (Inter 13 w600)
                          child: CustomText(
                            'Learn More',
                            variant: CustomTextVariant.labelLarge,
                            color: cs.onPrimary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                // Decorative videocam icon
                Icon(
                  Icons.videocam_rounded,
                  size: 64,
                  color: cs.primary.withOpacity(0.20),
                ),
              ],
            ),
          ),

          // Glow blob (bottom-right)
          Positioned(
            right: -20,
            bottom: -20,
            child: Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: cs.primary.withOpacity(0.15),
                shape: BoxShape.circle,
              ),
            ),
          ),
        ],
      ),
    );
  }
}