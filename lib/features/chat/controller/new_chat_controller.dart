import 'package:surajashray/core/models/new_chat_model.dart';

class NewChatController {

  static final List<String> faqOptions = [
    "How do I connect my fitness device?",
    "Why do you need camera access?",
    "How do reminders work?",
    "What happens to my data?",
  ];
  
  static final List<NewChatModel> fakeMessages = [
    NewChatModel(
      text:
          "👋 Hi there! How can we help you today? You can type your question or pick from the options below.",
      isUser: false,
      timestamp: DateTime.now().subtract(const Duration(minutes: 5)),
    ),
    NewChatModel(
      text: "How do I sync my Apple Watch?",
      isUser: true,
      timestamp: DateTime.now().subtract(const Duration(minutes: 4)),
    ),
    NewChatModel(
      text:
          "Great question! To sync your Apple Watch:\n"
          "1. Open the Health app on your iPhone\n"
          "2. Go to Settings > Privacy & Security\n"
          "3. Enable data sharing with WeLog\n\n"
          "Need more help? I can walk you through it step by step! 👇",
      isUser: false,
      timestamp: DateTime.now().subtract(const Duration(minutes: 3)),
    ),
    NewChatModel(
      text: "Talk to a real person",
      isUser: true,
      timestamp: DateTime.now().subtract(const Duration(minutes: 2)),
    ),
    NewChatModel(
      text:
          "I’m connecting you with one of our wellness specialists now. Please hold on...",
      isUser: false,
      timestamp: DateTime.now().subtract(const Duration(minutes: 1)),
    ),
  ];
}
