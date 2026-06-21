import 'package:fluid_caht_app/modules/contact/view/select_contact_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart' as fc;
import '../../../core/widgets/app_text.dart';
import '../../../core/widgets/app_text_filed.dart';
import '../model/contect_model.dart';

const List<String> _alphabetLetters = [
  'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H',
  'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P',
  'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X',
  'Y', 'Z',
];

// ─── Main Screen ──────────────────────────────────────────────────────────────

class ContactsView extends StatefulWidget {
  const ContactsView({super.key});

  @override
  State<ContactsView> createState() => _ContactsViewState();
}

class _ContactsViewState extends State<ContactsView> {
  final TextEditingController _searchController = TextEditingController();
  String _query = '';

  Map<String, List<Contact>> _contactSections = {};
  bool _isLoading = true;
  String? _errorMessage;

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
      final Map<String, List<Contact>> grouped = {};

      for (final c in deviceContacts) {
        final name = c.displayName ?? '';
        if (name.isEmpty) continue;

        final firstChar = name[0].toUpperCase();
        final letter = RegExp(r'^[A-Z]$').hasMatch(firstChar) ? firstChar : '#';

        final contact = Contact(
          name: name,
          status: c.phones.isNotEmpty ? c.phones.first.number : 'No phone number',
          avatarUrl: null,
          photo: c.photo?.thumbnail,
          isOnline: false,
        );

        grouped.putIfAbsent(letter, () => []).add(contact);
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
        _contactSections = sortedMap;
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
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // Filter contacts by search query
  Map<String, List<Contact>> get _filtered {
    if (_query.isEmpty) return _contactSections;
    final q = _query.toLowerCase();
    final result = <String, List<Contact>>{};
    for (final entry in _contactSections.entries) {
      final matches =
      entry.value.where((c) => c.name.toLowerCase().contains(q)).toList();
      if (matches.isNotEmpty) result[entry.key] = matches;
    }
    return result;
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
        leadingWidth: 56,
        leading: Padding(
          padding: const EdgeInsets.only(left: 16),
          child: CircleAvatar(
            radius: 20,
            backgroundImage:
            const NetworkImage('https://i.pravatar.cc/150?img=3'),
          ),
        ),
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
      body: _buildBody(cs),

      // ── FAB ────────────────────────────────────────────────────────────────
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push<bool>(
            context,
            MaterialPageRoute(builder: (context) => const SelectContactPage()),
          );

          // SelectContactPage પરથી પાછા આવ્યા + નવો contact add થયો → refresh
          if (result == true) {
            _loadDeviceContacts();
          }
        },
        backgroundColor: cs.primary,
        foregroundColor: cs.onPrimary,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: const Icon(Icons.person_add_alt_rounded, size: 28),
      ),
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
              SecondaryText(
                _errorMessage!,
                variant: CustomTextVariant.bodyMedium,
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
    if (_contactSections.isEmpty) {
      return Center(
        child: SecondaryText(
          'No contacts found',
          variant: CustomTextVariant.bodyMedium,
        ),
      );
    }

    // Loaded contacts list
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Main scrollable list
        Expanded(
          child: CustomScrollView(
            slivers: [
              // ── Search bar via CustomTextFormField ──────────────────────
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                  child: CustomTextFormField(
                    controller: _searchController,
                    hintText: 'Search contacts...',
                    prefixIcon: Icons.search_rounded,
                    borderRadius: 999, // pill shape
                    borderWidth: 1,
                    fillColor: cs.surfaceContainerLow,
                    contentPadding:
                    const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
                    onChanged: (v) => setState(() => _query = v),
                  ),
                ),
              ),

              // ── Alphabetical sections ───────────────────────────────────
              for (final entry in _filtered.entries) ...[
                // Sticky letter header
                SliverPersistentHeader(
                  pinned: true,
                  delegate: _StickyLetterDelegate(
                    letter: entry.key,
                    surfaceColor: cs.surface,
                  ),
                ),
                // Contact cards
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                          (ctx, i) => Padding(
                        padding: const EdgeInsets.only(bottom: 6),
                        child: ContactCard(contact: entry.value[i]),
                      ),
                      childCount: entry.value.length,
                    ),
                  ),
                ),
              ],

              // Bottom padding so FAB doesn't obscure last item
              const SliverToBoxAdapter(child: SizedBox(height: 96)),
            ],
          ),
        ),

        // Alphabet quick-scroll sidebar
        _AlphabetSidebar(letters: _alphabetLetters, sections: _contactSections),
      ],
    );
  }
}

