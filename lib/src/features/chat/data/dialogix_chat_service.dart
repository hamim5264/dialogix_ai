import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../domain/chat_message.dart';

class DialogixChatService {
  final Dio dio;

  DialogixChatService(this.dio);

  Future<String> sendMessage({
    required String model,
    required List<ChatMessage> messages,
  }) async {
    try {
      final contents = messages
          .where((m) => m.content.trim() != "…")
          .map(
            (m) => {
              "role": m.role == ChatRole.user ? "user" : "model",
              "parts": [
                {"text": m.content},
              ],
            },
          )
          .toList();

      debugPrint("📤 GEMINI REQUEST:");
      debugPrint(contents.toString());

      final res = await dio.post(
        '/models/$model:generateContent',
        data: {"contents": contents},
      );

      debugPrint("📥 GEMINI RESPONSE:");
      debugPrint(res.data.toString());

      final candidates = res.data['candidates'] as List?;
      if (candidates == null || candidates.isEmpty) {
        return "No response from AI.";
      }

      final parts =
          candidates.first['content']['parts'] as List<dynamic>? ?? [];

      return parts.map((p) => p['text'] ?? '').join().trim();
    } on DioException catch (e) {
      debugPrint("❌ DIO ERROR: ${e.response?.statusCode}");
      debugPrint("❌ DIO DATA: ${e.response?.data}");
      rethrow;
    }
  }
}
