import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../config/env.dart';
import '../../../core/network/gemini_dio_provider.dart';
import 'dialogix_chat_service.dart';

final dialogixModelProvider = Provider<String>((ref) => Env.model);

final dialogixChatServiceProvider = Provider<DialogixChatService>((ref) {
  final dio = ref.watch(geminiDioProvider);
  return DialogixChatService(dio);
});
