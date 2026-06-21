// lib/modules/contact/model/select_contact_model.dart
//
// FIX: 'initials' field/getter add karyu — agar khali field hoy to remove kari
// niche batavela getter prama mukvu. Agar already field chhe to e check karo
// ke contact banavti vakhte initials pass thai chhe ke nahi.

import 'dart:typed_data';

class SelectContactModel {
  final String name;
  final String subtitle;
  final String? avatarUrl;
  final Uint8List? photo;
  final bool isOnline;

  const SelectContactModel({
    required this.name,
    required this.subtitle,
    this.avatarUrl,
    this.photo,
    this.isOnline = false,
  });

  // ✅ FIX: name parthi automatic initials banavay che — kyay manually
  //    pass karva ni jarur nathi, ane null/empty case pan handle thai jay che.
  String get initials {
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.isEmpty || parts.first.isEmpty) return '?';
    if (parts.length == 1) {
      return parts.first.substring(0, 1).toUpperCase();
    }
    final first = parts.first.isNotEmpty ? parts.first[0] : '';
    final last = parts.last.isNotEmpty ? parts.last[0] : '';
    return (first + last).toUpperCase();
  }
}