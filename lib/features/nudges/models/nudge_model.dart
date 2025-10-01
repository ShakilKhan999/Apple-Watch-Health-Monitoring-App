class NudgeModel {
  final String id;
  final String title;
  final String description;
  final NudgeCategory category;
  final double currentValue;
  final double targetValue;
  final String unit;
  final DateTime date;
  final List<bool> scheduledDays; // [Mon, Tue, Wed, Thu, Fri, Sat, Sun]
  final DateTime? completedAt;
  final bool isCompleted;
  final List<NudgeLog> logs;
  final String? userId; // For API association
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isActive;

  NudgeModel({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.currentValue,
    required this.targetValue,
    required this.unit,
    required this.date,
    required this.scheduledDays,
    this.completedAt,
    this.isCompleted = false,
    this.logs = const [],
    this.userId,
    DateTime? createdAt,
    DateTime? updatedAt,
    this.isActive = true,
  }) : createdAt = createdAt ?? DateTime.now(),
       updatedAt = updatedAt ?? DateTime.now();

  double get progressPercentage {
    if (targetValue == 0) return 0;
    return (currentValue / targetValue * 100).clamp(0, 100);
  }

  // Generate dynamic description based on current progress
  String get dynamicDescription {
    if (currentValue == 0) {
      // Show target when no progress yet
      return _getInitialDescription();
    } else {
      // Show both current and target after logging
      return _getProgressDescription();
    }
  }

  // Generate dynamic title based on current progress
  String get dynamicTitle {
    if (currentValue == 0) {
      return _getInitialTitle();
    } else if (isCompleted) {
      return _getCompletedTitle();
    } else {
      return _getProgressTitle();
    }
  }

  String _getInitialTitle() {
    switch (category) {
      case NudgeCategory.hydration:
        return 'Stay hydrated today!';
      case NudgeCategory.movement:
        return 'Let\'s get moving!';
      case NudgeCategory.sleep:
        return 'Prioritize your sleep';
      case NudgeCategory.weight:
        return 'Track your weight goal';
    }
  }

  String _getProgressTitle() {
    final remaining = targetValue - currentValue;

    switch (category) {
      case NudgeCategory.hydration:
        return 'Keep drinking! ${_formatValue(remaining)} $unit to go';
      case NudgeCategory.movement:
        return 'Almost there! ${_formatValue(remaining)} $unit left';
      case NudgeCategory.sleep:
        return 'Sleep progress: ${_formatValue(currentValue)}/${_formatValue(targetValue)} $unit';
      case NudgeCategory.weight:
        return 'Weight tracking in progress';
    }
  }

  String _getCompletedTitle() {
    switch (category) {
      case NudgeCategory.hydration:
        return 'Hydration goal completed! 🎉';
      case NudgeCategory.movement:
        return 'Movement goal achieved! 🎉';
      case NudgeCategory.sleep:
        return 'Sleep goal reached! 🎉';
      case NudgeCategory.weight:
        return 'Weight goal completed! 🎉';
    }
  }

  String _getInitialDescription() {
    switch (category) {
      case NudgeCategory.hydration:
        return 'Target: ${_formatValue(targetValue)} $unit of water today';
      case NudgeCategory.movement:
        return 'Target: ${_formatValue(targetValue)} $unit today';
      case NudgeCategory.sleep:
        return 'Target: ${_formatValue(targetValue)} $unit of sleep';
      case NudgeCategory.weight:
        return 'Target: ${_formatValue(targetValue)}$unit';
    }
  }

  String _getProgressDescription() {
    final remaining = targetValue - currentValue;

    if (isCompleted) {
      return _getCompletedDescription();
    }

    switch (category) {
      case NudgeCategory.hydration:
        return 'Current: ${_formatValue(currentValue)} $unit • Target: ${_formatValue(targetValue)} $unit\n${_formatValue(remaining)} $unit left to reach your goal!';
      case NudgeCategory.movement:
        return 'Current: ${_formatValue(currentValue)} $unit • Target: ${_formatValue(targetValue)} $unit\nOnly ${_formatValue(remaining)} $unit left. You got this!';
      case NudgeCategory.sleep:
        return 'Current: ${_formatValue(currentValue)} $unit • Target: ${_formatValue(targetValue)} $unit';
      case NudgeCategory.weight:
        return 'Current: ${_formatValue(currentValue)}$unit • Target: ${_formatValue(targetValue)}$unit';
    }
  }

  String _getCompletedDescription() {
    switch (category) {
      case NudgeCategory.hydration:
        return 'Completed! You drank ${_formatValue(currentValue)} $unit of water today 🎉';
      case NudgeCategory.movement:
        return 'Goal achieved! You completed ${_formatValue(currentValue)} $unit today 🎉';
      case NudgeCategory.sleep:
        return 'Sleep goal completed! ${_formatValue(currentValue)} $unit 🎉';
      case NudgeCategory.weight:
        return 'Weight goal reached! ${_formatValue(currentValue)}$unit 🎉';
    }
  }

  String _formatValue(double value) {
    if (value == value.roundToDouble()) {
      return value.toInt().toString();
    }
    return value.toString();
  }

  bool get isOverdue {
    return date.isBefore(DateTime.now()) && !isCompleted;
  }

  NudgeModel copyWith({
    String? id,
    String? title,
    String? description,
    NudgeCategory? category,
    double? currentValue,
    double? targetValue,
    String? unit,
    DateTime? date,
    List<bool>? scheduledDays,
    DateTime? completedAt,
    bool? isCompleted,
    List<NudgeLog>? logs,
    String? userId,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isActive,
  }) {
    return NudgeModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      category: category ?? this.category,
      currentValue: currentValue ?? this.currentValue,
      targetValue: targetValue ?? this.targetValue,
      unit: unit ?? this.unit,
      date: date ?? this.date,
      scheduledDays: scheduledDays ?? this.scheduledDays,
      completedAt: completedAt ?? this.completedAt,
      isCompleted: isCompleted ?? this.isCompleted,
      logs: logs ?? this.logs,
      userId: userId ?? this.userId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isActive: isActive ?? this.isActive,
    );
  }

  // Convert to JSON for API requests
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'category': category.name,
      'currentValue': currentValue,
      'targetValue': targetValue,
      'unit': unit,
      'date': date.toIso8601String(),
      'scheduledDays': scheduledDays,
      'completedAt': completedAt?.toIso8601String(),
      'isCompleted': isCompleted,
      'logs': logs.map((log) => log.toJson()).toList(),
      'userId': userId,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'isActive': isActive,
    };
  }

  // Create from JSON API response
  factory NudgeModel.fromJson(Map<String, dynamic> json) {
    return NudgeModel(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      category: NudgeCategory.values.firstWhere(
        (e) => e.name == json['category'],
        orElse: () => NudgeCategory.hydration,
      ),
      currentValue: (json['currentValue'] as num).toDouble(),
      targetValue: (json['targetValue'] as num).toDouble(),
      unit: json['unit'] as String,
      date: DateTime.parse(json['date'] as String),
      scheduledDays: List<bool>.from(json['scheduledDays'] as List),
      completedAt: json['completedAt'] != null
          ? DateTime.parse(json['completedAt'] as String)
          : null,
      isCompleted: json['isCompleted'] as bool? ?? false,
      logs:
          (json['logs'] as List<dynamic>?)
              ?.map(
                (logJson) => NudgeLog.fromJson(logJson as Map<String, dynamic>),
              )
              .toList() ??
          [],
      userId: json['userId'] as String?,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : DateTime.now(),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'] as String)
          : DateTime.now(),
      isActive: json['isActive'] as bool? ?? true,
    );
  }

  // Create request body for API
  Map<String, dynamic> toCreateRequest() {
    return {
      'title': title,
      'description': description,
      'category': category.name,
      'targetValue': targetValue,
      'unit': unit,
      'date': date.toIso8601String(),
      'scheduledDays': scheduledDays,
    };
  }

  // Update request body for API
  Map<String, dynamic> toUpdateRequest() {
    return {
      'title': title,
      'description': description,
      'currentValue': currentValue,
      'targetValue': targetValue,
      'unit': unit,
      'date': date.toIso8601String(),
      'scheduledDays': scheduledDays,
      'isCompleted': isCompleted,
      'isActive': isActive,
    };
  }
}

