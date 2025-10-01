class NotificationModel {
  final String id;
  final String source; // "google", "strava"
  final String message;
  final String time; // formatted datetime
  bool isRead;

  NotificationModel({
    required this.id,
    required this.source,
    required this.message,
    required this.time,
    this.isRead = false,
  });
}
