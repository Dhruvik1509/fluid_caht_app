class Conversation {
  final String name;
  final String? avatarUrl;
  final String initials;
  final String lastMessage;
  final String time;
  final bool isUnread;
  final int unreadCount;
  final bool isOnline;

  Conversation({
    required this.name,
    this.avatarUrl,
    required this.initials,
    required this.lastMessage,
    required this.time,
    this.isUnread = false,
    this.unreadCount = 0,
    this.isOnline = false,
  });
}