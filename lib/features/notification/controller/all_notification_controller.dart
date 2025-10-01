import 'package:get/get.dart';
import 'package:surajashray/core/models/notification_model.dart';
import 'package:surajashray/core/utils/formatters/app_formatters.dart';

class AllNotificationController extends GetxController {
  /// List of notifications (observable)
  final RxList<NotificationModel> notifications = <NotificationModel>[
    NotificationModel(
      id: "1",
      source: "vidhme",
      message: "Welcome Alexandra\n Lets start a smart journey with VidhMe",
      time: AppForMatters.formatDateTimeVerbose(
        DateTime.now(),
      ), // pass DateTime here
      isRead: false,
    ),
    NotificationModel(
      id: "2",
      source: "google",
      message:
          "New security alert on your Google account. We noticed a login from unauthorized device",
      time: AppForMatters.formatDateTimeVerbose(
        DateTime.now(),
      ), // pass DateTime here
      isRead: false,
    ),
    NotificationModel(
      id: "3",
      source: "strava",
      message: "You just completed a 5km run! Great job.",
      time: AppForMatters.formatDateTimeVerbose(DateTime.now()),
      isRead: true,
    ),
    NotificationModel(
      id: "4",
      source: "viidhme",
      message: "You must walk 100 steps today.",
      time: AppForMatters.formatDateTimeVerbose(DateTime.now()),
      isRead: false,
    ),
  ].obs;

  /// Mark a notification as read
  void markAsRead(String id) {
    final index = notifications.indexWhere((n) => n.id == id);
    if (index != -1 && !notifications[index].isRead) {
      notifications[index].isRead = true;
      notifications.refresh(); // Important to trigger UI update
      update(); // Trigger GetBuilder widgets to rebuild
    }
  }

  void deleteNotification(String id) {
    notifications.removeWhere((n) => n.id == id);
    update(); // Trigger GetBuilder widgets to rebuild
  }

  /// Add a new notification (you can call this from socket, API, etc.)
  void addNotification(NotificationModel notification) {
    notifications.insert(0, notification);
    update(); // Trigger GetBuilder widgets to rebuild
  }

  /// Clear all notifications (optional helper)
  void clearNotifications() {
    notifications.clear();
    update(); // Trigger GetBuilder widgets to rebuild
  }

  /// Mark all notifications as read (optional helper)
  void markAllAsRead() {
    for (var n in notifications) {
      n.isRead = true;
    }
    notifications.refresh();
    update(); // Trigger GetBuilder widgets to rebuild
  }

  /// Get the count of unread notifications
  int get unreadCount => notifications.where((n) => !n.isRead).length;

  /// Get formatted unread count for display (shows 99+ if > 99)
  String get unreadCountDisplay {
    final count = unreadCount;
    if (count == 0) return '';
    if (count > 99) return '99+';
    return count.toString();
  }
}
