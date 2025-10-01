import 'package:fl_chart/fl_chart.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:surajashray/features/bottom_navigation/controllers/bottom_navigation_controller.dart';

class VitalSignsDetailsController extends GetxController {
  // Reactive variables
  final RxBool _isLoading = false.obs;
  final RxString _currentDate = ''.obs;
  final RxString _selectedPeriod = 'Today'.obs;
  final RxString _selectedTrendPeriod = 'Weekly'.obs;

  // Getters
  bool get isLoading => _isLoading.value;
  String get currentDate => _currentDate.value;
  String get selectedPeriod => _selectedPeriod.value;
  String get selectedTrendPeriod => _selectedTrendPeriod.value;
  String get selectedVitalSign => _selectedVitalSign.value;

  // Period options for filter
  final List<String> periods = ['Today', 'Week', 'Month', 'Year'];

  // Trend period options for dropdown
  final List<String> trendPeriods = ['Daily', 'Weekly', 'Monthly', 'Yearly'];

  // Heart rate data for chart (hourly data for today)
  final RxList<Map<String, dynamic>> _heartRateData = <Map<String, dynamic>>[
    {'time': '6AM', 'hour': 6, 'bpm': 78},
    {'time': '9AM', 'hour': 9, 'bpm': 82},
    {'time': '12PM', 'hour': 12, 'bpm': 79},
    {'time': '3PM', 'hour': 15, 'bpm': 85},
    {'time': '6PM', 'hour': 18, 'bpm': 90},
    {'time': '9PM', 'hour': 21, 'bpm': 88},
  ].obs;

  List<Map<String, dynamic>> get heartRateData => _heartRateData;

  // Steps data for chart (hourly data for today)
  final RxList<Map<String, dynamic>> _stepsData = <Map<String, dynamic>>[
    {'time': '6AM', 'hour': 6, 'steps': 65},
    {'time': '9AM', 'hour': 9, 'steps': 78},
    {'time': '12PM', 'hour': 12, 'steps': 88},
    {'time': '3PM', 'hour': 15, 'steps': 95},
    {'time': '6PM', 'hour': 18, 'steps': 82},
    {'time': '9PM', 'hour': 21, 'steps': 100},
  ].obs;

  List<Map<String, dynamic>> get stepsData => _stepsData;

  // Sleep analysis data
  final RxMap<String, dynamic> _sleepData = <String, dynamic>{
    'totalSleep': '7h 30m',
    'sleepTime': '10:30 PM',
    'wakeTime': '6:00 AM',
    'sleepQuality': 85, // percentage
    'deepSleep': {'duration': '1h 45m', 'percentage': 23.3},
    'remSleep': {'duration': '2h 15m', 'percentage': 30.0},
    'lightSleep': {'duration': '3h 30m', 'percentage': 46.7},
    'goalMet': true,
  }.obs;

  Map<String, dynamic> get sleepData => _sleepData;

  // Sleep stages timeline data for chart
  final RxList<Map<String, dynamic>> _sleepStagesData = <Map<String, dynamic>>[
    {
      'name': 'Deep Sleep',
      'color': const Color(0xFF4A7BFF),
      'timeSlots': [
        {'time': 0.0, 'stage': 0}, // 10:30 PM - Awake
        {'time': 0.5, 'stage': 3}, // 11:00 PM - Deep Sleep
        {'time': 1.0, 'stage': 3}, // 12:00 AM - Deep Sleep
        {'time': 1.5, 'stage': 2}, // 1:00 AM - REM
        {'time': 2.0, 'stage': 3}, // 2:00 AM - Deep Sleep
        {'time': 2.5, 'stage': 1}, // 3:00 AM - Light Sleep
        {'time': 3.0, 'stage': 1}, // 4:00 AM - Light Sleep
        {'time': 3.5, 'stage': 2}, // 5:00 AM - REM
        {'time': 4.0, 'stage': 0}, // 6:00 AM - Awake
      ],
    },
  ].obs;

  List<Map<String, dynamic>> get sleepStagesData => _sleepStagesData;

  // Blood oxygen data
  final RxMap<String, dynamic> _bloodOxygenData = <String, dynamic>{
    'currentLevel': 52,
    'averageLevel': 97.5,
    'minLevel': 95,
    'maxLevel': 99,
    'lastUpdated': '2 min ago',
    'status': 'Normal',
    'isHealthy': true,
  }.obs;

  Map<String, dynamic> get bloodOxygenData => _bloodOxygenData;

