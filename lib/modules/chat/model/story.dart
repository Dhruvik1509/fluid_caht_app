class Story {
  final String name;
  final String? avatarUrl;
  final String initials;
  final bool isViewed;

  Story({
    required this.name,
    this.avatarUrl,
    required this.initials,
    this.isViewed = false,
  });
}