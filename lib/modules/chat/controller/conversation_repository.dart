// lib/modules/chats/model/conversations_repository.dart
import 'package:flutter/foundation.dart';
import '../model/Conversation.dart';

/// Simple in-memory shared store for conversations.
/// ChatsPage listens to this; SelectContactPage / CreateGroupPage write to it.
class ConversationsRepository {
  ConversationsRepository._();
  static final ConversationsRepository instance = ConversationsRepository._();

  final ValueNotifier<List<Conversation>> conversations =
  ValueNotifier<List<Conversation>>([]);

  /// Seed initial dummy data (call once from ChatsPage if empty)
  void seedIfEmpty(List<Conversation> initial) {
    if (conversations.value.isEmpty) {
      conversations.value = List<Conversation>.from(initial);
    }
  }

  /// Add a new conversation (or move existing one to top if same name)
  void addOrUpdate(Conversation conversation) {
    final list = List<Conversation>.from(conversations.value);
    final index = list.indexWhere((c) => c.name == conversation.name);

    if (index != -1) {
      list.removeAt(index);
    }
    list.insert(0, conversation);
    conversations.value = list;
  }
}