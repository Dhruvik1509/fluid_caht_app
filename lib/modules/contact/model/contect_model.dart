import 'dart:typed_data';

class Contact {
  final String name;
  final String status;
  final String? avatarUrl;
  final Uint8List? photo;
  final bool isOnline;
  final bool hasBlueDot;

  Contact({
    required this.name,
    required this.status,
    this.avatarUrl,
    this.photo,
    this.isOnline = false,
    this.hasBlueDot = false,
  });
}