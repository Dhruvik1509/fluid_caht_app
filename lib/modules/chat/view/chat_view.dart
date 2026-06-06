// lib/modules/chats/chats_page.dart
//
// Updated to use CustomText (app_text.dart) + CustomTextFormField (app_text_filed.dart)
// everywhere. All colors come from Theme — light/dark automatic.

import 'package:flutter/material.dart';
import 'package:fluid_caht_app/core/widgets/app_text.dart';
import 'package:fluid_caht_app/core/widgets/app_text_filed.dart';

import '../model/Conversation.dart';
import '../model/story.dart';

class ChatsPage extends StatefulWidget {
  const ChatsPage({super.key});

  @override
  State<ChatsPage> createState() => _ChatsPageState();
}

class _ChatsPageState extends State<ChatsPage> {
  final TextEditingController _searchController = TextEditingController();

  final List<Story> _stories = [
    Story(
      name: 'Sarah',
      initials: 'S',
      avatarUrl:
      'https://lh3.googleusercontent.com/aida-public/AB6AXuDTOM06jQRS193sPyfjpFN8X1NXca8w6Jb_Ul1Q0byObmZ1zkZKm9SrqK6fKRVe2twXKlQ8VV6r1sxHOnWnfcipoHnzPZZI5PYi8sI2buEFrKoA14Y0MTNBtzFr0J65603j-A5xhCihhLWqnk3Zz6olyWOXA5An3_9_3T0HRwQehHTISDoJANyg4GHShLWUKJcWir0Wx4Fag2hHnbTD9Ae6ab6a6nBRJhdaPavbzGMceKEG9ixdTWpX4QkD3H8OnGKSmZSCdbgb-JeR',
    ),
    Story(
      name: 'David',
      initials: 'D',
      avatarUrl:
      'https://lh3.googleusercontent.com/aida-public/AB6AXuDSzuQO93y_BinE1AllUGD6nuE12F2OglOjY4ZaKDguKPUKiFdum9R78UtjG9pmCGBZA77X1qIsWKKyyQddFsdrNWGNrE1SSAc4JAF1eRQO0srxJpgFWfBFMqDb7me8wC0GA9Wn-vrccuI39_IcwguNYTEtXogIr-nmQ0erKBBBiTmHEeKYL8rxPeBRqusmuOou9tGywciOW2u89l96WidBmwq9EZtYSt9GMqm7OvGG-0EN4Gldm4880mWPVMmS8HZY3qXr-HQd0oil',
      isViewed: true,
    ),
    Story(
      name: 'Elena',
      initials: 'E',
      avatarUrl:
      'https://lh3.googleusercontent.com/aida-public/AB6AXuCOt1rzsQW6FC0XjxsvgzWDvmUg2m_yKkb0gNEl72QEKzH1GxCtR92YdrpO6QwmFiCCzYSHyP3G418bQ8mj_5qqxhgVbPxk_b80GfMsCLLpL7vkJWvaYfiE-cMVK410cJyeSMhWI_GTysOajiK3tfo8ae_uipoH064wdlXAqeFhkKTJpgXAzksSN55o6wuq2GYN0zrZMoHIbUV39LMeNyNlnU5_hmO8c-EtzmFpgfRmN-2nZ1ng4KQl-CrdeWBf3Qo2zD3Dd-i2rkyL',
      isViewed: true,
    ),
    Story(
      name: 'Marcus',
      initials: 'M',
      avatarUrl:
      'https://lh3.googleusercontent.com/aida-public/AB6AXuD_m4z0jWLnmmEiNx0tOB5TSbg1Ud9-rvu6uv1Gy2vKwKJUhQe61IdZgFqKQV9V5TkxNFiNnGjq9tRSChdJkQTTeQJ-31Wf2vjD8xon0UAzvpfCYtw7BkHKULSCP_rDMLMC8NqdpIit0AgGZVNTASUL-YgoxnkBDCtCB-Xo0j9UUfN6Ayj5rb9Yu6Go3Oz8qQ-c1RPKPmdGtz_91bDGbdAucHMtxUgtQFp3svyedgeGnZw4lS4zxje9X_7KLkA-QQ3zlpwqF6ijE36I',
      isViewed: true,
    ),
  ];

