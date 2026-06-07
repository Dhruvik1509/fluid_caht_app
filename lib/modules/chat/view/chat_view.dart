// lib/modules/chats/chat_detail_page.dart
//
// Converted from the HTML "Chat Detail / Conversation" screen.
// Uses CustomText (app_text.dart) + CustomTextFormField (app_text_filed.dart).
// All colors from Theme.of(context).colorScheme — light/dark automatic.
// Transactional page — pushed via Navigator (no BottomNav).

import 'package:flutter/material.dart';

import '../../../core/widgets/app_text.dart';
import '../../../core/widgets/app_text_filed.dart';

// ─── Message model ────────────────────────────────────────────────────────────

enum _MsgType { incoming, outgoing, outgoingMedia, systemPill }

class _Message {
  final _MsgType type;
  final String? text;
  final String? time;
  final bool isRead;       // double-tick blue vs grey
  final String? imageUrl;  // outgoingMedia only
  final String? pillText;  // systemPill only

  const _Message({
    required this.type,
    this.text,
    this.time,
    this.isRead = false,
    this.imageUrl,
    this.pillText,
  });
}

// ─── Sample messages ──────────────────────────────────────────────────────────

final List<_Message> _messages = [
  const _Message(
    type: _MsgType.incoming,
    text:
    'Hey! Have you had a chance to review the new design system guidelines yet? I think the minimalist approach really works.',
    time: '10:42 AM',
  ),
  const _Message(
    type: _MsgType.outgoing,
    text:
    'Just finished reading them. The fluid grid model is exactly what we needed for the mobile experience. 🚀',
    time: '10:45 AM',
    isRead: true,
  ),
  const _Message(
    type: _MsgType.outgoingMedia,
    imageUrl: 'https://images.unsplash.com/photo-1558618666-fcd25c85cd64?w=600',
    text: "Here's a preview of the main interface card.",
    time: '10:46 AM',
    isRead: true,
  ),
  const _Message(
    type: _MsgType.incoming,
    text: 'That looks incredible. The tonal layering is spot on!',
    time: '10:48 AM',
  ),
  const _Message(
    type: _MsgType.systemPill,
    pillText: 'Alex joined the secure workspace',
  ),
  const _Message(
    type: _MsgType.outgoing,
    text:
    "I'll start implementing the input pill-shaped fields now. Should be ready for internal review by EOD. Let me know if you need anything else!",
    time: '10:52 AM',
    isRead: false, // sent but not read yet (grey double-tick)
  ),
];

// ─── Main Screen ──────────────────────────────────────────────────────────────

class ChatDetailPage extends StatefulWidget {
  const ChatDetailPage({super.key});

  @override
  State<ChatDetailPage> createState() => _ChatDetailPageState();
}

class _ChatDetailPageState extends State<ChatDetailPage> {
  final TextEditingController _msgController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _msgController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _sendMessage() {
    if (_msgController.text.trim().isEmpty) return;
    // TODO: add to message list / send to backend
    _msgController.clear();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: cs.surface,
      resizeToAvoidBottomInset: true,

      // ── Top App Bar ────────────────────────────────────────────────────────
      appBar: AppBar(
        backgroundColor: cs.surface.withOpacity(0.85),
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 1,
        leadingWidth: 40,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_rounded, color: cs.onSurfaceVariant),
          onPressed: () => Navigator.pop(context),
          padding: EdgeInsets.zero,
        ),
        title: Row(
          children: [
            // Avatar with online dot
            Stack(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundImage:
                  const NetworkImage('https://i.pravatar.cc/150?img=47'),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    width: 11,
                    height: 11,
                    decoration: BoxDecoration(
                      color: Colors.green,
                      shape: BoxShape.circle,
                      border: Border.all(color: cs.surface, width: 2),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ✅ CustomText → headlineMedium + primary
                CustomText(
                  'Connect',
                  variant: CustomTextVariant.headlineMedium,
                  color: cs.primary,
                ),
                // ✅ CustomText → labelMedium + onSurfaceVariant
                Row(
                  children: [
                    Container(
                      width: 6,
                      height: 6,
                      margin: const EdgeInsets.only(right: 4),
                      decoration: const BoxDecoration(
                        color: Colors.green,
                        shape: BoxShape.circle,
                      ),
                    ),
                    CustomText(
                      'Online',
                      variant: CustomTextVariant.labelMedium,
                      color: cs.onSurfaceVariant,
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.call_outlined, color: cs.onSurfaceVariant),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(Icons.videocam_outlined, color: cs.onSurfaceVariant),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(Icons.search_rounded, color: cs.onSurfaceVariant),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(Icons.more_vert_rounded, color: cs.onSurfaceVariant),
            onPressed: () {},
          ),
        ],
      ),

      // ── Body: message list ─────────────────────────────────────────────────
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
              itemCount: _messages.length + 1, // +1 for date pill at top
              itemBuilder: (ctx, i) {
                if (i == 0) return _DatePill(label: 'Today');
                final msg = _messages[i - 1];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: _buildMessage(msg, cs),
                );
              },
            ),
          ),

