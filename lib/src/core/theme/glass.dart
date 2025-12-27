import 'dart:ui';
import 'package:flutter/material.dart';

class Glass {
  static Widget card({
    required BuildContext context,
    required Widget child,
    EdgeInsets padding = const EdgeInsets.all(14),
    double radius = 18,
  }) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: isDark ? 20 : 14,
          sigmaY: isDark ? 20 : 14,
        ),
        child: Container(
          padding: padding,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(radius),

            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: isDark
                  ? [
                      const Color(0xFF3F0071).withValues(alpha: 0.40),
                      const Color(0xFF150050).withValues(alpha: 0.28),
                    ]
                  : [
                      Colors.white.withValues(alpha: 0.75),
                      const Color(0xFF610094).withValues(alpha: 0.10),
                    ],
            ),

            // 🧱 Subtle glass border
            border: Border.all(
              width: 1,
              color: isDark
                  ? Colors.white.withValues(alpha: 0.14)
                  : Colors.black.withValues(alpha: 0.06),
            ),

            boxShadow: [
              BoxShadow(
                color: isDark
                    ? Colors.black.withValues(alpha: 0.35)
                    : Colors.black.withValues(alpha: 0.08),
                blurRadius: 24,
                offset: const Offset(0, 12),
              ),
            ],
          ),
          child: child,
        ),
      ),
    );
  }
}
