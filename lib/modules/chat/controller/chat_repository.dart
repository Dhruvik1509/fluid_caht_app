import 'package:flutter/foundation.dart';
import '../model/message.dart';

/// Per-conversation in-memory message store.
class ChatRepository {
  ChatRepository._();
  static final ChatRepository instance = ChatRepository._();

  // conversationName → messages
  final Map<String, ValueNotifier<List<Message>>> _store = {};

  ValueNotifier<List<Message>> forConversation(String name) {
    _store.putIfAbsent(name, () {
      // seed a few dummy messages
      return ValueNotifier(_dummyMessages(name));
    });
    return _store[name]!;
  }

  void addMessage(String conversationName, Message message) {
    final notifier = forConversation(conversationName);
    notifier.value = [...notifier.value, message];

    // Simulate delivery + read after short delays
    if (message.isMine) {
      Future.delayed(const Duration(milliseconds: 800), () {
        _updateLastStatus(conversationName, message.id, MessageStatus.delivered);
      });
      Future.delayed(const Duration(milliseconds: 1800), () {
        _updateLastStatus(conversationName, message.id, MessageStatus.read);
      });

      // Simulate a reply after 2.5 seconds
      Future.delayed(const Duration(milliseconds: 2500), () {
        final replies = [
          'Okay, samji gayo! 👍',
          'Sure, hu confirm karesh.',
          'Kal baat kariye?',
          'Bilkul, no problem!',
          'Thanks for letting me know 😊',
          'Got it! Will check and reply.',
        ];
        final reply = Message(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          text: replies[DateTime.now().second % replies.length],
          isMine: false,
          timestamp: DateTime.now(),
          status: MessageStatus.read,
        );
        addMessage(conversationName, reply);
      });
    }
  }

  void _updateLastStatus(String name, String id, MessageStatus status) {
    final notifier = _store[name];
    if (notifier == null) return;
    notifier.value = notifier.value.map((m) {
      if (m.id == id) m.status = status;
      return m;
    }).toList();
    // trigger rebuild
    notifier.notifyListeners();
  }

  List<Message> _dummyMessages(String name) {
    final now = DateTime.now();
    return [
      Message(
        id: '1',
        text: 'Hey! Kem cho? 👋',
        isMine: false,
        timestamp: now.subtract(const Duration(minutes: 30)),
        status: MessageStatus.read,
      ),
      Message(
        id: '2',
        text: 'Maja ma! Tame kevo cho?',
        isMine: true,
        timestamp: now.subtract(const Duration(minutes: 29)),
        status: MessageStatus.read,
      ),
      Message(
        id: '3',
        text: 'Badhu saru chhe. Aaj meeting hati ne?',
        isMine: false,
        timestamp: now.subtract(const Duration(minutes: 20)),
        status: MessageStatus.read,
      ),
      Message(
        id: '4',
        text: 'Ha, meeting sari rahi. Navu project confirm thyu!',
        isMine: true,
        timestamp: now.subtract(const Duration(minutes: 18)),
        status: MessageStatus.read,
      ),
      Message(
        id: '5',
        text: 'Waah! Congratulations 🎉 Details share karjo.',
        isMine: false,
        timestamp: now.subtract(const Duration(minutes: 5)),
        status: MessageStatus.read,
      ),
    ];
  }
}