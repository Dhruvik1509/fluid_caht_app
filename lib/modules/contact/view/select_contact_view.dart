// lib/modules/contacts/select_contact_page.dart
//
// Converted from the HTML "Select Contact" screen.
// Transactional page — pushed via Navigator (no BottomNav, no FAB).
// Uses CustomText (app_text.dart) throughout.
// All colors from Theme.of(context).colorScheme — light/dark automatic.
// Now loads REAL device contacts using flutter_contacts.

import 'package:fluid_caht_app/modules/contact/model/select_contact_model.dart';
import 'package:fluid_caht_app/modules/contact/view/add_contact_view.dart';
import 'package:fluid_caht_app/modules/contact/view/create_group_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart' as fc;
import '../../../core/widgets/app_text.dart';
import '../../chat/controller/conversation_repository.dart';
import '../../chat/model/Conversation.dart';
import '../../chat/view/chat_view.dart';

// ─── Main Screen ──────────────────────────────────────────────────────────────

class SelectContactPage extends StatefulWidget {
  const SelectContactPage({super.key});

  @override
  State<SelectContactPage> createState() => _SelectContactPageState();
}

class _SelectContactPageState extends State<SelectContactPage> {
  Map<String, List<SelectContactModel>> _sections = {};
  bool _isLoading = true;
  String? _errorMessage;
  bool _contactWasAdded = false;

  @override
  void initState() {
    super.initState();
    _loadDeviceContacts();
  }

  Future<void> _loadDeviceContacts() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // ── Permission request ──────────────────────────────────────────────
      final status = await fc.FlutterContacts.permissions
          .request(fc.PermissionType.readWrite);

      if (status != fc.PermissionStatus.granted) {
        setState(() {
          _isLoading = false;
          _errorMessage = 'Contacts permission denied';
        });
        return;
      }

      // ── Fetch all contacts with name, phone, thumbnail ──────────────────
      final deviceContacts = await fc.FlutterContacts.getAll(
        properties: {
          fc.ContactProperty.name,
          fc.ContactProperty.phone,
          fc.ContactProperty.photoThumbnail,
        },
      );

      // Group by first letter
      final Map<String, List<SelectContactModel>> grouped = {};

      for (final c in deviceContacts) {
        final name = c.displayName ?? '';
        if (name.isEmpty) continue;

        final firstChar = name[0].toUpperCase();
        final letter = RegExp(r'^[A-Z]$').hasMatch(firstChar) ? firstChar : '#';

        final model = SelectContactModel(
          name: name,
          subtitle: c.phones.isNotEmpty
              ? c.phones.first.number
              : 'No phone number',
          avatarUrl: null,
          photo: c.photo?.thumbnail,
          isOnline: false,
        );

        grouped.putIfAbsent(letter, () => []).add(model);
      }

      // Sort each section alphabetically
      grouped.forEach((key, list) {
        list.sort((a, b) => a.name.compareTo(b.name));
      });

      // Sort keys (A-Z order, # at end)
      final sortedKeys = grouped.keys.toList()
        ..sort((a, b) {
          if (a == '#') return 1;
          if (b == '#') return -1;
          return a.compareTo(b);
        });
      final sortedMap = {for (var k in sortedKeys) k: grouped[k]!};

      setState(() {
        _sections = sortedMap;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Failed to load contacts: $e';
      });
    }
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
        leading: IconButton(
          icon: Icon(Icons.arrow_back_rounded, color: cs.onSurfaceVariant),
          onPressed: () => Navigator.pop(context, _contactWasAdded), // ← updated
        ),
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
      body: _buildBody(cs),
    );
  }

  Widget _buildBody(ColorScheme cs) {
    // Loading state
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    // Error / permission denied state
    if (_errorMessage != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.contacts_outlined, size: 48, color: cs.onSurfaceVariant),
              const SizedBox(height: 16),
              CustomText(
                _errorMessage!,
                variant: CustomTextVariant.bodyMedium,
                color: cs.onSurfaceVariant,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              FilledButton(
                onPressed: _loadDeviceContacts,
                child: const Text('Try Again'),
              ),
            ],
          ),
        ),
      );
    }

    // Empty state
    if (_sections.isEmpty) {
      return Center(
        child: CustomText(
          'No contacts found',
          variant: CustomTextVariant.bodyMedium,
          color: cs.onSurfaceVariant,
        ),
      );
    }

    // ── Loaded contacts list ───────────────────────────────────────────────
    return CustomScrollView(
      slivers: [
        // ── Quick action rows ─────────────────────────────────────────────
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 4),
          sliver: SliverList(
            delegate: SliverChildListDelegate([
              _ActionRow(
                icon: Icons.group_add_rounded,
                label: 'New Group',
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => CreateGroupPage(),));
                },
              ),
              const SizedBox(height: 4),
              _ActionRow(
                icon: Icons.person_add_rounded,
                label: 'New Contact',
                onTap: () async {
                  final result = await Navigator.push<bool>(
                    context,
                    MaterialPageRoute(builder: (context) => const AddContactPage()),
                  );
                  if (result == true) {
                    _contactWasAdded = true;          // ← mark કરો
                    _loadDeviceContacts();            // current page refresh
                  }
                },
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
      onTap: () {
        // ── Add this contact as a new conversation ─────────────────────────
        final conversation = Conversation(
          name: contact.name,
          avatarUrl: contact.avatarUrl,
          initials: contact.initials,
          lastMessage: 'Tap to start chatting',
          time: 'Now',
          photo: contact.photo, // device contact photo (Uint8List?)
        );
        ConversationsRepository.instance.addOrUpdate(conversation);

        // Open chat directly, replacing this page (so back → ChatsPage)
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => ChatView(
              name: contact.name,
              avatarUrl: contact.avatarUrl,
              initials: contact.initials,
              isOnline: contact.isOnline,
            ),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Row(
                children: [
                  // ── Avatar (device photo / network / initials) ─────────
                  Stack(
                    children: [
                      _buildAvatar(cs),
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
                        CustomText(
                          contact.name,
                          variant: CustomTextVariant.displaySmall,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 2),
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

  Widget _buildAvatar(ColorScheme cs) {
    if (contact.photo != null) {
      // Device contact photo (Uint8List)
      return CircleAvatar(
        radius: 28,
        backgroundImage: MemoryImage(contact.photo!),
      );
    } else if (contact.avatarUrl != null) {
      // Network image
      return CircleAvatar(
        radius: 28,
        backgroundImage: NetworkImage(contact.avatarUrl!),
      );
    } else {
      // Initials fallback
      return CircleAvatar(
        radius: 28,
        backgroundColor: cs.secondaryFixed,
        child: CustomText(
          contact.initials,
          variant: CustomTextVariant.headlineMedium,
          color: cs.onSecondaryFixed,
          fontWeight: FontWeight.w700,
        ),
      );
    }
  }
}