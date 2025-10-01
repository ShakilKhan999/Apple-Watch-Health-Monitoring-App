class WearableCardModel {
  final String title;
  final String subtitle;
  final String iconPath;
  final bool isConnected;

  WearableCardModel({
    required this.title,
    required this.subtitle,
    required this.iconPath,
    this.isConnected = false,
  });

  WearableCardModel copyWith({
    String? title,
    String? subtitle,
    String? iconPath,
    bool? isConnected,
  }) {
    return WearableCardModel(
      title: title ?? this.title,
      subtitle: subtitle ?? this.subtitle,
      iconPath: iconPath ?? this.iconPath,
      isConnected: isConnected ?? this.isConnected,
    );
  }
}
