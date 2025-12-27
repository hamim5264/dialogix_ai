import 'package:flutter/material.dart';
import '../../../../core/theme/glass.dart';

class ChatEmptyState extends StatelessWidget {
  const ChatEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context);
    final isDark = t.brightness == Brightness.dark;

    return Center(
      child: Glass.card(
        context: context,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 22),
        radius: 24,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.auto_awesome_rounded,
              size: 40,
              color: isDark ? Colors.white : Colors.black87,
            ),
            const SizedBox(height: 14),
            Text(
              "Welcome to Dialogix AI",
              style: t.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: isDark ? Colors.white : Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "Ask anything and I’ll help you think, create, and explore.",
              textAlign: TextAlign.center,
              style: t.textTheme.bodyMedium?.copyWith(
                color: isDark
                    ? Colors.white.withValues(alpha: 0.7)
                    : Colors.black.withValues(alpha: 0.6),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
