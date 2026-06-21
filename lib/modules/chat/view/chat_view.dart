import 'dart:async';
import 'dart:io';

import 'package:fluid_caht_app/modules/chat/controller/chat_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:fluid_caht_app/core/widgets/app_text.dart';
import 'package:fluid_caht_app/core/widgets/app_text_filed.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:audioplayers/audioplayers.dart' hide PlayerState;
import 'package:audio_waveforms/audio_waveforms.dart';
import '../model/message.dart';

class ChatView extends StatefulWidget {
  final String name;
  final String? avatarUrl;
  final String initials;
  final bool isOnline;

  const ChatView({
    super.key,
    required this.name,
    this.avatarUrl,
    required this.initials,
    required this.isOnline,
  });

  @override
  State<ChatView> createState() => _ChatViewState();
}

class _ChatViewState extends State<ChatView> with TickerProviderStateMixin {
  final TextEditingController _msgController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final FocusNode _textFieldFocusNode = FocusNode();
  final _repo = ChatRepository.instance;
  bool _hasText = false;
  bool _isTyping = false;
  late AnimationController _typingAnimController;

  // ── Emoji picker ──
  bool _showEmojiPicker = false;

  // ── Attachment ──
  final ImagePicker _imagePicker = ImagePicker();

  // ── Voice recording (single engine: audio_waveforms) ──
  late final RecorderController _waveController;
  bool _isRecording = false;
  Duration _recordDuration = Duration.zero;
  Timer? _recordTimer;
  double _dragX = 0;
  late AnimationController _recordPulseController;

  @override
  void initState() {
    super.initState();
    _typingAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    )..repeat(reverse: true);

    _recordPulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..repeat(reverse: true);

    _waveController = RecorderController();

    _msgController.addListener(() {
      final has = _msgController.text.trim().isNotEmpty;
      if (has != _hasText) setState(() => _hasText = has);
    });

    _textFieldFocusNode.addListener(() {
      if (_textFieldFocusNode.hasFocus && _showEmojiPicker) {
        setState(() => _showEmojiPicker = false);
      }
    });