  // Blood oxygen readings throughout the day
  final RxList<Map<String, dynamic>> _bloodOxygenReadings =
      <Map<String, dynamic>>[
        {'time': '6AM', 'hour': 6, 'level': 97},
        {'time': '9AM', 'hour': 9, 'level': 98},
        {'time': '12PM', 'hour': 12, 'level': 99},
        {'time': '3PM', 'hour': 15, 'level': 98},
        {'time': '6PM', 'hour': 18, 'level': 97},
        {'time': '9PM', 'hour': 21, 'level': 98},
      ].obs;

  List<Map<String, dynamic>> get bloodOxygenReadings => _bloodOxygenReadings;

  // Detailed vital signs data with more comprehensive information
  final RxMap<String, dynamic> _detailedVitalSigns = <String, dynamic>{
    'steps': {
      'title': 'Steps',
      'currentValue': '8,247',
      'targetValue': '10,000',
      'percentage': 82,
      'unit': 'steps',
      'color': 0xFFD46434,
      'icon': 'assets/icons/steps.png',
      'trend': 'up',
      'trendPercentage': 12,
      'chartData': [6500, 7200, 8100, 8900, 8247],
    },
    'sleep': {
      'title': 'Sleep',
      'currentValue': '7.5',
      'targetValue': '8.0',
      'percentage': 94,
      'unit': 'hours',
      'color': 0xFF4A7BFF,
      'icon': 'assets/icons/sleep.png',
      'trend': 'up',
      'trendPercentage': 8,
      'chartData': [6.8, 7.2, 7.8, 8.1, 7.5],
    },
    'heart': {
      'title': 'Heart Rate',
      'currentValue': '72',
      'targetValue': '60-100',
      'percentage': 85,
      'unit': 'BPM',
      'color': 0xFFFF6B6B,
      'icon': 'assets/icons/heart.png',
      'trend': 'stable',
      'trendPercentage': 2,
      'chartData': [68, 70, 74, 71, 72],
    },
    'calories': {
      'title': 'Calories Burned',
      'currentValue': '1,247',
      'targetValue': '1,500',
      'percentage': 83,
      'unit': 'kcal',
      'color': 0xFF6F3FC3,
      'icon': 'assets/icons/calories.png',
      'trend': 'up',
      'trendPercentage': 15,
      'chartData': [1100, 1250, 1180, 1350, 1247],
    },
  }.obs;

  Map<String, dynamic> get detailedVitalSigns => _detailedVitalSigns;

  // Weekly summary data
  final RxList<Map<String, dynamic>> _weeklySummary = <Map<String, dynamic>>[
    {
      'day': 'Mon',
      'steps': 9200,
      'sleep': 7.8,
      'heartRate': 68,
      'calories': 1180,
      'bloodOxygen': 98,
    },
    {
      'day': 'Tue',
      'steps': 8500,
      'sleep': 7.2,
      'heartRate': 70,
      'calories': 1250,
      'bloodOxygen': 97,
    },
    {
      'day': 'Wed',
      'steps': 10100,
      'sleep': 8.1,
      'heartRate': 74,
      'calories': 1350,
      'bloodOxygen': 99,
    },
    {
      'day': 'Thu',
      'steps': 7800,
      'sleep': 6.9,
      'heartRate': 71,
      'calories': 1100,
      'bloodOxygen': 96,
    },
    {
      'day': 'Fri',
      'steps': 8900,
      'sleep': 7.5,
      'heartRate': 72,
      'calories': 1247,
      'bloodOxygen': 98,
    },
    {
      'day': 'Sat',
      'steps': 6200,
      'sleep': 8.5,
      'heartRate': 65,
      'calories': 980,
      'bloodOxygen': 97,
    },
    {
      'day': 'Sun',
      'steps': 8247,
      'sleep': 7.5,
      'heartRate': 72,
      'calories': 1247,
      'bloodOxygen': 98,
    },
  ].obs;

  List<Map<String, dynamic>> get weeklySummary => _weeklySummary;

  // Health insights data
  final RxList<Map<String, dynamic>> _healthInsights = <Map<String, dynamic>>[
    {
      'title': 'Great Progress!',
      'description':
          'Your step count has improved by 12% this week. Keep up the excellent work!',
      'color': 0xFF34C759,
      'icon': 'trending_up',
      'type': 'positive',
    },
    {
      'title': 'Sleep Pattern',
      'description':
          'Your sleep quality is consistent. Try going to bed 30 minutes earlier for optimal rest.',
      'color': 0xFF4A7BFF,
      'icon': 'nights_stay',
      'type': 'suggestion',
    },
    {
      'title': 'Heart Health',
      'description':
          'Your resting heart rate is in a healthy range. Regular exercise is helping!',
      'color': 0xFFFF6B6B,
      'icon': 'favorite',
      'type': 'positive',
    },
  ].obs;

