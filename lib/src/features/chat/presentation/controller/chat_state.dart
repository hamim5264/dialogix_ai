import '../../domain/chat_message.dart';

class ChatState {
  final List<ChatMessage> messages;
  final bool isSending;
  final String input;
  final String? error;

  const ChatState({
    required this.messages,
    required this.isSending,
    required this.input,
    required this.error,
  });

  factory ChatState.initial() =>
      const ChatState(messages: [], isSending: false, input: '', error: null);

  ChatState copyWith({
    List<ChatMessage>? messages,
    bool? isSending,
    String? input,
    String? error,
  }) {
    return ChatState(
      messages: messages ?? this.messages,
      isSending: isSending ?? this.isSending,
      input: input ?? this.input,
      error: error,
    );
  }
}
