enum ChatRole { user, assistant, system }

class ChatMessage {
  final String id;
  final ChatRole role;
  final String content;
  final DateTime createdAt;

  const ChatMessage({
    required this.id,
    required this.role,
    required this.content,
    required this.createdAt,
  });

  Map<String, dynamic> toApi() {
    return {
      "role": switch (role) {
        ChatRole.user => "user",
        ChatRole.assistant => "assistant",
        ChatRole.system => "system",
      },
      "content": content,
    };
  }

  ChatMessage copyWith({String? content}) {
    return ChatMessage(
      id: id,
      role: role,
      content: content ?? this.content,
      createdAt: createdAt,
    );
  }
}