  final List<Conversation> _conversations = [
    Conversation(
      name: 'Sarah Wilson',
      avatarUrl:
      'https://lh3.googleusercontent.com/aida-public/AB6AXuBXpY7jGdz4MQ8rKVCLxzfYJmrvSEPTFoxHTwj7fzSyg9Jc0YEpP0xnaSF_mftpg5p4HWl8LhY4JWYU10Il38-1L_aEL08ng8wufjEYUvQPcw-ezhq47-ZmFamhl_0Vwtr4M4AXlTj8yIjtlZkelccIR8rxokqyqkEamjpkN3qN0b0RLhXoRTHcZT3do1Ic1A_Kkc1j4F2JjTEzIWFu7benYp3FKEhwQvZYpIPIRcwJS1nFeJzbbjvFouhVGZu6K3yRzU-n3MSImGPc',
      initials: 'SW',
      lastMessage: 'Can we review the final mockups?',
      time: '12:45 PM',
      isUnread: true,
      unreadCount: 2,
      isOnline: true,
    ),
    Conversation(
      name: 'David Chen',
      avatarUrl:
      'https://lh3.googleusercontent.com/aida-public/AB6AXuAZ0nuLL10WjCrIkD8Ft15vz2dJhjr1djziMaXs3am-A8dfgbndu4LijbGJOzA6JUIM_MtwsQJn3ssLLnHEAegWnfVHz3T7VsoRFsV2H42mDgicgHaLzl-QBW8fFkLmX-cNdo1is9TY28NqLBnRyu0MjgahAf1Py8CNA4IJj7nx_0034SlV76r2FKY1n-jy_yxLm6LD3up7aJvRfe-goq6usU0iQK7v2eoMHmc0PKWcSIhImN_r7xHEzgqvrdvw_H9BYUABNQb6LJUE',
      initials: 'DC',
      lastMessage: 'The meeting has been rescheduled.',
      time: 'Yesterday',
      isUnread: false,
      unreadCount: 0,
      isOnline: false,
    ),
    Conversation(
      name: 'Elena Rodriguez',
      avatarUrl:
      'https://lh3.googleusercontent.com/aida-public/AB6AXuC2D7dZmAktZ-PJL3BdtoR96iDUpwitB60aBsjJKLD0nQvYpjUAB2XU-tFLT_Z3mYPBbNrkWV6--qAKqiZhxG6y24Vw3FtYoi2ecEXgiCGipeSJySj-0vXTW0Ow8IjiYSvsVAvB224cF8ZAhDCZQP5a3OuVhlk9j0jAuwWZXNIUmKbUIljHX3CYmSRy3qelstKyoVb8hYdUmpFJMHWV3fCVip_RVYiliNCuAuityfJxVJX7z3OE9E7ShZJAxUEY2igbKna6jjrSCmGn',
      initials: 'ER',
      lastMessage: 'That\'s a great idea, let\'s do it!',
      time: 'Oct 24',
      isUnread: false,
      unreadCount: 0,
      isOnline: false,
    ),
    Conversation(
      name: 'James Dalton',
      avatarUrl: null,
      initials: 'JD',
      lastMessage: 'Sent an attachment',
      time: '11:10 AM',
      isUnread: true,
      unreadCount: 1,
      isOnline: true,
    ),
    Conversation(
      name: 'Marcus Thorne',
      avatarUrl:
      'https://lh3.googleusercontent.com/aida-public/AB6AXuDvPM8NvksW4I165vQd0hsk8kyOUrexAnV253Tdvcq3U96ljjumtDpindDTTgqK2kU9XQYSa-XFovBucXxRU67SCmlG3IbARKqIUJEHMLvemTFWbnnSdyh3j1OjMumjtUMXOaF9uB8Jqnp2lBAWxI5CHK1JMj2QXkreVB3XtlDS2GMP_F2tOm6GL11qeji4syHiCZL_YT6GOwfEOX_7i0gZt65H2PfkovyWMI1nR3p6ovKjTTNYlCJOWXmQ7_UOJsQzR76Ej2y02TbI',
      initials: 'MT',
      lastMessage: 'Check out the new design system update.',
      time: 'Oct 23',
      isUnread: false,
      unreadCount: 0,
      isOnline: false,
    ),
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        // ✅ CustomText → headlineMedium + primary color
        title: CustomText(
          'Connect',
          variant: CustomTextVariant.headlineMedium,
          color: cs.primary,
        ),
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircleAvatar(
            backgroundColor: cs.surfaceContainerHigh,
            backgroundImage: const NetworkImage(
              'https://lh3.googleusercontent.com/aida-public/AB6AXuA7sTemZ2TQQ9MypjPWYx6yLIxT9t4cQ07AcU19VMq18POA2IHvWZwweHABxXWH4KoRXNGKUpVIavrFFnYOlP7D5jNbTVWhC1BTwAekxhiqrzkqiPhAL2u_cafx6uS7AoSk3VHRbgUotXrLWxx4_jCrZWfB9YIL_ChgRzhi6AR_VmhdaMz99_VC4PTNW2uaLU6yGRpY3QtHMtjTSJkS0NCgkHsHo51N0OwsPyb2XzLfUqKQ6N78GHZvy-0RR4RaBGj8k4olkKGp2Mfn',
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.call_outlined),
            onPressed: () {},
            color: cs.primary,
          ),
          IconButton(
            icon: const Icon(Icons.videocam_outlined),
            onPressed: () {},
            color: cs.primary,
          ),
          IconButton(
            icon: const Icon(Icons.search),
            color: cs.primary,
            onPressed: () {},
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: cs.primary,
        child: Icon(Icons.edit, color: cs.onPrimary),
      ),
      body: CustomScrollView(
        slivers: [
          // ── Search Bar via CustomTextFormField ────────────────────────────
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
            sliver: SliverToBoxAdapter(
              child: CustomTextFormField(
                controller: _searchController,
                hintText: 'Search conversations...',
                prefixIcon: Icons.search,
                borderRadius: 999, // pill
                borderWidth: 1,
                contentPadding:
                const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
              ),
            ),
          ),

          // ── Stories ───────────────────────────────────────────────────────
          SliverPadding(
            padding: const EdgeInsets.only(left: 20, right: 8, bottom: 24),
            sliver: SliverToBoxAdapter(
              child: SizedBox(
                height: 88,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: _stories.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 16),
                  itemBuilder: (context, index) {
                    final story = _stories[index];
                    return _StoryItem(story: story);
                  },
                ),
              ),
            ),
          ),