  List<Map<String, dynamic>> get healthInsights => _healthInsights;

  // Recommendations data
  final RxList<Map<String, dynamic>> _recommendations = <Map<String, dynamic>>[
    {
      'title': 'Increase Daily Steps',
      'description':
          'Aim for 10,000 steps daily. Take short walks during breaks.',
      'emoji': '🚶‍♂️',
      'color': 0xFFD46434,
      'priority': 'high',
    },
    {
      'title': 'Maintain Sleep Schedule',
      'description':
          'Go to bed and wake up at consistent times for better rest.',
      'emoji': '😴',
      'color': 0xFF4A7BFF,
      'priority': 'medium',
    },
    {
      'title': 'Stay Hydrated',
      'description':
          'Drink at least 8 glasses of water daily for optimal health.',
      'emoji': '💧',
      'color': 0xFF34C759,
      'priority': 'medium',
    },
  ].obs;

  List<Map<String, dynamic>> get recommendations => _recommendations;

  // Selected vital sign for trend chart
  final RxString _selectedVitalSign = 'Heart Rate'.obs;

  // Available vital signs for trend chart
  final List<String> vitalSigns = [
    'Heart Rate',
    'Steps',
    'Sleep',
    'Blood Oxygen',
  ];

  // Trend chart data for different periods and vital signs
  final RxMap<String, Map<String, List<FlSpot>>> _trendChartData =
      <String, Map<String, List<FlSpot>>>{
        'Daily': {
          'Heart Rate': [
            const FlSpot(0, 72),
            const FlSpot(1, 75),
            const FlSpot(2, 78),
            const FlSpot(3, 74),
            const FlSpot(4, 76),
            const FlSpot(5, 73),
            const FlSpot(6, 71),
          ],
          'Steps': [
            const FlSpot(0, 1200),
            const FlSpot(1, 1800),
            const FlSpot(2, 2400),
            const FlSpot(3, 2100),
            const FlSpot(4, 2600),
            const FlSpot(5, 2300),
            const FlSpot(6, 1900),
          ],
          'Sleep': [
            const FlSpot(0, 7.2),
            const FlSpot(1, 7.5),
            const FlSpot(2, 7.8),
            const FlSpot(3, 7.4),
            const FlSpot(4, 7.6),
            const FlSpot(5, 7.3),
            const FlSpot(6, 7.1),
          ],
          'Blood Oxygen': [
            const FlSpot(0, 97),
            const FlSpot(1, 98),
            const FlSpot(2, 99),
            const FlSpot(3, 97),
            const FlSpot(4, 98),
            const FlSpot(5, 96),
            const FlSpot(6, 97),
          ],
        },
        'Weekly': {
          'Heart Rate': [
            const FlSpot(0, 74),
            const FlSpot(1, 72),
            const FlSpot(2, 76),
            const FlSpot(3, 75),
            const FlSpot(4, 73),
            const FlSpot(5, 77),
            const FlSpot(6, 74),
          ],
          'Steps': [
            const FlSpot(0, 8200),
            const FlSpot(1, 7500),
            const FlSpot(2, 9100),
            const FlSpot(3, 8800),
            const FlSpot(4, 7300),
            const FlSpot(5, 9500),
            const FlSpot(6, 8400),
          ],
          'Sleep': [
            const FlSpot(0, 7.5),
            const FlSpot(1, 7.2),
            const FlSpot(2, 8.1),
            const FlSpot(3, 7.8),
            const FlSpot(4, 6.9),
            const FlSpot(5, 8.5),
            const FlSpot(6, 7.5),
          ],
          'Blood Oxygen': [
            const FlSpot(0, 98),
            const FlSpot(1, 97),
            const FlSpot(2, 99),
            const FlSpot(3, 98),
            const FlSpot(4, 96),
            const FlSpot(5, 97),
            const FlSpot(6, 98),
          ],
        },
        'Monthly': {
          'Heart Rate': [
            const FlSpot(0, 75),
            const FlSpot(1, 73),
            const FlSpot(2, 76),
            const FlSpot(3, 74),
            const FlSpot(4, 72),
            const FlSpot(5, 78),
            const FlSpot(6, 76),
          ],
          'Steps': [
            const FlSpot(0, 8500),
            const FlSpot(1, 7800),
            const FlSpot(2, 9200),
            const FlSpot(3, 8700),
            const FlSpot(4, 7500),
            const FlSpot(5, 9800),
            const FlSpot(6, 8900),
          ],
          'Sleep': [
            const FlSpot(0, 7.6),
            const FlSpot(1, 7.3),
            const FlSpot(2, 8.0),
            const FlSpot(3, 7.7),
            const FlSpot(4, 7.1),
            const FlSpot(5, 8.3),
            const FlSpot(6, 7.8),
          ],
          'Blood Oxygen': [
            const FlSpot(0, 97.5),
            const FlSpot(1, 97.0),
            const FlSpot(2, 98.5),
            const FlSpot(3, 97.8),
            const FlSpot(4, 96.5),
            const FlSpot(5, 98.0),
            const FlSpot(6, 97.7),
          ],
        },
        'Yearly': {
          'Heart Rate': [
            const FlSpot(0, 76),
            const FlSpot(1, 74),
            const FlSpot(2, 75),
            const FlSpot(3, 73),
            const FlSpot(4, 77),
            const FlSpot(5, 75),
            const FlSpot(6, 74),
          ],
          'Steps': [
            const FlSpot(0, 8800),
            const FlSpot(1, 8200),
            const FlSpot(2, 8600),
            const FlSpot(3, 8100),
            const FlSpot(4, 9100),
            const FlSpot(5, 8700),
            const FlSpot(6, 8400),
          ],
          'Sleep': [
            const FlSpot(0, 7.7),
            const FlSpot(1, 7.4),
            const FlSpot(2, 7.6),
            const FlSpot(3, 7.2),
            const FlSpot(4, 8.0),
            const FlSpot(5, 7.8),
            const FlSpot(6, 7.5),
          ],
          'Blood Oxygen': [
            const FlSpot(0, 97.8),
            const FlSpot(1, 97.2),
            const FlSpot(2, 97.6),
            const FlSpot(3, 97.0),
            const FlSpot(4, 98.2),
            const FlSpot(5, 97.9),
            const FlSpot(6, 97.5),
          ],
        },
      }.obs;

