import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/glass.dart';
import '../domain/chat_message.dart';
import 'controller/chat_controller.dart';
import 'widgets/chat_app_bar.dart';
import 'widgets/chat_input_bar.dart';
import 'widgets/chat_message_bubble.dart';
import 'widgets/chat_empty_state.dart';

class ChatScreen extends ConsumerWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(chatControllerProvider);
    final textController = TextEditingController();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final hasUserMessage = state.messages.any((m) => m.role == ChatRole.user);

    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: isDark
                    ? [
                        AppColors.black,
                        AppColors.deepIndigo.withValues(alpha: 0.95),
                        AppColors.royalPurple.withValues(alpha: 0.95),
                      ]
                    : [
                        const Color(0xFFF4EEFA),
                        const Color(0xFFE8DAF5),
                        const Color(0xFFD8C2F0),
                      ],
              ),
            ),
          ),

          SafeArea(
            child: Column(
              children: [
                const ChatAppBar(),

                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(14, 8, 14, 12),
                    child: Glass.card(
                      context: context,
                      padding: const EdgeInsets.fromLTRB(12, 12, 12, 10),
                      radius: 22,
                      child: Column(
                        children: [
                          if (state.error != null) ...[
                            _ErrorBanner(text: state.error!),
                            const SizedBox(height: 10),
                          ],

                          Expanded(
                            child: !hasUserMessage
                                ? const ChatEmptyState()
                                : ListView.builder(
                                    reverse: true,
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 6,
                                    ),
                                    physics: const BouncingScrollPhysics(),
                                    itemCount: state.messages.length,
                                    itemBuilder: (_, i) {
                                      final msg =
                                          state.messages[state.messages.length -
                                              1 -
                                              i];
                                      return ChatMessageBubble(message: msg);
                                    },
                                  ),
                          ),

                          const SizedBox(height: 8),

                          ChatInputBar(
                            controller: textController,
                            isSending: state.isSending,
                            onSend: () {
                              ref
                                  .read(chatControllerProvider.notifier)
                                  .setInput(textController.text);
                              ref.read(chatControllerProvider.notifier).send();
                              textController.clear();
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ErrorBanner extends StatelessWidget {
  final String text;

  const _ErrorBanner({required this.text});

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context);
    final isDark = t.brightness == Brightness.dark;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        color: AppColors.danger.withValues(alpha: isDark ? 0.14 : 0.10),
        border: Border.all(color: AppColors.danger.withValues(alpha: 0.30)),
      ),
      child: Text(
        text,
        style: t.textTheme.bodyMedium?.copyWith(
          color: isDark ? Colors.white : Colors.black87,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