class NudgeLog {
  final String id;
  final double value;
  final DateTime loggedAt;
  final String? note;
  final String? userId; // For API association

  NudgeLog({
    required this.id,
    required this.value,
    required this.loggedAt,
    this.note,
    this.userId,
  });

  // Convert to JSON for API requests
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'value': value,
      'loggedAt': loggedAt.toIso8601String(),
      'note': note,
      'userId': userId,
    };
  }

  // Create from JSON API response
  factory NudgeLog.fromJson(Map<String, dynamic> json) {
    return NudgeLog(
      id: json['id'] as String,
      value: (json['value'] as num).toDouble(),
      loggedAt: DateTime.parse(json['loggedAt'] as String),
      note: json['note'] as String?,
      userId: json['userId'] as String?,
    );
  }

  // Create request body for logging API
  Map<String, dynamic> toCreateRequest() {
    return {
      'value': value,
      'loggedAt': loggedAt.toIso8601String(),
      'note': note,
    };
  }
}

enum NudgeCategory {
  hydration,
  sleep,
  weight,
  movement;

  String get displayName {
    switch (this) {
      case NudgeCategory.hydration:
        return 'Hydration';
      case NudgeCategory.sleep:
        return 'Sleep';
      case NudgeCategory.weight:
        return 'Weight';
      case NudgeCategory.movement:
        return 'Movement';
    }
  }

