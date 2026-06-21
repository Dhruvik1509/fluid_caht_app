// lib/modules/contact/view/create_group_page.dart
//
// App-level chat group creation (like WhatsApp).
// Step 1: select members from device contacts.
// Step 2: name the group + photo, then create.

import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart' as fc;
import '../../../core/widgets/app_text.dart';
import '../../../core/widgets/app_text_filed.dart';
import '../../chat/controller/conversation_repository.dart';
import '../../chat/model/Conversation.dart';
import '../model/select_contact_model.dart';

class CreateGroupPage extends StatefulWidget {
  const CreateGroupPage({super.key});

  @override
  State<CreateGroupPage> createState() => _CreateGroupPageState();
}

class _CreateGroupPageState extends State<CreateGroupPage> {
  List<SelectContactModel> _allContacts = [];
  final Set<int> _selectedIndices = {};

  bool _isLoading = true;
  String? _errorMessage;
  String _query = '';

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
      final status = await fc.FlutterContacts.permissions
          .request(fc.PermissionType.readWrite);

      if (status != fc.PermissionStatus.granted) {
        setState(() {
          _isLoading = false;
          _errorMessage = 'Contacts permission denied';
        });
        return;
      }

      final deviceContacts = await fc.FlutterContacts.getAll(
        properties: {
          fc.ContactProperty.name,
          fc.ContactProperty.phone,
          fc.ContactProperty.photoThumbnail,
        },
      );

      final list = <SelectContactModel>[];
      for (final c in deviceContacts) {
        final name = c.displayName ?? '';
        if (name.isEmpty) continue;

        list.add(SelectContactModel(
          name: name,
          subtitle: c.phones.isNotEmpty ? c.phones.first.number : 'No phone number',
          avatarUrl: null,
          photo: c.photo?.thumbnail,
          isOnline: false,
        ));
      }

      list.sort((a, b) => a.name.compareTo(b.name));

