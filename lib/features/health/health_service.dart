import 'package:health/health.dart';

class HealthService {
  static final Health _health = Health();

  // Apple Watch specific data types
  static const List<HealthDataType> watchDataTypes = [
    HealthDataType.HEART_RATE,
    HealthDataType.STEPS,
    HealthDataType.ACTIVE_ENERGY_BURNED,
    HealthDataType.DISTANCE_WALKING_RUNNING,
    HealthDataType.FLIGHTS_CLIMBED,
    HealthDataType.WORKOUT,
    HealthDataType.BLOOD_OXYGEN,
    HealthDataType.RESTING_HEART_RATE,
    HealthDataType.WALKING_HEART_RATE,
    HealthDataType.SLEEP_ASLEEP,
    HealthDataType.SLEEP_DEEP,
    HealthDataType.SLEEP_LIGHT,
    HealthDataType.SLEEP_REM,
    HealthDataType.BASAL_ENERGY_BURNED,
    HealthDataType.BODY_TEMPERATURE,
    HealthDataType.RESPIRATORY_RATE,
  ];

  /// Initialize the health service
  static Future<bool> initialize() async {
    try {
      await _health.configure();
      return true;
    } catch (e) {
      print('Health service initialization failed: $e');
      return false;
    }
  }

  /// Request permissions for health data
  static Future<bool> requestPermissions() async {
    try {
      bool requested = await _health.requestAuthorization(
        watchDataTypes,
        permissions: watchDataTypes.map((e) => HealthDataAccess.READ).toList(),
      );
      return requested;
    } catch (e) {
      print('Permission request failed: $e');
      return false;
    }
  }

  /// Check if permissions are granted
  static Future<bool> hasPermissions() async {
    try {
      bool? hasPermission = await _health.hasPermissions(
        watchDataTypes,
        permissions: watchDataTypes.map((e) => HealthDataAccess.READ).toList(),
      );
      return hasPermission ?? false;
    } catch (e) {
      print('Permission check failed: $e');
      return false;
    }
  }

  /// Fetch Apple Watch data for the last specified days
  static Future<List<HealthDataPoint>> fetchAppleWatchData({
    int days = 7,
  }) async {
    try {
      final now = DateTime.now();
      final startDate = now.subtract(Duration(days: days));

      List<HealthDataPoint> healthData = await _health.getHealthDataFromTypes(
        types: watchDataTypes,
        startTime: startDate,
        endTime: now,
      );

      // Remove duplicates
      healthData = _health.removeDuplicates(healthData);

      return healthData;
    } catch (e) {
      print('Failed to fetch Apple Watch data: $e');
      return [];
    }
  }

  /// Get total steps for today
  static Future<int?> getTodaySteps() async {
    try {
      final now = DateTime.now();
      final midnight = DateTime(now.year, now.month, now.day);

      int? steps = await _health.getTotalStepsInInterval(midnight, now);
      return steps;
    } catch (e) {
      print('Failed to get today steps: $e');
      return null;
    }
  }

  /// Get latest heart rate reading
  static Future<double?> getLatestHeartRate() async {
    try {
      final now = DateTime.now();
      final yesterday = now.subtract(Duration(hours: 24));

      List<HealthDataPoint> heartRateData = await _health
          .getHealthDataFromTypes(
            types: [HealthDataType.HEART_RATE],
            startTime: yesterday,
            endTime: now,
          );

      if (heartRateData.isNotEmpty) {
        heartRateData.sort((a, b) => b.dateFrom.compareTo(a.dateFrom));

        final latestReading = heartRateData.first;
        if (latestReading.value is NumericHealthValue) {
          return (latestReading.value as NumericHealthValue).numericValue
              .toDouble();
        }
      }

      return null;
    } catch (e) {
      print('Failed to get latest heart rate: $e');
      return null;
    }
  }

  /// Get workouts from the last week
  static Future<List<HealthDataPoint>> getRecentWorkouts({int days = 7}) async {
    try {
      final now = DateTime.now();
      final startDate = now.subtract(Duration(days: days));

      List<HealthDataPoint> workouts = await _health.getHealthDataFromTypes(
        types: [HealthDataType.WORKOUT],
        startTime: startDate,
        endTime: now,
      );

      return _health.removeDuplicates(workouts);
    } catch (e) {
      print('Failed to get recent workouts: $e');
      return [];
    }
  }

  /// Get specific health metric
  static Future<List<HealthDataPoint>> getHealthMetric(
    HealthDataType type, {
    int days = 7,
  }) async {
    try {
      final now = DateTime.now();
      final startDate = now.subtract(Duration(days: days));

      List<HealthDataPoint> data = await _health.getHealthDataFromTypes(
        types: [type],
        startTime: startDate,
        endTime: now,
      );

      return _health.removeDuplicates(data);
    } catch (e) {
      print('Failed to get health metric $type: $e');
      return [];
    }
  }

  /// Get health summary for dashboard
  static Future<Map<String, dynamic>> getHealthSummary() async {
    try {
      final now = DateTime.now();
      final midnight = DateTime(now.year, now.month, now.day);

      // Get today's steps
      final steps = await getTodaySteps();

      // Get latest heart rate
      final heartRate = await getLatestHeartRate();

      // Get today's active calories
      final activeCaloriesData = await _health.getHealthDataFromTypes(
        types: [HealthDataType.ACTIVE_ENERGY_BURNED],
        startTime: midnight,
        endTime: now,
      );

      double activeCalories = 0;
      for (var point in activeCaloriesData) {
        if (point.value is NumericHealthValue) {
          activeCalories += (point.value as NumericHealthValue).numericValue
              .toDouble();
        }
      }

      // Get today's sleep data (from last night)
      final lastNight = midnight.subtract(Duration(days: 1));
      final sleepData = await _health.getHealthDataFromTypes(
        types: [
          HealthDataType.SLEEP_ASLEEP,
          HealthDataType.SLEEP_DEEP,
          HealthDataType.SLEEP_LIGHT,
          HealthDataType.SLEEP_REM,
        ],
        startTime: lastNight,
        endTime: now,
      );

      double totalSleepMinutes = 0;
      for (var point in sleepData) {
        if (point.value is NumericHealthValue) {
          totalSleepMinutes += (point.value as NumericHealthValue).numericValue
              .toDouble();
        }
      }

      // Convert minutes to hours
      double totalSleepHours = totalSleepMinutes / 60;

      return {
        'steps': steps,
        'heartRate': heartRate,
        'activeCalories': activeCalories
            .toDouble(), // Ensure it's always a double
        'sleepHours': totalSleepHours,
      };
    } catch (e) {
      print('Failed to get health summary: $e');
      return {};
    }
  }
}