  String get icon {
    switch (this) {
      case NudgeCategory.hydration:
        return 'assets/icons/hydration.svg';
      case NudgeCategory.sleep:
        return 'assets/icons/sleep.svg';
      case NudgeCategory.weight:
        return 'assets/icons/weight.svg';
      case NudgeCategory.movement:
        return 'assets/icons/movement.svg';
    }
  }

  String get primaryColor {
    switch (this) {
      case NudgeCategory.hydration:
        return '#4A7BFF';
      case NudgeCategory.sleep:
        return '#D46434';
      case NudgeCategory.weight:
        return '#34C759';
      case NudgeCategory.movement:
        return '#D46434';
    }
  }

  String get backgroundColor {
    switch (this) {
      case NudgeCategory.hydration:
        return '#C7D6FF';
      case NudgeCategory.sleep:
        return '#FFF9F2';
      case NudgeCategory.weight:
        return '#EBF9EE';
      case NudgeCategory.movement:
        return '#FFF9F2';
    }
  }

  String get lightColor {
    switch (this) {
      case NudgeCategory.hydration:
        return '#E4EBFF';
      case NudgeCategory.sleep:
        return 'rgba(212,100,52,0.14)';
      case NudgeCategory.weight:
        return 'rgba(52,199,89,0.5)';
      case NudgeCategory.movement:
        return 'rgba(212,100,52,0.14)';
    }
  }

  List<String> get defaultUnits {
    switch (this) {
      case NudgeCategory.hydration:
        return ['ML', 'L'];
      case NudgeCategory.sleep:
        return ['hours', 'minutes'];
      case NudgeCategory.weight:
        return ['kg', 'lbs'];
      case NudgeCategory.movement:
        return ['steps', 'minutes'];
    }
  }
}

class UpcomingNudge {
  final String id;
  final String title;
  final String time;
  final NudgeCategory category;
  final String? nudgeId; // Reference to the parent nudge
  final DateTime? scheduledDate;

  UpcomingNudge({
    required this.id,
    required this.title,
    required this.time,
    required this.category,
    this.nudgeId,
    this.scheduledDate,
  });

  // Convert to JSON for API requests
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'time': time,
      'category': category.name,
      'nudgeId': nudgeId,
      'scheduledDate': scheduledDate?.toIso8601String(),
    };
  }

  // Create from JSON API response
  factory UpcomingNudge.fromJson(Map<String, dynamic> json) {
    return UpcomingNudge(
      id: json['id'] as String,
      title: json['title'] as String,
      time: json['time'] as String,
      category: NudgeCategory.values.firstWhere(
        (e) => e.name == json['category'],
        orElse: () => NudgeCategory.hydration,
      ),
      nudgeId: json['nudgeId'] as String?,
      scheduledDate: json['scheduledDate'] != null
          ? DateTime.parse(json['scheduledDate'] as String)
          : null,
    );
  }
}