          // ── "Recent Conversations" header ─────────────────────────────────
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            sliver: SliverToBoxAdapter(
              // ✅ CustomText → labelLarge (Inter 13 w600 tracking 0.05) + outline color
              child: CustomText(
                'RECENT CONVERSATIONS',
                variant: CustomTextVariant.labelLarge,
                color: Theme.of(context).colorScheme.outline,
              ),
            ),
          ),
          const SliverPadding(padding: EdgeInsets.only(top: 8)),

          // ── Conversation list ─────────────────────────────────────────────
          SliverList.separated(
            itemCount: _conversations.length,
            separatorBuilder: (_, __) => Padding(
              padding: const EdgeInsets.only(left: 80),
              child: Divider(
                color: cs.outlineVariant,
                thickness: 1,
                height: 1,
              ),
            ),
            itemBuilder: (context, index) =>
                _ChatListItem(chat: _conversations[index]),
          ),

          const SliverPadding(padding: EdgeInsets.only(bottom: 10)),
        ],
      ),
    );
  }
}

// ─── Story Item ───────────────────────────────────────────────────────────────

class _StoryItem extends StatelessWidget {
  final Story story;
  const _StoryItem({required this.story});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Column(
      children: [
        Container(
          width: 64,
          height: 64,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: story.isViewed ? cs.outlineVariant : cs.primary,
              width: 2,
            ),
          ),
          child: story.avatarUrl != null
              ? CircleAvatar(
            backgroundImage: NetworkImage(story.avatarUrl!),
            backgroundColor: cs.surfaceContainerHigh,
          )
              : CircleAvatar(
            backgroundColor: cs.secondaryContainer,
            // ✅ CustomText → titleSmall + onSecondaryContainer
            child: CustomText(
              story.initials,
              variant: CustomTextVariant.titleSmall,
              color: cs.onSecondaryContainer,
            ),
          ),
        ),
        const SizedBox(height: 4),
        // ✅ CustomText → labelMedium (Inter 12 w500)
        //    color: onSurface if unviewed, onSurfaceVariant if viewed
        CustomText(
          story.name,
          variant: CustomTextVariant.labelMedium,
          color: story.isViewed ? cs.onSurfaceVariant : cs.onSurface,
        ),
      ],
    );
  }
}