      setState(() {
        _allContacts = list;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Failed to load contacts: $e';
      });
    }
  }

  List<int> get _filteredIndices {
    if (_query.isEmpty) return List.generate(_allContacts.length, (i) => i);
    final q = _query.toLowerCase();
    final result = <int>[];
    for (var i = 0; i < _allContacts.length; i++) {
      if (_allContacts[i].name.toLowerCase().contains(q)) result.add(i);
    }
    return result;
  }

  void _toggleSelection(int index) {
    setState(() {
      if (_selectedIndices.contains(index)) {
        _selectedIndices.remove(index);
      } else {
        _selectedIndices.add(index);
      }
    });
  }

  void _goToGroupDetails() {
    if (_selectedIndices.isEmpty) return;

    final selectedContacts =
    _selectedIndices.map((i) => _allContacts[i]).toList();

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => _GroupDetailsPage(members: selectedContacts),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: cs.surface,
      appBar: AppBar(
        backgroundColor: cs.surface.withOpacity(0.85),
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 1,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_rounded, color: cs.onSurfaceVariant),
          onPressed: () => Navigator.pop(context),
        ),
        title: CustomText(
          _selectedIndices.isEmpty
              ? 'New Group'
              : 'Add members (${_selectedIndices.length})',
          variant: CustomTextVariant.headlineMedium,
          color: cs.primary,
        ),
      ),
      body: _buildBody(cs),
      floatingActionButton: _selectedIndices.isEmpty
          ? null
          : FloatingActionButton(
        onPressed: _goToGroupDetails,
        backgroundColor: cs.primary,
        foregroundColor: cs.onPrimary,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: const Icon(Icons.arrow_forward_rounded),
      ),
    );
  }

  Widget _buildBody(ColorScheme cs) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

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

    if (_allContacts.isEmpty) {
      return Center(
        child: CustomText(
          'No contacts found',
          variant: CustomTextVariant.bodyMedium,
          color: cs.onSurfaceVariant,
        ),
      );
    }

    final indices = _filteredIndices;

    return Column(
      children: [
        // ── Search ─────────────────────────────────────────────────────────
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
          child: CustomTextFormField(
            hintText: 'Search contacts...',
            prefixIcon: Icons.search_rounded,
            borderRadius: 999,
            borderWidth: 1,
            fillColor: cs.surfaceContainerLow,
            contentPadding:
            const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
            onChanged: (v) => setState(() => _query = v),
          ),
        ),

        // ── Selected chips row ────────────────────────────────────────────
        if (_selectedIndices.isNotEmpty)
          SizedBox(
            height: 84,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _selectedIndices.length,
              itemBuilder: (ctx, i) {
                final idx = _selectedIndices.elementAt(i);
                final c = _allContacts[idx];
                return Padding(
                  padding: const EdgeInsets.only(right: 12),
                  child: Column(
                    children: [
                      Stack(
                        children: [
                          _buildAvatar(c, cs, radius: 26),
                          Positioned(
                            top: -2,
                            right: -2,
                            child: GestureDetector(
                              onTap: () => _toggleSelection(idx),
                              child: Container(
                                padding: const EdgeInsets.all(2),
                                decoration: BoxDecoration(
                                  color: cs.error,
                                  shape: BoxShape.circle,
                                  border: Border.all(color: cs.surface, width: 1.5),
                                ),
                                child: Icon(Icons.close, size: 12, color: cs.onError),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      SizedBox(
                        width: 56,
                        child: CustomText(
                          c.name.split(' ').first,
                          variant: CustomTextVariant.labelSmall,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),

        const Divider(height: 1),

        // ── Contact list ───────────────────────────────────────────────────
        Expanded(
          child: ListView.builder(
            itemCount: indices.length,
            itemBuilder: (ctx, i) {
              final idx = indices[i];
              final c = _allContacts[idx];
              final isSelected = _selectedIndices.contains(idx);

              return InkWell(
                onTap: () => _toggleSelection(idx),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  child: Row(
                    children: [
                      _buildAvatar(c, cs, radius: 24),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomText(
                              c.name,
                              variant: CustomTextVariant.titleSmall,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 2),
                            CustomText(
                              c.subtitle,
                              variant: CustomTextVariant.bodySmall,
                              color: cs.onSurfaceVariant,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                      // Checkbox circle
                      Container(
                        width: 24,
                        height: 24,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isSelected ? cs.primary : Colors.transparent,
                          border: Border.all(
                            color: isSelected ? cs.primary : cs.outlineVariant,
                            width: 2,
                          ),
                        ),
                        child: isSelected
                            ? Icon(Icons.check, size: 16, color: cs.onPrimary)
                            : null,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildAvatar(SelectContactModel c, ColorScheme cs, {required double radius}) {
    if (c.photo != null) {
      return CircleAvatar(radius: radius, backgroundImage: MemoryImage(c.photo!));
    } else if (c.avatarUrl != null) {
      return CircleAvatar(radius: radius, backgroundImage: NetworkImage(c.avatarUrl!));
    }
    return CircleAvatar(
      radius: radius,
      backgroundColor: cs.secondaryFixed,
      child: CustomText(
        c.initials,
        variant: CustomTextVariant.titleSmall,
        color: cs.onSecondaryFixed,
        fontWeight: FontWeight.w700,
      ),
    );
  }
}

// ─── Step 2: Group Details (name + photo) ─────────────────────────────────────

class _GroupDetailsPage extends StatefulWidget {
  final List<SelectContactModel> members;
  const _GroupDetailsPage({required this.members});

  @override
  State<_GroupDetailsPage> createState() => _GroupDetailsPageState();
}

class _GroupDetailsPageState extends State<_GroupDetailsPage> {
  final _groupNameController = TextEditingController();
  bool _isCreating = false;

  @override
  void dispose() {
    _groupNameController.dispose();
    super.dispose();
  }

  Future<void> _createGroup() async {
    final name = _groupNameController.text.trim();
    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a group name')),
      );
      return;
    }

    setState(() => _isCreating = true);

    await Future.delayed(const Duration(milliseconds: 400));

    // ── Add group as a new conversation ──────────────────────────────────────
    final conversation = Conversation(
      name: name,
      avatarUrl: null,
      initials: name.isNotEmpty ? name[0].toUpperCase() : 'G',
      lastMessage: '${widget.members.length} participants',
      time: 'Now',
      isGroup: true,
    );
    ConversationsRepository.instance.addOrUpdate(conversation);

    if (mounted) {
      // Pop CreateGroupPage + SelectContactPage → back to ChatsPage
      Navigator.of(context).popUntil((route) => route.isFirst);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Group "$name" created')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: cs.surface,
      appBar: AppBar(
        backgroundColor: cs.surface.withOpacity(0.85),
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 1,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_rounded, color: cs.onSurfaceVariant),
          onPressed: () => Navigator.pop(context),
        ),
        title: CustomText(
          'New Group',
          variant: CustomTextVariant.headlineMedium,
          color: cs.primary,
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // ── Group icon + name row ─────────────────────────────────────────
          Row(
            children: [
              Stack(
                children: [
                  CircleAvatar(
                    radius: 36,
                    backgroundColor: cs.primaryContainer,
                    child: Icon(Icons.groups_rounded, size: 36, color: cs.onPrimaryContainer),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: cs.primary,
                        shape: BoxShape.circle,
                        border: Border.all(color: cs.surface, width: 2),
                      ),
                      child: Icon(Icons.camera_alt_rounded, size: 14, color: cs.onPrimary),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 16),
              Expanded(
                child: CustomTextFormField(
                  controller: _groupNameController,
                  hintText: 'Group name',
                  borderRadius: 16,
                  textCapitalization: TextCapitalization.words,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          CustomText(
            'Participants: ${widget.members.length}',
            variant: CustomTextVariant.labelLarge,
            color: cs.onSurfaceVariant,
          ),
          const SizedBox(height: 12),

          // ── Members list ─────────────────────────────────────────────────
          ...widget.members.map((c) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: Row(
              children: [
                c.photo != null
                    ? CircleAvatar(radius: 20, backgroundImage: MemoryImage(c.photo!))
                    : CircleAvatar(
                  radius: 20,
                  backgroundColor: cs.secondaryFixed,
                  child: CustomText(
                    c.initials,
                    variant: CustomTextVariant.bodySmall,
                    color: cs.onSecondaryFixed,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(width: 12),
                CustomText(c.name, variant: CustomTextVariant.bodyMedium),
              ],
            ),
          )),

          const SizedBox(height: 32),
          FilledButton(
            onPressed: _isCreating ? null : _createGroup,
            child: _isCreating
                ? const SizedBox(
              width: 22,
              height: 22,
              child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
            )
                : const Text('Create Group'),
          ),
        ],
      ),
    );
  }
}