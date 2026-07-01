// lib/features/chatbot/providers/chatbot_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../../../models/message_model.dart';
import '../data/groq_repository.dart';

final groqRepositoryProvider = Provider<GroqRepository>((ref) {
  return GroqRepository();
});

class ChatbotState {
  final List<ChatMessageModel> messages;
  final bool isTyping;
  final String? error;
  final int messageCount;

  const ChatbotState({
    this.messages = const [],
    this.isTyping = false,
    this.error,
    this.messageCount = 0,
  });

  ChatbotState copyWith({
    List<ChatMessageModel>? messages,
    bool? isTyping,
    String? error,
    int? messageCount,
  }) {
    return ChatbotState(
      messages: messages ?? this.messages,
      isTyping: isTyping ?? this.isTyping,
      error: error,
      messageCount: messageCount ?? this.messageCount,
    );
  }

  bool get hasReachedLimit => messageCount >= 10;
}

class ChatbotNotifier extends StateNotifier<ChatbotState> {
  final GroqRepository _repository;
  static const _uuid = Uuid();

  ChatbotNotifier(this._repository) : super(const ChatbotState());

  Future<void> sendMessage(String content) async {
    if (content.trim().isEmpty) return;
    if (state.hasReachedLimit) {
      state = state.copyWith(
        error: 'Limite de 10 messages atteinte pour cette session.',
      );
      return;
    }

    final userMessage = ChatMessageModel(
      id: _uuid.v4(),
      content: content.trim(),
      role: MessageRole.user,
      createdAt: DateTime.now(),
    );

    state = state.copyWith(
      messages: [...state.messages, userMessage],
      isTyping: true,
      error: null,
      messageCount: state.messageCount + 1,
    );

    try {
      final history = state.messages.map((m) => m.toGroqFormat()).toList();
      final response = await _repository.sendMessage(history);

      final assistantMessage = ChatMessageModel(
        id: _uuid.v4(),
        content: response,
        role: MessageRole.assistant,
        createdAt: DateTime.now(),
      );

      state = state.copyWith(
        messages: [...state.messages, assistantMessage],
        isTyping: false,
      );
    } catch (e) {
      state = state.copyWith(
        isTyping: false,
        error: e.toString().replaceAll('Exception: ', ''),
      );
    }
  }

  void newConversation() {
    state = const ChatbotState();
  }

  void clearError() {
    state = state.copyWith(error: null);
  }
}

final chatbotProvider = StateNotifierProvider<ChatbotNotifier, ChatbotState>((
  ref,
) {
  return ChatbotNotifier(ref.watch(groqRepositoryProvider));
});