  Map<String, Map<String, List<FlSpot>>> get trendChartData => _trendChartData;

  // Get current trend chart data based on selected period and vital sign
  List<FlSpot> get currentTrendChartData {
    final periodData =
        _trendChartData[_selectedTrendPeriod.value] ??
        _trendChartData['Weekly']!;
    return periodData[_selectedVitalSign.value] ??
        periodData['Heart Rate'] ??
        [];
  }

  @override
  void onInit() {
    super.onInit();
    _initializeData();
    _validateTrendChartData();
    debugPrint('VitalSignsDetailsController initialized');
  }

  @override
  void onClose() {
    super.onClose();
    debugPrint('VitalSignsDetailsController disposed');
  }

  // Initialize data
  void _initializeData() {
    _setCurrentDate();
    _setLoading(false);
    _generateSleepStagesData();
  }

  // Validate trend chart data structure
  void _validateTrendChartData() {
    // Ensure all periods have all vital signs data
    for (String period in trendPeriods) {
      if (!_trendChartData.containsKey(period)) {
        debugPrint('Missing period data for: $period');
        continue;
      }
      for (String vitalSign in vitalSigns) {
        if (!_trendChartData[period]!.containsKey(vitalSign)) {
          debugPrint('Missing vital sign data for: $period - $vitalSign');
        }
      }
    }
  }

