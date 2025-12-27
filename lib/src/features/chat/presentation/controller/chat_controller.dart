import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/chat_providers.dart';
import '../../domain/chat_message.dart';
import 'chat_state.dart';

final chatControllerProvider = NotifierProvider<ChatController, ChatState>(
  ChatController.new,
);

class ChatController extends Notifier<ChatState> {
  @override
  ChatState build() {
    final systemPrompt = ChatMessage(
      id: "sys-1",
      role: ChatRole.user,
      content:
          "You are Dialogix AI — a helpful, concise assistant. Answer clearly and politely.",
      createdAt: DateTime.now(),
    );

    debugPrint("🟢 ChatController initialized with system prompt");

    return ChatState.initial().copyWith(messages: [systemPrompt]);
  }

  void setInput(String v) {
    state = state.copyWith(input: v, error: null);
  }

  Future<void> send() async {
    final text = state.input.trim();
    if (text.isEmpty || state.isSending) {
      debugPrint("⚠️ Send blocked (empty input or already sending)");
      return;
    }

    final model = ref.read(dialogixModelProvider);
    final service = ref.read(dialogixChatServiceProvider);

    debugPrint("➡️ Sending message to Gemini");
    debugPrint("🧠 Model: $model");
    debugPrint("💬 User input: $text");

    final userMsg = ChatMessage(
      id: "u-${DateTime.now().microsecondsSinceEpoch}",
      role: ChatRole.user,
      content: text,
      createdAt: DateTime.now(),
    );

    state = state.copyWith(
      input: '',
      isSending: true,
      messages: [...state.messages, userMsg],
      error: null,
    );

    final placeholder = ChatMessage(
      id: "a-${DateTime.now().microsecondsSinceEpoch}",
      role: ChatRole.assistant,
      content: "…",
      createdAt: DateTime.now(),
    );

    state = state.copyWith(messages: [...state.messages, placeholder]);

    try {
      final context = state.messages.takeLast(16);

      debugPrint("📤 Messages sent to Gemini:");
      for (final m in context) {
        debugPrint("   - ${m.role.name}: ${m.content}");
      }

      final reply = await service.sendMessage(model: model, messages: context);

      debugPrint("📥 Gemini reply received:");
      debugPrint(reply);

      final updated = [...state.messages];
      final idx = updated.indexWhere((m) => m.id == placeholder.id);
      if (idx != -1) {
        updated[idx] = updated[idx].copyWith(content: reply);
      }

      state = state.copyWith(messages: updated, isSending: false, error: null);
    } catch (e, stack) {
      debugPrint("❌ ERROR while calling Gemini");
      debugPrint("❌ Error: $e");
      debugPrint("📌 StackTrace:\n$stack");

      final updated = [...state.messages]
        ..removeWhere((m) => m.id == placeholder.id);

      state = state.copyWith(
        messages: updated,
        isSending: false,
        error: "Failed to get response. Check API key / internet.",
      );
    }
  }
}

/// 🔹 Helper extension to safely keep last N messages
extension _TakeLast<T> on List<T> {
  List<T> takeLast(int n) {
    if (length <= n) return this;
    return sublist(length - n);
  }
}