// ─── Chat List Item ───────────────────────────────────────────────────────────

class _ChatListItem extends StatelessWidget {
  final Conversation chat;
  const _ChatListItem({required this.chat});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Row(
        children: [
          // ── Avatar ────────────────────────────────────────────────────────
          Stack(
            children: [
              SizedBox(
                width: 56,
                height: 80, // ✅ fixed height (was 80/100 — layout crash)
                child: chat.avatarUrl != null
                    ? CircleAvatar(
                  backgroundImage: NetworkImage(chat.avatarUrl!),
                  backgroundColor: cs.surfaceContainerHigh,
                )
                    : CircleAvatar(
                  backgroundColor: cs.secondaryContainer,
                  // ✅ CustomText → titleMedium + onSecondaryContainer
                  child: CustomText(
                    chat.initials,
                    variant: CustomTextVariant.titleMedium,
                    color: cs.onSecondaryContainer,
                  ),
                ),
              ),
              if (chat.isOnline)
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    width: 14,
                    height: 14,
                    decoration: BoxDecoration(
                      color: Colors.green,
                      shape: BoxShape.circle,
                      border: Border.all(color: cs.surface, width: 2),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(width: 16),

          // ── Name / message / time / badge ─────────────────────────────────
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      // ✅ CustomText → titleMedium (PlusJakartaSans 17 w600)
                      //    bold override when unread
                      child: CustomText(
                        chat.name,
                        variant: CustomTextVariant.titleMedium,
                        fontWeight: chat.isUnread
                            ? FontWeight.w700
                            : FontWeight.w600,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 8),
                    // ✅ CustomText → labelMedium (Inter 12)
                    //    primary if unread, onSurfaceVariant if read
                    CustomText(
                      chat.time,
                      variant: CustomTextVariant.labelMedium,
                      fontWeight: chat.isUnread
                          ? FontWeight.w700
                          : FontWeight.w500,
                      color: chat.isUnread ? cs.primary : cs.onSurfaceVariant,
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Expanded(
                      // ✅ CustomText → bodyMedium (Inter 15)
                      //    onSurface+bold if unread, onSurfaceVariant if read
                      child: CustomText(
                        chat.lastMessage,
                        variant: CustomTextVariant.bodyMedium,
                        fontWeight: chat.isUnread
                            ? FontWeight.w600
                            : FontWeight.w400,
                        color: chat.isUnread
                            ? cs.onSurface
                            : cs.onSurfaceVariant,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    // ── Unread badge ─────────────────────────────────────
                    if (chat.unreadCount > 0)
                      Padding(
                        padding: const EdgeInsets.only(left: 8),
                        child: Container(
                          width: 20,
                          height: 20,
                          decoration: BoxDecoration(
                            color: cs.primary,
                            shape: BoxShape.circle,
                          ),
                          alignment: Alignment.center,
                          // ✅ CustomText → labelSmall (Inter 11 w500)
                          child: CustomText(
                            '${chat.unreadCount}',
                            variant: CustomTextVariant.labelSmall,
                            color: cs.onPrimary,
                          ),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}