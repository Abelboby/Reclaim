class ChatMessage {
  final String content;
  final DateTime timestamp;
  final bool isUser;
  final String id;

  ChatMessage({
    required this.content,
    required this.timestamp,
    required this.isUser,
    required this.id,
  });

  Map<String, dynamic> toJson() => {
    'content': content,
    'timestamp': timestamp.toIso8601String(),
    'isUser': isUser,
    'id': id,
  };

  factory ChatMessage.fromJson(Map<String, dynamic> json) => ChatMessage(
    content: json['content'],
    timestamp: DateTime.parse(json['timestamp']),
    isUser: json['isUser'],
    id: json['id'],
  );
} 