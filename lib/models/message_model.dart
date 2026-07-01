// lib/models/message_model.dart

enum MessageRole { user, assistant }

class ChatMessageModel {
  final String id;
  final String content;
  final MessageRole role;
  final DateTime createdAt;

  const ChatMessageModel({
    required this.id,
    required this.content,
    required this.role,
    required this.createdAt,
  });

  Map<String, String> toGroqFormat() => {
    'role': role == MessageRole.user ? 'user' : 'assistant',
    'content': content,
  };
}
