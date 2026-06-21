import 'dart:typed_data';

enum MessageStatus { sending, sent, delivered, read }
enum MessageType { text, image, audio, document }

class Message {
  final String id;
  final String text; // text content, OR caption / file name for media
  final bool isMine;
  final DateTime timestamp;
  MessageStatus status;
  final MessageType type;

  // ── Image ──
  final Uint8List? imageBytes; // local picked image

  // ── Audio ──
  final Uint8List? audioBytes;   // recorded voice note
  final Duration? audioDuration; // voice note length

  // ── Document ──
  final Uint8List? docBytes; // picked document content
  final String? docName;     // file name
  final int? docSizeBytes;   // file size

  Message({
    required this.id,
    required this.text,
    required this.isMine,
    required this.timestamp,
    this.status = MessageStatus.sent,
    this.type = MessageType.text,
    this.imageBytes,
    this.audioBytes,
    this.audioDuration,
    this.docBytes,
    this.docName,
    this.docSizeBytes,
  });
}