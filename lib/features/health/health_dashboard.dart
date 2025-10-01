import 'package:flutter/material.dart';
import 'package:health/health.dart';
import 'health_service.dart';

class HealthDashboard extends StatefulWidget {
  @override
  _HealthDashboardState createState() => _HealthDashboardState();
}

class _HealthDashboardState extends State<HealthDashboard>
    with SingleTickerProviderStateMixin {
  bool _isInitialized = false;
  bool _hasPermissions = false;
  bool _isLoading = false;

  Map<String, dynamic> _healthSummary = {};
  List<HealthDataPoint> _allHealthData = [];
  Map<HealthDataType, List<HealthDataPoint>> _categorizedData = {};
  String _statusMessage = '';

  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _initializeHealth();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _initializeHealth() async {
    setState(() {
      _isLoading = true;
      _statusMessage = 'Initializing Health service...';
    });

    bool initialized = await HealthService.initialize();
    bool hasPermissions = await HealthService.hasPermissions();

    setState(() {
      _isInitialized = initialized;
      _hasPermissions = hasPermissions;
      _isLoading = false;
      _statusMessage = initialized
          ? 'Health service ready'
          : 'Failed to initialize Health service';
    });
  }

  Future<void> _requestPermissions() async {
    setState(() {
      _isLoading = true;
      _statusMessage = 'Requesting health permissions...';
    });

    bool granted = await HealthService.requestPermissions();

    setState(() {
      _hasPermissions = granted;
      _isLoading = false;
      _statusMessage = granted
          ? 'Permissions granted! You can now fetch health data.'
          : 'Permissions denied. Please enable in Settings → Privacy & Security → Health.';
    });
  }

  Future<void> _fetchAllHealthData() async {
    if (!_hasPermissions) return;

    setState(() {
      _isLoading = true;
      _statusMessage = 'Fetching comprehensive health data...';
    });

    try {
      // Get summary
      final summary = await HealthService.getHealthSummary();

      // Get all health data for last 7 days
      final allData = await HealthService.fetchAppleWatchData(days: 7);

      // Categorize data by type
      Map<HealthDataType, List<HealthDataPoint>> categorized = {};
      for (var point in allData) {
        if (!categorized.containsKey(point.type)) {
          categorized[point.type] = [];
        }
        categorized[point.type]!.add(point);
      }

      // Sort each category by date (newest first)
      categorized.forEach((type, points) {
        points.sort((a, b) => b.dateFrom.compareTo(a.dateFrom));
      });

      setState(() {
        _healthSummary = summary;
        _allHealthData = allData;
        _categorizedData = categorized;
        _statusMessage =
            'Found ${allData.length} health data points across ${categorized.keys.length} categories';
      });
    } catch (e) {
      setState(() {
        _statusMessage = 'Error fetching data: $e';
      });
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Widget _buildStatusCard() {
    return Card(
      elevation: 4,
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.health_and_safety, color: Colors.blue),
                SizedBox(width: 8),
                Text(
                  'Health Service Status',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ],
            ),
            SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Service Initialized:'),
                Icon(
                  _isInitialized ? Icons.check_circle : Icons.cancel,
                  color: _isInitialized ? Colors.green : Colors.red,
                ),
              ],
            ),
            SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Permissions Granted:'),
                Icon(
                  _hasPermissions ? Icons.check_circle : Icons.cancel,
                  color: _hasPermissions ? Colors.green : Colors.red,
                ),
              ],
            ),
            SizedBox(height: 12),
            Text(
              _statusMessage,
              style: TextStyle(
                color:
                    _statusMessage.contains('Error') ||
                        _statusMessage.contains('denied')
                    ? Colors.red
                    : Colors.green,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons() {
    return Column(
      children: [
        if (!_hasPermissions) ...[
          ElevatedButton.icon(
            onPressed: _isLoading ? null : _requestPermissions,
            icon: Icon(Icons.security),
            label: Text('Grant Health Permissions'),
            style: ElevatedButton.styleFrom(
              minimumSize: Size(double.infinity, 48),
            ),
          ),
          SizedBox(height: 8),
        ],
        ElevatedButton.icon(
          onPressed: (_hasPermissions && !_isLoading)
              ? _fetchAllHealthData
              : null,
          icon: Icon(Icons.refresh),
          label: Text('Fetch All Health Data'),
          style: ElevatedButton.styleFrom(
            minimumSize: Size(double.infinity, 48),
          ),
        ),
      ],
    );
  }

  Widget _buildHealthSummary() {
    if (_healthSummary.isEmpty) return SizedBox.shrink();

    return Card(
      elevation: 4,
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Today\'s Health Summary',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildMetricCard(
                    Icons.directions_walk,
                    'Steps',
                    _healthSummary['steps']?.toString() ?? 'N/A',
                    Colors.blue,
                  ),
                ),
                SizedBox(width: 8),
                Expanded(
                  child: _buildMetricCard(
                    Icons.favorite,
                    'Heart Rate',
                    _healthSummary['heartRate'] != null
                        ? '${(_healthSummary['heartRate'] as double).toInt()} BPM'
                        : 'N/A',
                    Colors.red,
                  ),
                ),
              ],
            ),
            SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: _buildMetricCard(
                    Icons.local_fire_department,
                    'Calories',
                    _healthSummary['activeCalories'] != null
                        ? '${(_healthSummary['activeCalories'] as double).toStringAsFixed(1)} cal'
                        : 'N/A',
                    Colors.orange,
                  ),
                ),
                SizedBox(width: 8),
                Expanded(
                  child: _buildMetricCard(
                    Icons.bedtime,
                    'Sleep',
                    _healthSummary['sleepHours'] != null
                        ? '${(_healthSummary['sleepHours'] as double).toStringAsFixed(1)}h'
                        : 'N/A',
                    Colors.purple,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricCard(
    IconData icon,
    String label,
    String value,
    Color color,
  ) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(fontSize: 12, color: Colors.grey[600]),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: color,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildOverviewTab() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        children: [
          _buildHealthSummary(),
          SizedBox(height: 16),
          _buildDataTypesOverview(),
        ],
      ),
    );
  }

  Widget _buildDataTypesOverview() {
    if (_categorizedData.isEmpty) return SizedBox.shrink();

    return Card(
      elevation: 4,
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Available Health Data Types',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            SizedBox(height: 16),
            ..._categorizedData.entries.map((entry) {
              return ListTile(
                leading: _getHealthTypeIcon(entry.key),
                title: Text(
                  _formatHealthTypeName(entry.key),
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
                subtitle: Text('${entry.value.length} data points'),
                trailing: Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {
                  _showDataTypeDetails(entry.key, entry.value);
                },
              );
            }).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildAllDataTab() {
    if (_allHealthData.isEmpty) {
      return Center(child: Text('No health data available'));
    }

    return ListView.separated(
      padding: EdgeInsets.all(16),
      itemCount: _allHealthData.length,
      separatorBuilder: (context, index) => SizedBox(height: 8),
      itemBuilder: (context, index) {
        final point = _allHealthData[index];
        return Card(
          child: ListTile(
            leading: _getHealthTypeIcon(point.type),
            title: Text(
              _formatHealthTypeName(point.type),
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Value: ${_formatHealthValue(point)}'),
                Text('Source: ${point.sourceName}'),
                Text('Date: ${_formatDateTime(point.dateFrom)}'),
              ],
            ),
            isThreeLine: true,
            dense: true,
          ),
        );
      },
    );
  }

  Widget _buildCategorizedTab() {
    if (_categorizedData.isEmpty) {
      return Center(child: Text('No categorized data available'));
    }

    return ListView.builder(
      padding: EdgeInsets.all(16),
      itemCount: _categorizedData.keys.length,
      itemBuilder: (context, index) {
        final type = _categorizedData.keys.elementAt(index);
        final dataPoints = _categorizedData[type]!;

        return Card(
          margin: EdgeInsets.only(bottom: 16),
          child: ExpansionTile(
            leading: _getHealthTypeIcon(type),
            title: Text(
              _formatHealthTypeName(type),
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            subtitle: Text('${dataPoints.length} data points'),
            children:
                dataPoints.take(5).map((point) {
                  return ListTile(
                    dense: true,
                    title: Text(_formatHealthValue(point)),
                    subtitle: Text(
                      '${_formatDateTime(point.dateFrom)} • ${point.sourceName}',
                      style: TextStyle(fontSize: 12),
                    ),
                  );
                }).toList() +
                [
                  if (dataPoints.length > 5)
                    ListTile(
                      dense: true,
                      title: Text(
                        'Show all ${dataPoints.length} items',
                        style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      onTap: () => _showDataTypeDetails(type, dataPoints),
                    ),
                ],
          ),
        );
      },
    );
  }

  Widget _buildStatisticsTab() {
    if (_categorizedData.isEmpty) {
      return Center(child: Text('No statistics available'));
    }

    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        children: [
          _buildHealthStatistics(),
          SizedBox(height: 16),
          _buildDataSourcesCard(),
        ],
      ),
    );
  }

  Widget _buildHealthStatistics() {
    return Card(
      elevation: 4,
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Health Data Statistics',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            SizedBox(height: 16),
            Text('Total Data Points: ${_allHealthData.length}'),
            SizedBox(height: 8),
            Text('Data Types: ${_categorizedData.keys.length}'),
            SizedBox(height: 8),
            Text('Date Range: ${_getDataDateRange()}'),
            SizedBox(height: 16),
            Text(
              'Top Data Types:',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            SizedBox(height: 8),
            ..._getTopDataTypes().map((entry) {
              return Padding(
                padding: EdgeInsets.symmetric(vertical: 2),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(_formatHealthTypeName(entry.key)),
                    Text('${entry.value} points'),
                  ],
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildDataSourcesCard() {
    final sources = <String, int>{};
    for (var point in _allHealthData) {
      sources[point.sourceName] = (sources[point.sourceName] ?? 0) + 1;
    }

    final sortedSources = sources.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return Card(
      elevation: 4,
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Data Sources', style: Theme.of(context).textTheme.titleLarge),
            SizedBox(height: 16),
            ...sortedSources.map((entry) {
              final percentage = (entry.value / _allHealthData.length * 100)
                  .toStringAsFixed(1);
              return Padding(
                padding: EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: Text(
                        entry.key,
                        style: TextStyle(fontSize: 14),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Text(
                        '${entry.value} ($percentage%)',
                        textAlign: TextAlign.right,
                        style: TextStyle(fontSize: 12),
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }

  void _showDataTypeDetails(HealthDataType type, List<HealthDataPoint> points) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.7,
          maxChildSize: 0.9,
          minChildSize: 0.5,
          builder: (context, scrollController) {
            return Container(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      _getHealthTypeIcon(type),
                      SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          _formatHealthTypeName(type),
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                      ),
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: Icon(Icons.close),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  Text('${points.length} data points'),
                  SizedBox(height: 16),
                  Expanded(
                    child: ListView.separated(
                      controller: scrollController,
                      itemCount: points.length,
                      separatorBuilder: (context, index) => Divider(height: 1),
                      itemBuilder: (context, index) {
                        final point = points[index];
                        return ListTile(
                          title: Text(_formatHealthValue(point)),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Source: ${point.sourceName}'),
                              Text('Date: ${_formatDateTime(point.dateFrom)}'),
                              if (point.dateFrom != point.dateTo)
                                Text(
                                  'Duration: ${point.dateTo.difference(point.dateFrom).inMinutes} minutes',
                                ),
                            ],
                          ),
                          isThreeLine: true,
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _getHealthTypeIcon(HealthDataType type) {
    switch (type) {
      case HealthDataType.HEART_RATE:
        return Icon(Icons.favorite, color: Colors.red);
      case HealthDataType.RESTING_HEART_RATE:
        return Icon(Icons.favorite_border, color: Colors.red);
      case HealthDataType.WALKING_HEART_RATE:
        return Icon(Icons.favorite, color: Colors.pink);
      case HealthDataType.STEPS:
        return Icon(Icons.directions_walk, color: Colors.blue);
      case HealthDataType.ACTIVE_ENERGY_BURNED:
        return Icon(Icons.local_fire_department, color: Colors.orange);
      case HealthDataType.BASAL_ENERGY_BURNED:
        return Icon(Icons.local_fire_department, color: Colors.deepOrange);
      case HealthDataType.WORKOUT:
        return Icon(Icons.fitness_center, color: Colors.green);
      case HealthDataType.BLOOD_OXYGEN:
        return Icon(Icons.air, color: Colors.lightBlue);
      case HealthDataType.DISTANCE_WALKING_RUNNING:
        return Icon(Icons.straighten, color: Colors.purple);
      case HealthDataType.FLIGHTS_CLIMBED:
        return Icon(Icons.stairs, color: Colors.brown);
      case HealthDataType.SLEEP_ASLEEP:
        return Icon(Icons.bedtime, color: Colors.indigo);
      case HealthDataType.SLEEP_DEEP:
        return Icon(Icons.bedtime, color: Colors.deepPurple);
      case HealthDataType.SLEEP_LIGHT:
        return Icon(Icons.bedtime_off, color: Colors.purple);
      case HealthDataType.SLEEP_REM:
        return Icon(Icons.bedtime, color: Colors.cyan);
      case HealthDataType.BODY_TEMPERATURE:
        return Icon(Icons.thermostat, color: Colors.red);
      case HealthDataType.RESPIRATORY_RATE:
        return Icon(Icons.air, color: Colors.teal);
      default:
        return Icon(Icons.health_and_safety, color: Colors.grey);
    }
  }

  String _formatHealthTypeName(HealthDataType type) {
    return type
        .toString()
        .split('.')[1]
        .replaceAll('_', ' ')
        .toLowerCase()
        .split(' ')
        .map(
          (word) =>
              word.isEmpty ? word : word[0].toUpperCase() + word.substring(1),
        )
        .join(' ');
  }

  String _formatHealthValue(HealthDataPoint point) {
    if (point.value is NumericHealthValue) {
      final numValue = (point.value as NumericHealthValue).numericValue;
      return '${numValue.toStringAsFixed(1)} ${point.unit.toString().split('.')[1]}';
    }
    return point.value.toString();
  }

  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.day}/${dateTime.month}/${dateTime.year} ${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';
  }

  String _getDataDateRange() {
    if (_allHealthData.isEmpty) return 'N/A';

    final dates = _allHealthData.map((p) => p.dateFrom).toList()..sort();

    final earliest = dates.first;
    final latest = dates.last;

    return '${_formatDateTime(earliest)} - ${_formatDateTime(latest)}';
  }

  List<MapEntry<HealthDataType, int>> _getTopDataTypes() {
    return _categorizedData.entries
        .map((e) => MapEntry(e.key, e.value.length))
        .toList()
      ..sort((a, b) => b.value.compareTo(a.value))
      ..take(5);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Apple Watch Health Data'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        bottom: _allHealthData.isNotEmpty
            ? TabBar(
                controller: _tabController,
                labelColor: Colors.white,
                unselectedLabelColor: Colors.white70,
                indicatorColor: Colors.white,
                tabs: [
                  Tab(text: 'Overview', icon: Icon(Icons.dashboard, size: 16)),
                  Tab(text: 'All Data', icon: Icon(Icons.list, size: 16)),
                  Tab(text: 'Categories', icon: Icon(Icons.category, size: 16)),
                  Tab(
                    text: 'Statistics',
                    icon: Icon(Icons.analytics, size: 16),
                  ),
                ],
              )
            : null,
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              children: [
                _buildStatusCard(),
                SizedBox(height: 16),
                _buildActionButtons(),
                if (_isLoading) ...[
                  SizedBox(height: 16),
                  CircularProgressIndicator(),
                  SizedBox(height: 8),
                  Text('Loading comprehensive health data...'),
                ],
              ],
            ),
          ),
          if (_allHealthData.isNotEmpty)
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildOverviewTab(),
                  _buildAllDataTab(),
                  _buildCategorizedTab(),
                  _buildStatisticsTab(),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