    _repo.forConversation(widget.name).addListener(_onNewMessage);
  }

  void _onNewMessage() {
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
    final msgs = _repo.forConversation(widget.name).value;
    if (msgs.isNotEmpty && msgs.last.isMine) {
      setState(() => _isTyping = true);
      Future.delayed(const Duration(milliseconds: 2500), () {
        if (mounted) setState(() => _isTyping = false);
      });
    }
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  void _sendMessage() {
    final text = _msgController.text.trim();
    if (text.isEmpty) return;

    final msg = Message(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      text: text,
      isMine: true,
      timestamp: DateTime.now(),
      status: MessageStatus.sending,
    );

    _repo.addMessage(widget.name, msg);
    _msgController.clear();

    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
  }

  // ── Emoji ──────────────────────────────────────────────────────────────

  void _toggleEmojiPicker() {
    if (_showEmojiPicker) {
      setState(() => _showEmojiPicker = false);
      _textFieldFocusNode.requestFocus();
    } else {
      _textFieldFocusNode.unfocus();
      Future.delayed(const Duration(milliseconds: 120), () {
        if (mounted) setState(() => _showEmojiPicker = true);
      });
    }
  }

  void _onEmojiSelected(Category? category, Emoji emoji) {
    final text = _msgController.text;
    final selection = _msgController.selection;
    final cursor = selection.start < 0 ? text.length : selection.start;
    final newText = text.replaceRange(cursor, cursor, emoji.emoji);
    _msgController.text = newText;
    _msgController.selection =
        TextSelection.collapsed(offset: cursor + emoji.emoji.length);
  }

  void _onEmojiBackspace() {
    if (_msgController.text.isEmpty) return;
    _msgController.text =
        _msgController.text.substring(0, _msgController.text.length - 1);
  }

  // ── Attachment ─────────────────────────────────────────────────────────

  void _showAttachmentSheet() {
    final cs = Theme.of(context).colorScheme;
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return Container(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
          decoration: BoxDecoration(
            color: cs.surface,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: cs.outlineVariant,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _AttachOption(
                    icon: Icons.photo_camera_rounded,
                    label: 'Camera',
                    color: Colors.pink,
                    onTap: () {
                      Navigator.pop(ctx);
                      _pickImage(ImageSource.camera);
                    },
                  ),
                  _AttachOption(
                    icon: Icons.photo_rounded,
                    label: 'Gallery',
                    color: Colors.purple,
                    onTap: () {
                      Navigator.pop(ctx);
                      _pickImage(ImageSource.gallery);
                    },
                  ),
                  _AttachOption(
                    icon: Icons.insert_drive_file_rounded,
                    label: 'Document',
                    color: Colors.indigo,
                    onTap: () {
                      Navigator.pop(ctx);
                      _pickDocument();
                    },
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    final XFile? picked =
    await _imagePicker.pickImage(source: source, imageQuality: 80);
    if (picked == null) return;
    final bytes = await picked.readAsBytes();

    final msg = Message(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      text: '',
      isMine: true,
      timestamp: DateTime.now(),
      status: MessageStatus.sending,
      type: MessageType.image,
      imageBytes: bytes,
    );
    _repo.addMessage(widget.name, msg);
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
  }

  Future<void> _pickDocument() async {
    final result = await FilePicker.pickFiles(
      type: FileType.any,
      withData: true,
    );
    if (result == null || result.files.single.bytes == null) return;
    final file = result.files.single;

    final msg = Message(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      text: file.name,
      isMine: true,
      timestamp: DateTime.now(),
      status: MessageStatus.sending,
      type: MessageType.document,
      docBytes: file.bytes,
      docName: file.name,
      docSizeBytes: file.size,
    );
    _repo.addMessage(widget.name, msg);
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
  }

  // ── Voice recording ────────────────────────────────────────────────────

  Future<void> _startRecording() async {
    final hasPermission = await _waveController.checkPermission();
    if (!hasPermission) return;

    final dir = await getTemporaryDirectory();
    final path =
        '${dir.path}/voice_${DateTime.now().millisecondsSinceEpoch}.m4a';

    _waveController.reset();
    await _waveController.record(path: path);

    setState(() {
      _isRecording = true;
      _recordDuration = Duration.zero;
      _dragX = 0;
    });

    HapticFeedback.mediumImpact();

    _recordTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() => _recordDuration += const Duration(seconds: 1));
    });
  }

  Future<void> _finishRecording({required bool send}) async {
    if (!_isRecording) return;
    _recordTimer?.cancel();

    final path = await _waveController.stop();

    if (!mounted) return;
    final duration = _recordDuration;
    setState(() => _isRecording = false);

    if (path == null) return; // recording fail thai gaytu hoy
    final tempFile = File(path);

    if (!send || duration.inMilliseconds < 600) {
      if (await tempFile.exists()) await tempFile.delete();
      return;
    }

    final bytes = await tempFile.readAsBytes();
    if (await tempFile.exists()) await tempFile.delete();

    final msg = Message(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      text: '',
      isMine: true,
      timestamp: DateTime.now(),
      status: MessageStatus.sending,
      type: MessageType.audio,
      audioBytes: bytes,
      audioDuration: duration,
    );
    _repo.addMessage(widget.name, msg);
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
  }

  String get _formattedRecordDuration {
    final mm = _recordDuration.inMinutes.toString().padLeft(2, '0');
    final ss = (_recordDuration.inSeconds % 60).toString().padLeft(2, '0');
    return '$mm:$ss';
  }

  @override
  void dispose() {
    _repo.forConversation(widget.name).removeListener(_onNewMessage);
    _msgController.dispose();
    _scrollController.dispose();
    _textFieldFocusNode.dispose();
    _typingAnimController.dispose();
    _recordPulseController.dispose();
    _waveController.dispose();
    _recordTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        leading: BackButton(color: cs.primary),
        title: Row(
          children: [
            widget.avatarUrl != null
                ? CircleAvatar(
              radius: 20,
              backgroundImage: NetworkImage(widget.avatarUrl!),
              backgroundColor: cs.surfaceContainerHigh,
            )
                : CircleAvatar(
              radius: 20,
              backgroundColor: cs.secondaryContainer,
              child: CustomText(
                widget.initials,
                variant: CustomTextVariant.labelLarge,
                color: cs.onSecondaryContainer,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomText(
                    widget.name,
                    variant: CustomTextVariant.titleMedium,
                    fontWeight: FontWeight.w600,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  CustomText(
                    widget.isOnline ? 'Online' : 'Last seen recently',
                    variant: CustomTextVariant.labelSmall,
                    color: widget.isOnline ? Colors.green : cs.onSurfaceVariant,
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          IconButton(icon: Icon(Icons.call_outlined, color: cs.primary), onPressed: () {}),
          IconButton(icon: Icon(Icons.videocam_outlined, color: cs.primary), onPressed: () {}),
          IconButton(icon: Icon(Icons.more_vert, color: cs.primary), onPressed: () {}),
        ],
      ),
      body: Column(
        children: [
          // ── Message List ──────────────────────────────────────────────
          Expanded(
            child: ValueListenableBuilder<List<Message>>(
              valueListenable: _repo.forConversation(widget.name),
              builder: (context, messages, _) {
                final grouped = _groupByDate(messages);

                return ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  itemCount: grouped.length + (_isTyping ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (_isTyping && index == grouped.length) {
                      return _TypingBubble(
                        initials: widget.initials,
                        avatarUrl: widget.avatarUrl,
                        animController: _typingAnimController,
                      );
                    }

                    final item = grouped[index];
                    if (item is String) {
                      return _DateSeparator(label: item);
                    }
                    final msg = item as Message;
                    final showAvatar = !msg.isMine &&
                        (index == grouped.length - 1 ||
                            (index + 1 < grouped.length &&
                                grouped[index + 1] is Message &&
                                (grouped[index + 1] as Message).isMine));

                    return _MessageBubble(
                      message: msg,
                      showAvatar: showAvatar,
                      initials: widget.initials,
                      avatarUrl: widget.avatarUrl,
                    );
                  },
                );
              },
            ),
          ),

          // ── Input bar (single persistent widget — recording UI bhi ahi j) ──
          _buildInputBar(cs),

          // ── Emoji panel ──────────────────────────────────────────────
          if (_showEmojiPicker)
            SizedBox(
              height: 280,
              child: EmojiPicker(
                onEmojiSelected: _onEmojiSelected,
                onBackspacePressed: _onEmojiBackspace,
                config: Config(
                  height: 280,
                  emojiViewConfig: EmojiViewConfig(
                    columns: 8,
                    emojiSizeMax: 28,
                    backgroundColor: cs.surface,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  // ── Input bar (mic/send button hammesha mounted rahe che — gesture loss nahi) ──

  Widget _buildInputBar(ColorScheme cs) {
    return Container(
      color: cs.surface,
      padding: EdgeInsets.only(
        left: 4,
        right: 8,
        top: 8,
        bottom: MediaQuery.of(context).viewInsets.bottom > 0
            ? 8
            : 8 + MediaQuery.of(context).padding.bottom,
      ),
      child: Row(
        children: [
          if (!_isRecording)
            IconButton(
              icon: Icon(
                _showEmojiPicker ? Icons.keyboard_alt_outlined : Icons.emoji_emotions_outlined,
                color: cs.onSurfaceVariant,
              ),
              onPressed: _toggleEmojiPicker,
            ),
          Expanded(
            child: _isRecording ? _buildRecordingContent(cs) : _buildTextField(cs),
          ),
          if (!_isRecording && !_hasText)
            IconButton(
              icon: Icon(Icons.attach_file_rounded, color: cs.onSurfaceVariant),
              onPressed: _showAttachmentSheet,
            ),
          if (_hasText && !_isRecording)
            IconButton(
              key: const ValueKey('send-text'),
              icon: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(color: cs.primary, shape: BoxShape.circle),
                child: Icon(Icons.send_rounded, color: cs.onPrimary, size: 18),
              ),
              onPressed: _sendMessage,
            )
          else
            _buildMicSendButton(cs),
        ],
      ),
    );
  }

  Widget _buildTextField(ColorScheme cs) {
    return CustomTextFormField(
      controller: _msgController,
      focusNode: _textFieldFocusNode,
      hintText: 'Message...',
      borderRadius: 999,
      borderWidth: 1,
      contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      onChanged: (_) {},
    );
  }

  Widget _buildRecordingContent(ColorScheme cs) {
    return Transform.translate(
      offset: Offset(_dragX, 0),
      child: Row(
        children: [
          AnimatedBuilder(
            animation: _recordPulseController,
            builder: (_, __) => Opacity(
              opacity: 0.4 + 0.6 * _recordPulseController.value,
              child: const Icon(Icons.fiber_manual_record, color: Colors.redAccent, size: 14),
            ),
          ),
          const SizedBox(width: 8),
          CustomText(
            _formattedRecordDuration,
            variant: CustomTextVariant.bodyMedium,
            fontWeight: FontWeight.w600,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Container(
              height: 36,
              padding: const EdgeInsets.symmetric(horizontal: 8),
              decoration: BoxDecoration(
                color: cs.surfaceContainerHigh,
                borderRadius: BorderRadius.circular(20),
              ),
              child: AudioWaveforms(
                enableGesture: false,
                size: const Size(double.infinity, 32),
                recorderController: _waveController,
                waveStyle: WaveStyle(
                  waveColor: cs.primary,
                  extendWaveform: true,
                  showMiddleLine: false,
                  waveCap: StrokeCap.round,
                  spacing: 4,
                  waveThickness: 2.5,
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Icon(Icons.keyboard_arrow_left_rounded, color: cs.onSurfaceVariant, size: 18),
          CustomText('Cancel', variant: CustomTextVariant.labelSmall, color: cs.onSurfaceVariant),
        ],
      ),
    );
  }

  Widget _buildMicSendButton(ColorScheme cs) {
    return GestureDetector(
      onLongPressStart: _isRecording ? null : (_) => _startRecording(),
      onLongPressMoveUpdate: (details) {
        if (!_isRecording) return;
        setState(() {
          _dragX = details.offsetFromOrigin.dx.clamp(-160, 0);
        });
        if (_dragX <= -120) {
          _finishRecording(send: false);
        }
      },
      onLongPressEnd: (_) {
        if (_isRecording) _finishRecording(send: true);
      },
      onLongPressCancel: () {
        if (_isRecording) _finishRecording(send: false);
      },
      onTap: _isRecording ? () => _finishRecording(send: true) : null,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: _isRecording
            ? BoxDecoration(color: cs.primary, shape: BoxShape.circle)
            : null,
        child: Icon(
          _isRecording ? Icons.send_rounded : Icons.mic_none_rounded,
          color: _isRecording ? cs.onPrimary : cs.onSurfaceVariant,
          size: _isRecording ? 18 : 24,
        ),
      ),
    );
  }

  List<dynamic> _groupByDate(List<Message> messages) {
    final result = <dynamic>[];
    String? lastDate;
    for (final msg in messages) {
      final label = _dateLabel(msg.timestamp);
      if (label != lastDate) {
        result.add(label);
        lastDate = label;
      }
      result.add(msg);
    }
    return result;
  }

  String _dateLabel(DateTime dt) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final msgDay = DateTime(dt.year, dt.month, dt.day);
    final diff = today.difference(msgDay).inDays;
    if (diff == 0) return 'Today';
    if (diff == 1) return 'Yesterday';
    return DateFormat('MMMM d, yyyy').format(dt);
  }
}

// ─── Attach Option ──────────────────────────────────────────────────────────

class _AttachOption extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _AttachOption({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(color: color.withOpacity(0.15), shape: BoxShape.circle),
            child: Icon(icon, color: color, size: 26),
          ),
          const SizedBox(height: 8),
          CustomText(label, variant: CustomTextVariant.labelSmall),
        ],
      ),
    );
  }
}

// ─── Date Separator ───────────────────────────────────────────────────────────

class _DateSeparator extends StatelessWidget {
  final String label;
  const _DateSeparator({required this.label});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(children: [
        Expanded(child: Divider(color: cs.outlineVariant)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: CustomText(
            label,
            variant: CustomTextVariant.labelSmall,
            color: cs.onSurfaceVariant,
          ),
        ),
        Expanded(child: Divider(color: cs.outlineVariant)),
      ]),
    );
  }
}

// ─── Message Bubble ───────────────────────────────────────────────────────────

class _MessageBubble extends StatelessWidget {
  final Message message;
  final bool showAvatar;
  final String initials;
  final String? avatarUrl;

  const _MessageBubble({
    required this.message,
    required this.showAvatar,
    required this.initials,
    this.avatarUrl,
  });

  Widget _buildContent(BuildContext context, ColorScheme cs, bool isMine) {
    switch (message.type) {
      case MessageType.image:
        return ClipRRect(
          borderRadius: BorderRadius.circular(14),
          child: Image.memory(
            message.imageBytes!,
            width: 200,
            fit: BoxFit.cover,
          ),
        );
      case MessageType.audio:
        return _VoiceMessagePlayer(message: message, isMine: isMine);
      case MessageType.document:
        return _DocumentBubble(message: message, isMine: isMine);
      case MessageType.text:
        return Text(
          message.text,
          style: TextStyle(
            color: isMine ? cs.onPrimary : cs.onSurface,
            fontSize: 14.5,
            height: 1.4,
          ),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isMine = message.isMine;

    return Padding(
      padding: EdgeInsets.only(
        top: 2,
        bottom: 2,
        left: isMine ? 60 : 0,
        right: isMine ? 0 : 60,
      ),
      child: Row(
        mainAxisAlignment: isMine ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!isMine) ...[
            SizedBox(
              width: 28,
              child: showAvatar
                  ? (avatarUrl != null
                  ? CircleAvatar(radius: 14, backgroundImage: NetworkImage(avatarUrl!))
                  : CircleAvatar(
                radius: 14,
                backgroundColor: cs.secondaryContainer,
                child: CustomText(
                  initials.substring(0, 1),
                  variant: CustomTextVariant.labelSmall,
                  color: cs.onSecondaryContainer,
                ),
              ))
                  : const SizedBox(),
            ),
            const SizedBox(width: 6),
          ],
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: isMine ? cs.primary : cs.surfaceContainerHigh,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(18),
                  topRight: const Radius.circular(18),
                  bottomLeft: Radius.circular(isMine ? 18 : 4),
                  bottomRight: Radius.circular(isMine ? 4 : 18),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  _buildContent(context, cs, isMine),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        DateFormat('h:mm a').format(message.timestamp),
                        style: TextStyle(
                          fontSize: 10,
                          color: isMine ? cs.onPrimary.withOpacity(0.7) : cs.onSurfaceVariant,
                        ),
                      ),
                      if (isMine) ...[
                        const SizedBox(width: 4),
                        _StatusIcon(status: message.status, cs: cs),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Voice Message Player ───────────────────────────────────────────────────

class _VoiceMessagePlayer extends StatefulWidget {
  final Message message;
  final bool isMine;
  const _VoiceMessagePlayer({required this.message, required this.isMine});

  @override
  State<_VoiceMessagePlayer> createState() => _VoiceMessagePlayerState();
}

class _VoiceMessagePlayerState extends State<_VoiceMessagePlayer> {
  final AudioPlayer _player = AudioPlayer();
  bool _isPlaying = false;
  Duration _position = Duration.zero;
  late Duration _total;

  @override
  void initState() {
    super.initState();
    _total = widget.message.audioDuration ?? Duration.zero;
    _player.onPlayerStateChanged.listen((state) {
      if (mounted) setState(() => _isPlaying = state == PlayerState.playing);
    });
    _player.onPositionChanged.listen((pos) {
      if (mounted) setState(() => _position = pos);
    });
    _player.onPlayerComplete.listen((_) {
      if (mounted) {
        setState(() {
          _isPlaying = false;
          _position = Duration.zero;
        });
      }
    });
  }

  Future<void> _toggle() async {
    if (_isPlaying) {
      await _player.pause();
    } else {
      await _player.play(BytesSource(widget.message.audioBytes!));
    }
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final fg = widget.isMine ? cs.onPrimary : cs.onSurface;
    final total = _total.inMilliseconds == 0 ? const Duration(seconds: 1) : _total;
    final progress = (_position.inMilliseconds / total.inMilliseconds).clamp(0.0, 1.0);
    final remaining = (_isPlaying || _position > Duration.zero) ? _position : _total;
    final mm = remaining.inMinutes.toString().padLeft(2, '0');
    final ss = (remaining.inSeconds % 60).toString().padLeft(2, '0');

    return SizedBox(
      width: 190,
      child: Row(
        children: [
          GestureDetector(
            onTap: _toggle,
            child: Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(color: fg.withOpacity(0.15), shape: BoxShape.circle),
              child: Icon(_isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded, color: fg, size: 20),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: progress,
                minHeight: 3,
                backgroundColor: fg.withOpacity(0.2),
                valueColor: AlwaysStoppedAnimation(fg),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Text('$mm:$ss', style: TextStyle(color: fg, fontSize: 11)),
        ],
      ),
    );
  }
}

// ─── Document Bubble ─────────────────────────────────────────────────────────

class _DocumentBubble extends StatelessWidget {
  final Message message;
  final bool isMine;
  const _DocumentBubble({required this.message, required this.isMine});

  String _sizeLabel(int? bytes) {
    if (bytes == null) return '';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(0)} KB';
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final fg = isMine ? cs.onPrimary : cs.onSurface;
    return SizedBox(
      width: 200,
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(color: fg.withOpacity(0.15), borderRadius: BorderRadius.circular(8)),
            child: Icon(Icons.description_rounded, color: fg, size: 20),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  message.docName ?? message.text,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: fg, fontSize: 13, fontWeight: FontWeight.w600),
                ),
                Text(
                  _sizeLabel(message.docSizeBytes),
                  style: TextStyle(color: fg.withOpacity(0.7), fontSize: 11),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Read Receipt Icon ────────────────────────────────────────────────────────

class _StatusIcon extends StatelessWidget {
  final MessageStatus status;
  final ColorScheme cs;
  const _StatusIcon({required this.status, required this.cs});

  @override
  Widget build(BuildContext context) {
    switch (status) {
      case MessageStatus.sending:
        return Icon(Icons.access_time, size: 12, color: cs.onPrimary.withOpacity(0.7));
      case MessageStatus.sent:
        return Icon(Icons.check, size: 12, color: cs.onPrimary.withOpacity(0.7));
      case MessageStatus.delivered:
        return Icon(Icons.done_all, size: 12, color: cs.onPrimary.withOpacity(0.7));
      case MessageStatus.read:
        return Icon(Icons.done_all, size: 12, color: Colors.lightBlueAccent);
    }
  }
}

// ─── Typing Bubble ────────────────────────────────────────────────────────────

class _TypingBubble extends StatelessWidget {
  final String initials;
  final String? avatarUrl;
  final AnimationController animController;
  const _TypingBubble({required this.initials, this.avatarUrl, required this.animController});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.only(top: 4, bottom: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          avatarUrl != null
              ? CircleAvatar(radius: 14, backgroundImage: NetworkImage(avatarUrl!))
              : CircleAvatar(
            radius: 14,
            backgroundColor: cs.secondaryContainer,
            child: CustomText(
              initials.substring(0, 1),
              variant: CustomTextVariant.labelSmall,
              color: cs.onSecondaryContainer,
            ),
          ),
          const SizedBox(width: 6),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: cs.surfaceContainerHigh,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(18),
                topRight: Radius.circular(18),
                bottomLeft: Radius.circular(4),
                bottomRight: Radius.circular(18),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: List.generate(3, (i) => _Dot(index: i, controller: animController, cs: cs)),
            ),
          ),
        ],
      ),
    );
  }
}

class _Dot extends StatelessWidget {
  final int index;
  final AnimationController controller;
  final ColorScheme cs;
  const _Dot({required this.index, required this.controller, required this.cs});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (_, __) {
        final offset = (controller.value + index * 0.33) % 1.0;
        final opacity = 0.3 + 0.7 * (offset < 0.5 ? offset * 2 : (1 - offset) * 2);
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 2),
          child: Opacity(
            opacity: opacity,
            child: Container(
              width: 7,
              height: 7,
              decoration: BoxDecoration(
                color: cs.onSurfaceVariant,
                shape: BoxShape.circle,
              ),
            ),
          ),
        );
      },
    );
  }
}