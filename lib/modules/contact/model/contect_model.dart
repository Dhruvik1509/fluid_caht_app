class Contact {
  final String name;
  final String status;
  final String? avatarUrl; // null → show initials avatar
  final bool isOnline;
  final bool hasBlueDot; // "Online" indicator on the right

  const Contact({
    required this.name,
    required this.status,
    this.avatarUrl,
    this.isOnline = false,
    this.hasBlueDot = false,
  });
}