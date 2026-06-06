import 'package:fluid_caht_app/modules/contact/view/select_contact_view.dart';
import 'package:flutter/material.dart';
import '../../../core/widgets/app_text.dart';
import '../../../core/widgets/app_text_filed.dart';
import '../model/contect_model.dart';



// ─── Sample data (replace with your real data source) ─────────────────────────

final Map<String, List<Contact>> ContactSections = {
  'A': [
    Contact(
      name: 'Adrian Smith',
      status: 'Available for collaboration',
      avatarUrl: 'https://i.pravatar.cc/150?img=11',
      isOnline: true,
    ),
    Contact(
      name: 'Alisa Vonn',
      status: 'Last seen 2h ago',
      avatarUrl: 'https://i.pravatar.cc/150?img=5',
    ),
  ],
  'B': [
    Contact(
      name: 'Benjamin Chen',
      status: 'Busy • At the gym',
      avatarUrl: 'https://i.pravatar.cc/150?img=12',
    ),
  ],
  'D': [
    Contact(
      name: 'Diana Prince',
      status: 'Online',
      avatarUrl: 'https://i.pravatar.cc/150?img=9',
      hasBlueDot: true,
    ),
  ],
  'H': [
    Contact(
      name: 'Harrison Ford',
      status: 'Away until Monday',
      // no avatarUrl → shows initials
    ),
  ],
};

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

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // Filter contacts by search query
  Map<String, List<Contact>> get _filtered {
    if (_query.isEmpty) return ContactSections;
    final q = _query.toLowerCase();
    final result = <String, List<Contact>>{};
    for (final entry in ContactSections.entries) {
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
        // ✅ CustomText → headlineMedium (PlusJakartaSans 20 w600) + primary color
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
      body: Row(
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
          _AlphabetSidebar(letters: _alphabetLetters),
        ],
      ),

      // ── FAB ────────────────────────────────────────────────────────────────
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => SelectContactPage(),));
        },
        backgroundColor: cs.primary,
        foregroundColor: cs.onPrimary,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: const Icon(Icons.person_add_alt_rounded, size: 28),
      ),
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
      // ✅ PrimaryText → labelLarge (Inter 13 w600 + primary color)
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
              // Avatar with optional online dot
              _Avatar(contact: contact),
              const SizedBox(width: 12),

              // Name + status
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ✅ CustomText → titleSmall (PlusJakartaSans 15 w600)
                    CustomText(
                      contact.name,
                      variant: CustomTextVariant.titleSmall,
                      // titleSmall uses onSurface by default from textTheme
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    // ✅ SecondaryText → bodySmall (Inter 13) + onSurfaceVariant
                    SecondaryText(
                      contact.status,
                      variant: CustomTextVariant.bodySmall,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),

              // ✅ Blue "Online" dot on the right (primary color)
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

// ─── Avatar (image or initials) ───────────────────────────────────────────────

class _Avatar extends StatelessWidget {
  final Contact contact;
  const _Avatar({required this.contact});

  String get _initials {
    final parts = contact.name.split(' ');
    return parts.isNotEmpty ? parts[0][0].toUpperCase() : '?';
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        if (contact.avatarUrl != null)
          CircleAvatar(
            radius: 24,
            backgroundImage: NetworkImage(contact.avatarUrl!),
          )
        else
        // ✅ Initials via CustomText → headlineSmall + onSecondaryContainer
          CircleAvatar(
            radius: 24,
            backgroundColor: cs.secondaryContainer,
            child: CustomText(
              _initials,
              variant: CustomTextVariant.headlineSmall,
              color: cs.onSecondaryContainer,
            ),
          ),

        // Green "online" dot
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
  const _AlphabetSidebar({required this.letters});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 4),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: letters.map((l) {
          final hasSection = ContactSections.containsKey(l);
          return GestureDetector(
            onTap: () {
              // TODO: scroll to section '$l'
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 2),
              // ✅ CustomText → labelSmall (Inter 11 w500)
              //    primary color for letters that have contacts, muted otherwise
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