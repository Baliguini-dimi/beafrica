// lib/features/chatbot/presentation/screens/chatbot_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_typography.dart';
import '../../providers/chatbot_provider.dart';
import '../widgets/chat_bubble.dart';
import '../widgets/typing_indicator.dart';
import '../widgets/suggestion_chips.dart';

class ChatbotScreen extends ConsumerStatefulWidget {
  const ChatbotScreen({super.key});

  @override
  ConsumerState<ChatbotScreen> createState() => _ChatbotScreenState();
}

class _ChatbotScreenState extends ConsumerState<ChatbotScreen> {
  final _messageController = TextEditingController();
  final _scrollController = ScrollController();

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _send([String? text]) {
    final content = text ?? _messageController.text;
    if (content.trim().isEmpty) return;

    ref.read(chatbotProvider.notifier).sendMessage(content);
    _messageController.clear();
    _scrollToBottom();
  }

  @override
  Widget build(BuildContext context) {
    final chatState = ref.watch(chatbotProvider);

    ref.listen(chatbotProvider, (previous, next) {
      if (next.messages.length != previous?.messages.length) {
        _scrollToBottom();
      }
    });

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
        title: Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: const BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.auto_awesome,
                color: AppColors.textOnPrimary,
                size: 18,
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Text('Ndara IA', style: AppTypography.headlineMedium),
          ],
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(height: 1, color: AppColors.divider),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_outlined),
            tooltip: 'Nouvelle conversation',
            onPressed: () {
              ref.read(chatbotProvider.notifier).newConversation();
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Compteur de messages
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.lg,
              vertical: AppSpacing.xs,
            ),
            color: AppColors.surfaceVariant,
            child: Text(
              '${chatState.messageCount}/10 messages utilisés',
              style: AppTypography.caption,
              textAlign: TextAlign.center,
            ),
          ),

          // Messages
          Expanded(
            child: chatState.messages.isEmpty
                ? SingleChildScrollView(
                    padding: AppSpacing.pagePadding,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: AppSpacing.xl),
                        Center(
                          child: Container(
                            width: 64,
                            height: 64,
                            decoration: BoxDecoration(
                              color: AppColors.primary.withValues(alpha: 0.1),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.auto_awesome,
                              color: AppColors.primary,
                              size: 32,
                            ),
                          ),
                        ),
                        const SizedBox(height: AppSpacing.lg),
                        Center(
                          child: Text(
                            'Barà minguì îta !',
                            style: AppTypography.headlineMedium,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        Center(
                          child: Text(
                            'Je suis Ndara IA, votre guide intelligent\nsur la République Centrafricaine.',
                            style: AppTypography.bodyMedium.copyWith(
                              color: AppColors.textSecondary,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.xxl),
                        SuggestionChips(onTap: _send),
                      ],
                    ),
                  )
                : ListView.builder(
                    controller: _scrollController,
                    padding: AppSpacing.pagePadding,
                    itemCount: chatState.messages.length +
                        (chatState.isTyping ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (index == chatState.messages.length) {
                        return const TypingIndicator();
                      }
                      return ChatBubble(message: chatState.messages[index]);
                    },
                  ),
          ),

          // Erreur
          if (chatState.error != null)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(AppSpacing.md),
              color: AppColors.error.withValues(alpha: 0.08),
              child: Text(
                chatState.error!,
                style: AppTypography.bodySmall.copyWith(
                  color: AppColors.error,
                ),
                textAlign: TextAlign.center,
              ),
            ),

          // Input
          Container(
            padding: const EdgeInsets.all(AppSpacing.lg),
            decoration: const BoxDecoration(
              color: AppColors.surface,
              border: Border(top: BorderSide(color: AppColors.divider)),
            ),
            child: SafeArea(
              top: false,
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _messageController,
                      enabled: !chatState.hasReachedLimit,
                      style: AppTypography.bodyMedium,
                      decoration: InputDecoration(
                        hintText: chatState.hasReachedLimit
                            ? 'Limite de messages atteinte'
                            : 'Écrivez votre message...',
                      ),
                      onSubmitted: (_) => _send(),
                      maxLines: 3,
                      minLines: 1,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  GestureDetector(
                    onTap: chatState.hasReachedLimit ? null : () => _send(),
                    child: Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: chatState.hasReachedLimit
                            ? AppColors.border
                            : AppColors.primary,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.send_rounded,
                        color: chatState.hasReachedLimit
                            ? AppColors.textHint
                            : AppColors.textOnPrimary,
                        size: 20,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
