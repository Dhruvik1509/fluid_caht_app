// lib/modules/contacts/select_contact_page.dart
//
// Converted from the HTML "Select Contact" screen.
// Transactional page — pushed via Navigator (no BottomNav, no FAB).
// Uses CustomText (app_text.dart) throughout.
// All colors from Theme.of(context).colorScheme — light/dark automatic.

import 'package:fluid_caht_app/modules/contact/model/select_contact_model.dart';
import 'package:flutter/material.dart';
import '../../../core/widgets/app_text.dart';
// ─── Sample data ──────────────────────────────────────────────────────────────

final Map<String, List<SelectContactModel>> _sections = {
  'A': [
    SelectContactModel(
      name: 'Alice Thompson',
      subtitle: 'Design is thinking made visual',
      avatarUrl: 'https://i.pravatar.cc/150?img=5',
      isOnline: true,
    ),
    SelectContactModel(
      name: 'Andrew Miller',
      subtitle: 'Last seen 2 hours ago',
      avatarUrl: 'https://i.pravatar.cc/150?img=12',
    ),
  ],
  'B': [
    SelectContactModel(
      name: 'Bella Chen',
      subtitle: 'Available for quick calls',
      avatarUrl: 'https://i.pravatar.cc/150?img=9',
    ),
    SelectContactModel(
      name: 'Brian Wright',
      subtitle: 'Busy • At the gym',
      initials: 'BW',
    ),
  ],
  'C': [
    SelectContactModel(
      name: 'Cameron Diaz',
      subtitle: 'Coding the future...',
      avatarUrl: 'https://i.pravatar.cc/150?img=15',
    ),
    SelectContactModel(
      name: 'Catherine Styles',
      subtitle: 'Last seen yesterday',
      avatarUrl: 'https://i.pravatar.cc/150?img=20',
    ),
  ],
};

// ─── Main Screen ──────────────────────────────────────────────────────────────

class SelectContactPage extends StatelessWidget {
  const SelectContactPage({super.key});

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
          icon: Icon(Icons.arrow_back_rounded, color: cs.onSurfaceVariant),
          onPressed: () => Navigator.pop(context),
        ),
        // ✅ CustomText → headlineMedium (PlusJakartaSans 20 w600) + primary
        title: CustomText(
          'Select Contact',
          variant: CustomTextVariant.headlineMedium,
          color: cs.primary,
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.search_rounded, color: cs.onSurfaceVariant),
            onPressed: () {},
          ),
          const SizedBox(width: 4),
        ],
      ),

      // ── Body ───────────────────────────────────────────────────────────────
      body: CustomScrollView(
        slivers: [
          // ── Quick action rows ─────────────────────────────────────────────
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 4),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                _ActionRow(
                  icon: Icons.group_add_rounded,
                  label: 'New Group',
                  onTap: () {},
                ),
                const SizedBox(height: 4),
                _ActionRow(
                  icon: Icons.person_add_rounded,
                  label: 'New Contact',
                  onTap: () {},
                ),
              ]),
            ),
          ),

          // ── Alphabetical contact sections ─────────────────────────────────
          for (final entry in _sections.entries) ...[
            // Sticky letter header
            SliverPersistentHeader(
              pinned: true,
              delegate: _SectionHeaderDelegate(
                letter: entry.key,
                bgColor: cs.surfaceContainerLow,
                textColor: cs.primary,
              ),
            ),
            // Contact rows
            SliverList(
              delegate: SliverChildBuilderDelegate(
                    (ctx, i) {
                  final contact = entry.value[i];
                  final isLast = i == entry.value.length - 1;
                  return SelectContactModelRow(
                    contact: contact,
                    showDivider: !isLast,
                  );
                },
                childCount: entry.value.length,
              ),
            ),
          ],

          const SliverToBoxAdapter(child: SizedBox(height: 32)),
        ],
      ),
    );
  }
}

// ─── Quick Action Row ─────────────────────────────────────────────────────────

class _ActionRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _ActionRow({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          child: Row(
            children: [
              // Icon circle with primaryContainer bg
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: cs.primaryContainer,
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: cs.onPrimaryContainer, size: 22),
              ),
              const SizedBox(width: 16),
              // ✅ CustomText → headlineMedium (PlusJakartaSans 20 w600)
              CustomText(
                label,
                variant: CustomTextVariant.headlineMedium,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Sticky Section Header ────────────────────────────────────────────────────

class _SectionHeaderDelegate extends SliverPersistentHeaderDelegate {
  final String letter;
  final Color bgColor;
  final Color textColor;

  const _SectionHeaderDelegate({
    required this.letter,
    required this.bgColor,
    required this.textColor,
  });

  @override
  double get minExtent => 36;
  @override
  double get maxExtent => 36;

  @override
  Widget build(BuildContext ctx, double shrink, bool overlaps) {
    return Container(
      color: bgColor,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      alignment: Alignment.centerLeft,
      // ✅ CustomText → labelLarge (Inter 13 w600 tracking 0.05) + primary
      child: CustomText(
        letter,
        variant: CustomTextVariant.labelLarge,
        color: textColor,
      ),
    );
  }

  @override
  bool shouldRebuild(_SectionHeaderDelegate old) =>
      old.letter != letter || old.bgColor != bgColor;
}

// ─── Contact Row ──────────────────────────────────────────────────────────────

class SelectContactModelRow extends StatelessWidget {
  final SelectContactModel contact;
  final bool showDivider;

  const SelectContactModelRow({
    required this.contact,
    this.showDivider = true,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return InkWell(
      onTap: () {},
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Row(
                children: [
                  // ── Avatar ──────────────────────────────────────────────
                  Stack(
                    children: [
                      contact.avatarUrl != null
                          ? CircleAvatar(
                        radius: 28,
                        backgroundImage:
                        NetworkImage(contact.avatarUrl!),
                      )
                          : CircleAvatar(
                        radius: 28,
                        backgroundColor: cs.secondaryFixed,
                        // ✅ CustomText → headlineMedium + onSecondaryFixed
                        child: CustomText(
                          contact.initials,
                          variant: CustomTextVariant.headlineMedium,
                          color: cs.onSecondaryFixed,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      // Online dot
                      if (contact.isOnline)
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            width: 13,
                            height: 13,
                            decoration: BoxDecoration(
                              color: Colors.green,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: cs.surface,
                                width: 2,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(width: 16),

                  // ── Name + subtitle ────────────────────────────────────
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // ✅ CustomText → headlineMedium (PlusJakartaSans 20 w600)
                        CustomText(
                          contact.name,
                          variant: CustomTextVariant.displaySmall,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 2),
                        // ✅ CustomText → bodyMedium (Inter 15 w400) + onSurfaceVariant
                        CustomText(
                          contact.subtitle,
                          variant: CustomTextVariant.bodyMedium,
                          color: cs.onSurfaceVariant,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // Divider between contacts (not after last)
            if (showDivider)
              Divider(
                color: cs.outlineVariant.withOpacity(0.35),
                height: 1,
                thickness: 1,
              ),
          ],
        ),
      ),
    );
  }
}