          // ── Message composer ─────────────────────────────────────────────
          _MessageComposer(
            controller: _msgController,
            onSend: _sendMessage,
            onChanged: (_) => setState(() {}),
          ),
        ],
      ),
    );
  }

  Widget _buildMessage(_Message msg, ColorScheme cs) {
    switch (msg.type) {
      case _MsgType.incoming:
        return _IncomingBubble(msg: msg);
      case _MsgType.outgoing:
        return _OutgoingBubble(msg: msg);
      case _MsgType.outgoingMedia:
        return _OutgoingMediaBubble(msg: msg);
      case _MsgType.systemPill:
        return _SystemPill(text: msg.pillText ?? '');
    }
  }
}

// ─── Date Pill ────────────────────────────────────────────────────────────────

class _DatePill extends StatelessWidget {
  final String label;
  const _DatePill({required this.label});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Center(
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 12),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
        decoration: BoxDecoration(
          color: cs.surfaceContainer,
          borderRadius: BorderRadius.circular(999),
        ),
        // ✅ CustomText → labelMedium + onSurfaceVariant
        child: CustomText(
          label,
          variant: CustomTextVariant.labelMedium,
          color: cs.onSurfaceVariant,
        ),
      ),
    );
  }
}

// ─── System Pill ──────────────────────────────────────────────────────────────

