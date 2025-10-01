import 'package:flutter/material.dart';

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
  });

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
    );
  }
}

class NudgeLog {
  final String id;
  final double value;
  final String unit;
  final DateTime timestamp;
  final String? note;

  NudgeLog({
    required this.id,
    required this.value,
    required this.unit,
    required this.timestamp,
    this.note,
  });
}

class UpcomingNudge {
  final String id;
  final String title;
  final String time;
  final NudgeCategory category;

  UpcomingNudge({
    required this.id,
    required this.title,
    required this.time,
    required this.category,
  });
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

  List<String> get defaultUnits {
    switch (this) {
      case NudgeCategory.hydration:
        return ['ML', 'L'];
      case NudgeCategory.sleep:
        return ['hours', 'minutes'];
      case NudgeCategory.weight:
        return ['kg', 'lbs'];
      case NudgeCategory.movement:
        return ['steps', 'minutes', 'km'];
    }
  }

  Color get primaryColor {
    switch (this) {
      case NudgeCategory.hydration:
        return Color(0xFF4A7BFF);
      case NudgeCategory.sleep:
        return Color(0xFF8B5CF6);
      case NudgeCategory.weight:
        return Color(0xFF10B981);
      case NudgeCategory.movement:
        return Color(0xFFD46434);
    }
  }

  Color get backgroundColor {
    switch (this) {
      case NudgeCategory.hydration:
        return Color(0xFFE4EBFF);
      case NudgeCategory.sleep:
        return Color(0xFFF3E8FF);
      case NudgeCategory.weight:
        return Color(0xFFEBF9EE);
      case NudgeCategory.movement:
        return Color(0xFFFFE8D9);
    }
  }
}
