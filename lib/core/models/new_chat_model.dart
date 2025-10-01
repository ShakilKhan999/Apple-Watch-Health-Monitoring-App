class NewChatModel {
  final String text;
  final bool isUser; // true = user, false = bot
  final DateTime timestamp;

  NewChatModel({
    required this.text,
    required this.isUser,
    required this.timestamp,
  });
}
