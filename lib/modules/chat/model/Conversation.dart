import 'dart:typed_data';

class Conversation {
  final String name;
  final String? avatarUrl;
  final String initials;
  final String lastMessage;
  final String time;
  final bool isUnread;
  final int unreadCount;
  final bool isOnline;
  final bool isGroup;          // ← નવું (default false)
  final Uint8List? photo;      // ← નવું (device contact photo, default null)

  Conversation({
    required this.name,
    this.avatarUrl,
    required this.initials,
    required this.lastMessage,
    required this.time,
    this.isUnread = false,
    this.unreadCount = 0,
    this.isOnline = false,
    this.isGroup = false,
    this.photo,
  });
}