import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../domain/chat_message.dart';
import 'typing_indicator.dart';

class ChatMessageBubble extends StatelessWidget {
  final ChatMessage message;

  const ChatMessageBubble({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    if (message.role == ChatRole.system) {
      return const SizedBox.shrink();
    }

    final isUser = message.role == ChatRole.user;
    final t = Theme.of(context);
    final isDark = t.brightness == Brightness.dark;
    final time = DateFormat('hh:mm a').format(message.createdAt);
    final isTyping = message.content.trim() == "…";

    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 320),
          child: Container(
            padding: const EdgeInsets.fromLTRB(14, 12, 14, 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(16),
                topRight: const Radius.circular(16),
                bottomLeft: Radius.circular(isUser ? 16 : 4),
                bottomRight: Radius.circular(isUser ? 4 : 16),
              ),

              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: isUser
                    ? isDark
                          ? const [Color(0xFF610094), Color(0xFF3F0071)]
                          : [
                              const Color(0xFF610094),
                              const Color(0xFF3F0071).withValues(alpha: 0.85),
                            ]
                    : isDark
                    ? [
                        Colors.white.withValues(alpha: 0.14),
                        Colors.white.withValues(alpha: 0.06),
                      ]
                    : [Colors.white, Colors.white.withValues(alpha: 0.95)],
              ),

              border: Border.all(
                color: isUser
                    ? Colors.white.withValues(alpha: 0.12)
                    : isDark
                    ? Colors.white.withValues(alpha: 0.18)
                    : Colors.black.withValues(alpha: 0.06),
              ),

              boxShadow: [
                BoxShadow(
                  color: isDark
                      ? Colors.black.withValues(alpha: 0.35)
                      : Colors.black.withValues(alpha: 0.10),
                  blurRadius: 16,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: isUser
                  ? CrossAxisAlignment.end
                  : CrossAxisAlignment.start,
              children: [
                if (isTyping) ...[
                  const TypingIndicator(),
                ] else ...[
                  Text(
                    message.content,
                    style: t.textTheme.bodyLarge?.copyWith(
                      color: isUser
                          ? Colors.white
                          : isDark
                          ? Colors.white.withValues(alpha: 0.95)
                          : Colors.black87,
                      height: 1.4,
                    ),
                  ),
                ],

                const SizedBox(height: 6),

                if (!isTyping)
                  Text(
                    time,
                    style: t.textTheme.labelSmall?.copyWith(
                      color: isUser
                          ? Colors.white.withValues(alpha: 0.65)
                          : isDark
                          ? Colors.white.withValues(alpha: 0.55)
                          : Colors.black.withValues(alpha: 0.45),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
