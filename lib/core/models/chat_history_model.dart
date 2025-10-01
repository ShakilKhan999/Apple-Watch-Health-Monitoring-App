class ChatHistoryModel {
  final String id;
  final String senderInitials;
  final String message;
  final DateTime timestamp;

  ChatHistoryModel({
    required this.id,
    required this.senderInitials,
    required this.message,
    required this.timestamp,
  });
}