class _SystemPill extends StatelessWidget {
  final String text;
  const _SystemPill({required this.text});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Center(
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 12),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: cs.surfaceContainerLow,
          borderRadius: BorderRadius.circular(999),
          border: Border.all(color: cs.outlineVariant),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.info_outline_rounded, size: 16, color: cs.primary),
            const SizedBox(width: 6),
            // ✅ CustomText → labelMedium + onSurface
            Flexible(
              child: CustomText(
                text,
                variant: CustomTextVariant.labelMedium,
                color: cs.onSurface,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Incoming Bubble ──────────────────────────────────────────────────────────

class _IncomingBubble extends StatelessWidget {
  final _Message msg;
  const _IncomingBubble({required this.msg});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Light: #E9E9EB / Dark: surfaceContainerHigh
    final bubbleBg =
    isDark ? cs.surfaceContainerHigh : const Color(0xFFE9E9EB);
    final bubbleText = isDark ? cs.onSurface : const Color(0xFF1C1C1E);

    return Align(
      alignment: Alignment.centerLeft,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.78,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: bubbleBg,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                  bottomLeft: Radius.circular(4), // "tail"
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              // ✅ CustomText → bodyMedium
              child: CustomText(
                msg.text ?? '',
                variant: CustomTextVariant.bodyMedium,
                color: bubbleText,
              ),
            ),
            if (msg.time != null)
              Padding(
                padding: const EdgeInsets.only(top: 4, left: 4),
                // ✅ CustomText → labelMedium + outline
                child: CustomText(
                  msg.time!,
                  variant: CustomTextVariant.labelMedium,
                  color: cs.outline,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

// ─── Outgoing Bubble ──────────────────────────────────────────────────────────

class _OutgoingBubble extends StatelessWidget {
  final _Message msg;
  const _OutgoingBubble({required this.msg});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Align(
      alignment: Alignment.centerRight,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.78,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: cs.primary,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(4), // "tail"
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              // ✅ CustomText → bodyMedium + onPrimary
              child: CustomText(
                msg.text ?? '',
                variant: CustomTextVariant.bodyMedium,
                color: cs.onPrimary,
              ),
            ),
            if (msg.time != null)
              Padding(
                padding: const EdgeInsets.only(top: 4, right: 4),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // ✅ CustomText → labelMedium + outline
                    CustomText(
                      msg.time!,
                      variant: CustomTextVariant.labelMedium,
                      color: cs.outline,
                    ),
                    const SizedBox(width: 4),
                    // Double tick — blue if read, grey if sent
                    Icon(
                      Icons.done_all_rounded,
                      size: 14,
                      color: msg.isRead ? cs.primary : cs.outline,
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}

// ─── Outgoing Media Bubble ────────────────────────────────────────────────────

class _OutgoingMediaBubble extends StatelessWidget {
  final _Message msg;
  const _OutgoingMediaBubble({required this.msg});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Align(
      alignment: Alignment.centerRight,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.78,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Container(
              decoration: BoxDecoration(
                color: cs.primary,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(4),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              clipBehavior: Clip.hardEdge,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Image
                  if (msg.imageUrl != null)
                    Image.network(
                      msg.imageUrl!,
                      width: 280,
                      height: 160,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        width: 280,
                        height: 160,
                        color: cs.primaryContainer,
                      ),
                    ),
                  // Caption
                  if (msg.text != null)
                    Padding(
                      padding: const EdgeInsets.fromLTRB(14, 8, 14, 10),
                      // ✅ CustomText → bodyMedium + onPrimary
                      child: CustomText(
                        msg.text!,
                        variant: CustomTextVariant.bodyMedium,
                        color: cs.onPrimary,
                      ),
                    ),
                ],
              ),
            ),
            if (msg.time != null)
              Padding(
                padding: const EdgeInsets.only(top: 4, right: 4),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CustomText(
                      msg.time!,
                      variant: CustomTextVariant.labelMedium,
                      color: cs.outline,
                    ),
                    const SizedBox(width: 4),
                    Icon(
                      Icons.done_all_rounded,
                      size: 14,
                      color: msg.isRead ? cs.primary : cs.outline,
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}

// ─── Message Composer ─────────────────────────────────────────────────────────

class _MessageComposer extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onSend;
  final ValueChanged<String> onChanged;

  const _MessageComposer({
    required this.controller,
    required this.onSend,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final hasText = controller.text.trim().isNotEmpty;

    return Container(
      color: cs.surface,
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 16),
      child: Container(
        decoration: BoxDecoration(
          color: cs.surface.withOpacity(0.85),
          borderRadius: BorderRadius.circular(999),
          border: Border.all(color: cs.outlineVariant),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.07),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            // "+" attach button
            IconButton(
              icon: Icon(Icons.add_rounded, color: cs.onSurfaceVariant),
              onPressed: () {},
              padding: const EdgeInsets.all(8),
              constraints: const BoxConstraints(minWidth: 40, minHeight: 40),
            ),

            // ✅ CustomTextFormField — pill composer input
            Expanded(
              child: CustomTextFormField(
                controller: controller,
                hintText: 'Message...',
                onChanged: onChanged,
                maxLines: 4,
                minLines: 1,
                borderRadius: 999,
                borderWidth: 0,
                fillColor: Colors.transparent,
                enabledBorderColor: Colors.transparent,
                focusedBorderColor: Colors.transparent,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 4,
                  vertical: 8,
                ),
              ),
            ),

            // Emoji button
            IconButton(
              icon: Icon(Icons.mood_rounded, color: cs.onSurfaceVariant),
              onPressed: () {},
              padding: const EdgeInsets.all(8),
              constraints: const BoxConstraints(minWidth: 40, minHeight: 40),
            ),

            // Send button
            Padding(
              padding: const EdgeInsets.only(right: 4),
              child: Material(
                color: cs.primary,
                shape: const CircleBorder(),
                child: InkWell(
                  customBorder: const CircleBorder(),
                  onTap: onSend,
                  child: SizedBox(
                    width: 40,
                    height: 40,
                    child: Icon(
                      Icons.send_rounded,
                      size: 20,
                      color: hasText ? cs.onPrimary : cs.onPrimary.withOpacity(0.7),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}