  // Set current date
  void _setCurrentDate() {
    final now = DateTime.now();
    final days = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday',
    ];
    final months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];

    final dayName = days[now.weekday - 1];
    final monthName = months[now.month - 1];

    _currentDate.value = '$dayName, $monthName ${now.day}';
  }

  // Set loading state
  void _setLoading(bool value) {
    _isLoading.value = value;
  }

  // Generate sleep stages data for chart
  void _generateSleepStagesData() {
    _sleepStagesData.value = [
      {
        'name': 'Deep Sleep',
        'color': const Color(0xFF4A7BFF),
        'spots': [
          const FlSpot(0, 0),
          const FlSpot(0.5, 3),
          const FlSpot(1, 3),
          const FlSpot(1.5, 2.8),
          const FlSpot(2, 3),
          const FlSpot(2.5, 2.5),
          const FlSpot(3, 1.8),
          const FlSpot(3.5, 1),
          const FlSpot(4, 0),
        ],
      },
      {
        'name': 'REM Sleep',
        'color': const Color(0xFF7B68EE),
        'spots': [
          const FlSpot(0, 0),
          const FlSpot(0.5, 2.5),
          const FlSpot(1, 2.3),
          const FlSpot(1.5, 2.2),
          const FlSpot(2, 2.4),
          const FlSpot(2.5, 2),
          const FlSpot(3, 1.5),
          const FlSpot(3.5, 0.8),
          const FlSpot(4, 0),
        ],
      },
      {
        'name': 'Light Sleep',
        'color': const Color(0xFFB8C5FF),
        'spots': [
          const FlSpot(0, 0),
          const FlSpot(0.5, 1.8),
          const FlSpot(1, 1.6),
          const FlSpot(1.5, 1.5),
          const FlSpot(2, 1.7),
          const FlSpot(2.5, 1.3),
          const FlSpot(3, 1),
          const FlSpot(3.5, 0.5),
          const FlSpot(4, 0),
        ],
      },
    ];
  }

  // Change selected period
  void changePeriod(String period) {
    _selectedPeriod.value = period;
    debugPrint('Period changed to: $period');
    // Here you would typically fetch new data based on the selected period
    _updateChartData(period);
  }

  // Change selected trend period
  void changeTrendPeriod(String period) {
    _selectedTrendPeriod.value = period;
    debugPrint('Trend period changed to: $period');
    // Here you would typically fetch new trend data based on the selected period
    _updateTrendChartData(period);
  }

  // Change selected vital sign
  void changeVitalSign(String vitalSign) {
    _selectedVitalSign.value = vitalSign;
    debugPrint('Vital sign changed to: $vitalSign');
    // Here you would typically fetch new trend data based on the selected vital sign
  }

  // Update chart data based on selected period
  void _updateChartData(String period) {
    // This is where you would fetch different data based on period
    // For now, just updating the existing data slightly
    switch (period) {
      case 'Week':
        // Update with weekly data
        _updateWeeklyData();
        break;
      case 'Month':
        // Update with monthly data
        _updateMonthlyData();
        break;
      case 'Year':
        // Update with yearly data
        _updateYearlyData();
        break;
      default:
        // Keep today's data
        _updateTodayData();
        break;
    }
  }

  // Update methods for different periods
  void _updateTodayData() {
    // Reset to today's data
    _generateSleepStagesData();
  }

  void _updateWeeklyData() {
    // Generate weekly average data
    // This would typically come from your backend
  }

  void _updateMonthlyData() {
    // Generate monthly average data
  }

  void _updateYearlyData() {
    // Generate yearly average data
  }

  // Update trend chart data based on selected period
  void _updateTrendChartData(String period) {
    // This is where you would fetch different trend data based on period
    // For now, the data is already prepared in _trendChartData
    // In a real app, you would make API calls here
    switch (period) {
      case 'Daily':
        // Data is already set for hourly data (last 7 hours)
        break;
      case 'Weekly':
        // Data is already set for daily data (last 7 days)
        break;
      case 'Monthly':
        // Data is already set for weekly data (last 7 weeks)
        break;
      case 'Yearly':
        // Data is already set for monthly data (last 7 months)
        break;
    }
  }

  // Update blood oxygen level (simulate real-time updates)
  void updateBloodOxygenLevel(int newLevel) {
    _bloodOxygenData['currentLevel'] = newLevel;
    _bloodOxygenData['lastUpdated'] = 'Just now';

    // Update status based on level
    if (newLevel >= 95) {
      _bloodOxygenData['status'] = 'Normal';
      _bloodOxygenData['isHealthy'] = true;
    } else if (newLevel >= 90) {
      _bloodOxygenData['status'] = 'Low';
      _bloodOxygenData['isHealthy'] = false;
    } else {
      _bloodOxygenData['status'] = 'Critical';
      _bloodOxygenData['isHealthy'] = false;
    }
  }

  // Update sleep data
  void updateSleepData(Map<String, dynamic> newSleepData) {
    _sleepData.addAll(newSleepData);
    _generateSleepStagesData(); // Regenerate chart data
  }

  // Navigation methods
  void onBackPressed() {
    // Set bottom navigation back to Home tab
    final bottomNavController = Get.find<BottomNavigationController>();
    bottomNavController.changeTab(0); // Home tab

    Get.back();
  }

  void onVitalSignTap(String vitalSignKey) {
    debugPrint('Vital sign tapped: $vitalSignKey');
    // Navigate to individual vital sign detail if needed
  }

  void onCreatePersonalPlan() {
    debugPrint('Create personal plan tapped');
    // Navigate to personal plan creation screen
  }

  void onRecommendationTap(String recommendationTitle) {
    debugPrint('Recommendation tapped: $recommendationTitle');
    // Navigate to specific recommendation detail or action
  }
}
