
class SelectContactModel {
  final String name;
  final String subtitle;
  final String? avatarUrl;
  final String initials;
  final bool isOnline;

  const SelectContactModel({
    required this.name,
    required this.subtitle,
    this.avatarUrl,
    this.initials = '',
    this.isOnline = false,
  });
}