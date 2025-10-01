import 'package:get/get.dart';
import 'package:surajashray/core/models/chat_history_model.dart';

class ChatHistoryController extends GetxController {
  var chatsByDate = <String, List<ChatHistoryModel>>{}.obs;
  var isLoadingMore = false.obs;
  var searchQuery = ''.obs;

  @override
  void onInit() {
    super.onInit();
    loadInitialChats();
  }

  void loadInitialChats() {
    // Example: today and yesterday's dummy chats
    final now = DateTime.now();

    chatsByDate['Today'] = [
      ChatHistoryModel(
        id: '1',
        senderInitials: 'WB',
        message: 'Thank you for sharing your symptoms. Bas...',
        timestamp: now.subtract(const Duration(hours: 1)),
      ),
      ChatHistoryModel(
        id: '2',
        senderInitials: 'WB',
        message: 'Great! I\'m glad the meditation exercises ar...',
        timestamp: now.subtract(const Duration(hours: 3)),
      ),
      ChatHistoryModel(
        id: '3',
        senderInitials: 'WB',
        message: 'Perfect! Your sleep schedule is improving.',
        timestamp: now.subtract(const Duration(days: 1, hours: 2)),
      ),
    ];

    chatsByDate['Yesterday'] = [
      ChatHistoryModel(
        id: '4',
        senderInitials: 'WB',
        message: 'The workout plan I\'ve created should help...',
        timestamp: now.subtract(const Duration(days: 1, hours: 4)),
      ),
      ChatHistoryModel(
        id: '5',
        senderInitials: 'WB',
        message: 'Keep tracking your meals, it helps a lot.',
        timestamp: now.subtract(const Duration(days: 2, hours: 1)),
      ),
    ];
    chatsByDate['2 Days Ago'] = [
      ChatHistoryModel(
        id: '6',
        senderInitials: 'WB',
        message: 'Remember to drink enough water daily.',
        timestamp: now.subtract(const Duration(days: 2, hours: 3)),
      ),
      ChatHistoryModel(
        id: '7',
        senderInitials: 'WB',
        message: 'Keep tracking your meals, it helps a lot.',
        timestamp: now.subtract(const Duration(days: 2, hours: 1)),
      ),
    ];
  }

  void loadMoreChats() async {
    if (isLoadingMore.value) return;
    isLoadingMore.value = true;

    await Future.delayed(const Duration(seconds: 1)); // simulate API delay

    final now = DateTime.now();

    chatsByDate['3 Days Ago'] = [
      ChatHistoryModel(
        id: '8',
        senderInitials: 'WB',
        message: 'Keep tracking your meals, it helps a lot.',
        timestamp: now.subtract(const Duration(days: 2, hours: 1)),
      ),
      ChatHistoryModel(
        id: '9',
        senderInitials: 'WB',
        message: 'Remember to drink enough water daily.',
        timestamp: now.subtract(const Duration(days: 2, hours: 3)),
      ),
    ];

    isLoadingMore.value = false;
  }

  Map<String, List<ChatHistoryModel>> get filteredChats {
    if (searchQuery.value.isEmpty) {
      return chatsByDate;
    }

    final query = searchQuery.value.toLowerCase();
    final filtered = <String, List<ChatHistoryModel>>{};

    chatsByDate.forEach((date, chats) {
      final matched = chats
          .where((chat) => chat.message.toLowerCase().contains(query))
          .toList();
      if (matched.isNotEmpty) {
        filtered[date] = matched;
      }
    });

    return filtered;
  }
}
