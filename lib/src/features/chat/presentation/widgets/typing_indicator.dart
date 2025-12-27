import 'package:flutter/material.dart';

class TypingIndicator extends StatefulWidget {
  const TypingIndicator({super.key});

  @override
  State<TypingIndicator> createState() => _TypingIndicatorState();
}

class _TypingIndicatorState extends State<TypingIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _dot(int index, Color color) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (_, _) {
        final t = (_controller.value * 3 - index).clamp(0.0, 1.0);
        return Opacity(
          opacity: 0.3 + (0.7 * t),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 2),
            child: CircleAvatar(radius: 3, backgroundColor: color),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final dotColor = isDark ? Colors.white : const Color(0xFF610094);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [_dot(0, dotColor), _dot(1, dotColor), _dot(2, dotColor)],
    );
  }
}