// ─── Sticky Letter Header ─────────────────────────────────────────────────────

class _StickyLetterDelegate extends SliverPersistentHeaderDelegate {
  final String letter;
  final Color surfaceColor;

  const _StickyLetterDelegate({
    required this.letter,
    required this.surfaceColor,
  });

  @override
  double get minExtent => 36;
  @override
  double get maxExtent => 36;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: surfaceColor.withOpacity(0.95),
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 4),
      alignment: Alignment.centerLeft,
      child: PrimaryText(
        letter,
        variant: CustomTextVariant.labelLarge,
      ),
    );
  }

  @override
  bool shouldRebuild(_StickyLetterDelegate old) =>
      old.letter != letter || old.surfaceColor != surfaceColor;
}

// ─── Contact Card ─────────────────────────────────────────────────────────────

class ContactCard extends StatelessWidget {
  final Contact contact;
  const ContactCard({required this.contact});

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
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              _Avatar(contact: contact),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(
                      contact.name,
                      variant: CustomTextVariant.titleSmall,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    SecondaryText(
                      contact.status,
                      variant: CustomTextVariant.bodySmall,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              if (contact.hasBlueDot) ...[
                const SizedBox(width: 8),
                Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    color: cs.primary,
                    shape: BoxShape.circle,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Avatar (image / device photo / initials) ─────────────────────────────────

class _Avatar extends StatelessWidget {
  final Contact contact;
  const _Avatar({required this.contact});

  String get _initials {
    final parts = contact.name.split(' ');
    return parts.isNotEmpty && parts[0].isNotEmpty
        ? parts[0][0].toUpperCase()
        : '?';
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    Widget avatarChild;

    if (contact.photo != null) {
      avatarChild = CircleAvatar(
        radius: 24,
        backgroundImage: MemoryImage(contact.photo!),
      );
    } else if (contact.avatarUrl != null) {
      avatarChild = CircleAvatar(
        radius: 24,
        backgroundImage: NetworkImage(contact.avatarUrl!),
      );
    } else {
      avatarChild = CircleAvatar(
        radius: 24,
        backgroundColor: cs.secondaryContainer,
        child: CustomText(
          _initials,
          variant: CustomTextVariant.headlineSmall,
          color: cs.onSecondaryContainer,
        ),
      );
    }

    return Stack(
      clipBehavior: Clip.none,
      children: [
        avatarChild,
        if (contact.isOnline)
          Positioned(
            bottom: 0,
            right: 0,
            child: Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                color: Colors.green,
                shape: BoxShape.circle,
                border: Border.all(
                  color: cs.surfaceContainerLowest,
                  width: 2,
                ),
              ),
            ),
          ),
      ],
    );
  }
}

// ─── Alphabet Sidebar ─────────────────────────────────────────────────────────

class _AlphabetSidebar extends StatelessWidget {
  final List<String> letters;
  final Map<String, List<Contact>> sections;
  const _AlphabetSidebar({required this.letters, required this.sections});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 4),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: letters.map((l) {
          final hasSection = sections.containsKey(l);
          return GestureDetector(
            onTap: () {
              // TODO: scroll to section '$l'
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 2),
              child: CustomText(
                l,
                variant: CustomTextVariant.labelSmall,
                color: hasSection ? cs.primary : cs.onSurfaceVariant,
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}