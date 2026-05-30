import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

const String _flightStorageKey = 'skylog_flights';
const String _checklistStorageKey = 'skylog_preflight_checklist';
const String _languageStorageKey = 'skylog_language';
const String _appVersionLabel = 'SkyLog v3.5';
const String _appStageLabel = 'Local Draft Summary';
const int _preFlightChecklistTotal = 6;

enum AppLanguage { english, chinese }

String _text(AppLanguage language, String english, String chinese) {
  return language == AppLanguage.chinese ? chinese : english;
}

AppLanguage _languageFromCode(String? code) {
  return code == 'zh' ? AppLanguage.chinese : AppLanguage.english;
}

String _languageCode(AppLanguage language) {
  return language == AppLanguage.chinese ? 'zh' : 'en';
}

const List<String> _preFlightChecklistItems = [
  'Battery charged and locked in',
  'Propellers clean and attached',
  'Weather and wind checked',
  'Takeoff area is clear',
  'Return-to-home point confirmed',
  'Storage card has space',
];

int _durationMinutesFor(String duration) {
  final match = RegExp(r'\d+').firstMatch(duration);
  return match == null ? 0 : int.parse(match.group(0)!);
}

String _formatMinutes(int totalMinutes) {
  final hours = totalMinutes ~/ 60;
  final remainingMinutes = totalMinutes % 60;
  if (hours == 0) {
    return '${remainingMinutes}m';
  }
  if (remainingMinutes == 0) {
    return '${hours}h';
  }
  return '${hours}h ${remainingMinutes}m';
}

class FlightRecord {
  const FlightRecord({
    required this.title,
    required this.location,
    this.latitude,
    this.longitude,
    required this.date,
    required this.duration,
    required this.drone,
    required this.weather,
    required this.mediaType,
    required this.mediaPath,
    required this.mediaCaption,
    required this.purpose,
    required this.summary,
    required this.issues,
    required this.improvements,
    this.checklistCompleted = 0,
    this.checklistTotal = _preFlightChecklistTotal,
  });

  final String title;
  final String location;
  final double? latitude;
  final double? longitude;
  final String date;
  final String duration;
  final String drone;
  final String weather;
  final String mediaType;
  final String mediaPath;
  final String mediaCaption;
  final String purpose;
  final String summary;
  final String issues;
  final String improvements;
  final int checklistCompleted;
  final int checklistTotal;

  String get checklistLabel {
    if (checklistTotal == 0) {
      return 'No checklist saved';
    }

    return '$checklistCompleted/$checklistTotal checks';
  }

  bool get wasChecklistComplete {
    return checklistTotal > 0 && checklistCompleted >= checklistTotal;
  }

  bool get hasCoordinates {
    return latitude != null && longitude != null;
  }

  String get coordinateLabel {
    if (!hasCoordinates) {
      return 'Coordinates not set';
    }

    return '${latitude!.toStringAsFixed(4)}, ${longitude!.toStringAsFixed(4)}';
  }

  bool get hasMedia {
    return mediaPath.isNotEmpty || mediaCaption.isNotEmpty;
  }

  String get mediaLabel {
    if (!hasMedia) {
      return 'No media linked';
    }
    if (mediaPath.isEmpty) {
      return mediaType;
    }

    return '$mediaType - $mediaPath';
  }

  Map<String, Object?> toJson() {
    return {
      'title': title,
      'location': location,
      'latitude': latitude,
      'longitude': longitude,
      'date': date,
      'duration': duration,
      'drone': drone,
      'weather': weather,
      'mediaType': mediaType,
      'mediaPath': mediaPath,
      'mediaCaption': mediaCaption,
      'purpose': purpose,
      'summary': summary,
      'issues': issues,
      'improvements': improvements,
      'checklistCompleted': checklistCompleted,
      'checklistTotal': checklistTotal,
    };
  }

  factory FlightRecord.fromJson(Map<String, dynamic> json) {
    return FlightRecord(
      title: json['title'] as String? ?? '',
      location: json['location'] as String? ?? '',
      latitude: _readDouble(json['latitude']),
      longitude: _readDouble(json['longitude']),
      date: json['date'] as String? ?? '',
      duration: json['duration'] as String? ?? '',
      drone: json['drone'] as String? ?? '',
      weather: json['weather'] as String? ?? '',
      mediaType: json['mediaType'] as String? ?? 'Photo',
      mediaPath: json['mediaPath'] as String? ?? '',
      mediaCaption: json['mediaCaption'] as String? ?? '',
      purpose: json['purpose'] as String? ?? '',
      summary: json['summary'] as String? ?? '',
      issues: json['issues'] as String? ?? '',
      improvements: json['improvements'] as String? ?? '',
      checklistCompleted: json['checklistCompleted'] as int? ?? 0,
      checklistTotal:
          json['checklistTotal'] as int? ?? _preFlightChecklistTotal,
    );
  }

  static double? _readDouble(Object? value) {
    if (value is num) {
      return value.toDouble();
    }
    if (value is String) {
      return double.tryParse(value);
    }
    return null;
  }
}

List<FlightRecord> _demoFlights() {
  return [
    const FlightRecord(
      title: 'Coastal sunset practice',
      location: 'Qingdao coast',
      latitude: 36.0671,
      longitude: 120.3826,
      date: 'May 24, 2026',
      duration: '24 min',
      drone: 'DJI Mini 4 Pro',
      weather: 'Cloudy - Wind level 4',
      mediaType: 'Video',
      mediaPath: 'coastal-sunset-orbit.mp4',
      mediaCaption: 'Best clip is the low coastal tracking shot.',
      purpose: 'Practice smooth coastal tracking shots for a short reel.',
      checklistCompleted: 6,
      checklistTotal: 6,
      summary:
          'Good low-altitude tracking practice, but wind affected stability.',
      issues: 'Crosswind made the last orbit less stable than planned.',
      improvements: 'Check wind direction earlier and keep wider safety space.',
    ),
    const FlightRecord(
      title: 'Mountain overlook test',
      location: 'Laoshan overlook',
      latitude: 36.1951,
      longitude: 120.5963,
      date: 'May 19, 2026',
      duration: '18 min',
      drone: 'DJI Mini 4 Pro',
      weather: 'Sunny - Light wind',
      mediaType: 'Photo',
      mediaPath: 'mountain-overlook-cover.jpg',
      mediaCaption: 'Wide establishing frame for the flight cover.',
      purpose: 'Test a wide opening shot from a safe overlook.',
      checklistCompleted: 6,
      checklistTotal: 6,
      summary: 'Tested wide establishing shots and safe return path.',
      issues: 'Exposure changed too quickly when turning toward the sun.',
      improvements: 'Lock exposure before starting the main camera move.',
    ),
    const FlightRecord(
      title: 'City park framing practice',
      location: 'Central park field',
      latitude: 36.0798,
      longitude: 120.3451,
      date: 'May 12, 2026',
      duration: '31 min',
      drone: 'DJI Mini 3',
      weather: 'Cloudy - Calm',
      mediaType: 'Cover',
      mediaPath: 'park-reveal-cover.jpg',
      mediaCaption: 'Simple cover frame for framing practice.',
      purpose: 'Improve framing and slow reveal timing in an open field.',
      checklistCompleted: 5,
      checklistTotal: 6,
      summary: 'Practiced slow reveal shots and smoother yaw control.',
      issues: 'One checklist item was missed before takeoff.',
      improvements: 'Finish the full pre-flight checklist before recording.',
    ),
  ];
}

void main() {
  runApp(const SkyLogApp());
}

class SkyLogApp extends StatelessWidget {
  const SkyLogApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SkyLog',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF1D7373),
          brightness: Brightness.light,
        ),
        scaffoldBackgroundColor: const Color(0xFFF6F8F7),
        useMaterial3: true,
      ),
      home: const MainShell(),
    );
  }
}

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _selectedIndex = 0;
  bool _isLoading = true;
  AppLanguage _language = AppLanguage.english;

  final List<FlightRecord> _flights = _demoFlights();
  final Set<int> _completedChecklistItems = {};

  @override
  void initState() {
    super.initState();
    _loadFlights();
  }

  Future<void> _loadFlights() async {
    final preferences = await SharedPreferences.getInstance();
    final savedFlights = preferences.getString(_flightStorageKey);
    final savedChecklist = preferences.getStringList(_checklistStorageKey);
    final savedLanguage = preferences.getString(_languageStorageKey);

    if (savedFlights == null) {
      if (!mounted) {
        return;
      }
      setState(() {
        _language = _languageFromCode(savedLanguage);
        _completedChecklistItems
          ..clear()
          ..addAll(_decodeChecklist(savedChecklist));
        _isLoading = false;
      });
      return;
    }

    List<FlightRecord> flights;
    try {
      final decoded = jsonDecode(savedFlights) as List<dynamic>;
      flights = decoded
          .map((item) => FlightRecord.fromJson(item as Map<String, dynamic>))
          .toList();
    } catch (_) {
      flights = [];
    }

    if (!mounted) {
      return;
    }
    setState(() {
      _language = _languageFromCode(savedLanguage);
      _flights
        ..clear()
        ..addAll(flights);
      _completedChecklistItems
        ..clear()
        ..addAll(_decodeChecklist(savedChecklist));
      _isLoading = false;
    });
  }

  Set<int> _decodeChecklist(List<String>? savedChecklist) {
    if (savedChecklist == null) {
      return {};
    }

    return savedChecklist
        .map(int.tryParse)
        .whereType<int>()
        .where((index) => index >= 0 && index < _preFlightChecklistItems.length)
        .toSet();
  }

  Future<void> _saveFlights() async {
    final preferences = await SharedPreferences.getInstance();
    final encoded = jsonEncode(
      _flights.map((flight) => flight.toJson()).toList(),
    );
    await preferences.setString(_flightStorageKey, encoded);
  }

  Future<void> _saveChecklist() async {
    final preferences = await SharedPreferences.getInstance();
    final encoded = _completedChecklistItems
        .map((index) => index.toString())
        .toList();
    await preferences.setStringList(_checklistStorageKey, encoded);
  }

  Future<void> _setLanguage(AppLanguage language) async {
    setState(() {
      _language = language;
    });
    final preferences = await SharedPreferences.getInstance();
    await preferences.setString(_languageStorageKey, _languageCode(language));
  }

  Future<void> _toggleChecklistItem(int index, bool isComplete) async {
    setState(() {
      if (isComplete) {
        _completedChecklistItems.add(index);
      } else {
        _completedChecklistItems.remove(index);
      }
    });
    await _saveChecklist();
  }

  Future<void> _resetChecklist() async {
    setState(() {
      _completedChecklistItems.clear();
    });
    await _saveChecklist();
  }

  void _selectTab(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Future<void> _addFlight(FlightRecord flight) async {
    setState(() {
      _flights.insert(0, flight);
      _completedChecklistItems.clear();
      _selectedIndex = 1;
    });
    await _saveFlights();
    await _saveChecklist();

    if (!mounted) {
      return;
    }

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Flight saved locally.')));
  }

  Future<void> _deleteFlight(FlightRecord flight) async {
    setState(() {
      _flights.remove(flight);
    });
    await _saveFlights();

    if (!mounted) {
      return;
    }

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Flight deleted.')));
  }

  Future<void> _updateFlight(
    FlightRecord oldFlight,
    FlightRecord newFlight,
  ) async {
    final index = _flights.indexOf(oldFlight);
    if (index == -1) {
      return;
    }

    setState(() {
      _flights[index] = newFlight;
    });
    await _saveFlights();

    if (!mounted) {
      return;
    }

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Flight updated.')));
  }

  Future<void> _resetDemoData() async {
    setState(() {
      _flights
        ..clear()
        ..addAll(_demoFlights());
      _selectedIndex = 0;
    });
    await _saveFlights();

    if (!mounted) {
      return;
    }

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Demo data reset.')));
  }

  @override
  Widget build(BuildContext context) {
    final screens = [
      DashboardScreen(
        flights: _flights,
        checklistCompleted: _completedChecklistItems.length,
        checklistTotal: _preFlightChecklistItems.length,
        onAddFlight: () => _selectTab(2),
        onOpenChecklist: () => _selectTab(3),
      ),
      FlightLogScreen(
        flights: _flights,
        onDelete: _deleteFlight,
        onUpdate: _updateFlight,
      ),
      AddFlightScreen(
        checklistCompleted: _completedChecklistItems.length,
        checklistTotal: _preFlightChecklistItems.length,
        onSave: _addFlight,
      ),
      PreFlightChecklistScreen(
        completedItems: _completedChecklistItems,
        onToggleItem: _toggleChecklistItem,
        onReset: _resetChecklist,
      ),
      FlightMapScreen(flights: _flights, onUpdate: _updateFlight),
      ProfileScreen(
        flights: _flights,
        language: _language,
        onLanguageChanged: _setLanguage,
        onResetDemoData: _resetDemoData,
      ),
    ];

    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      body: IndexedStack(index: _selectedIndex, children: screens),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: _selectTab,
        destinations: [
          NavigationDestination(
            icon: const Icon(Icons.dashboard_outlined),
            selectedIcon: const Icon(Icons.dashboard),
            label: _text(_language, 'Home', '首页'),
          ),
          NavigationDestination(
            icon: const Icon(Icons.list_alt_outlined),
            selectedIcon: const Icon(Icons.list_alt),
            label: _text(_language, 'Logs', '日志'),
          ),
          NavigationDestination(
            icon: const Icon(Icons.add_circle_outline),
            selectedIcon: const Icon(Icons.add_circle),
            label: _text(_language, 'Add', '添加'),
          ),
          NavigationDestination(
            icon: const Icon(Icons.fact_check_outlined),
            selectedIcon: const Icon(Icons.fact_check),
            label: _text(_language, 'Checklist', '检查'),
          ),
          NavigationDestination(
            icon: const Icon(Icons.map_outlined),
            selectedIcon: const Icon(Icons.map),
            label: _text(_language, 'Map', '地图'),
          ),
          NavigationDestination(
            icon: const Icon(Icons.person_outline),
            selectedIcon: const Icon(Icons.person),
            label: _text(_language, 'Profile', '我的'),
          ),
        ],
      ),
    );
  }
}

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({
    super.key,
    required this.flights,
    required this.checklistCompleted,
    required this.checklistTotal,
    required this.onAddFlight,
    required this.onOpenChecklist,
  });

  final List<FlightRecord> flights;
  final int checklistCompleted;
  final int checklistTotal;
  final VoidCallback onAddFlight;
  final VoidCallback onOpenChecklist;

  @override
  Widget build(BuildContext context) {
    final totalMinutes = _totalFlightMinutes(flights);

    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            const _DashboardHeader(),
            const SizedBox(height: 24),
            _RecentFlightCard(flight: flights.isEmpty ? null : flights.first),
            const SizedBox(height: 20),
            _StatsGrid(
              totalFlights: flights.length,
              totalMinutes: totalMinutes,
            ),
            const SizedBox(height: 20),
            _ChecklistProgressCard(
              completed: checklistCompleted,
              total: checklistTotal,
              onTap: onOpenChecklist,
            ),
            const SizedBox(height: 20),
            _QuickActions(
              onAddFlight: onAddFlight,
              onOpenChecklist: onOpenChecklist,
            ),
            const SizedBox(height: 20),
            _RecentLogs(flights: flights.take(2).toList()),
          ],
        ),
      ),
    );
  }

  int _totalFlightMinutes(List<FlightRecord> flights) {
    var total = 0;
    for (final flight in flights) {
      final match = RegExp(r'\d+').firstMatch(flight.duration);
      if (match != null) {
        total += int.parse(match.group(0)!);
      }
    }
    return total;
  }
}

class FlightLogScreen extends StatefulWidget {
  const FlightLogScreen({
    super.key,
    required this.flights,
    required this.onDelete,
    required this.onUpdate,
  });

  final List<FlightRecord> flights;
  final ValueChanged<FlightRecord> onDelete;
  final void Function(FlightRecord oldFlight, FlightRecord newFlight) onUpdate;

  @override
  State<FlightLogScreen> createState() => _FlightLogScreenState();
}

class _FlightLogScreenState extends State<FlightLogScreen> {
  final _searchController = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<FlightRecord> get _filteredFlights {
    final normalizedQuery = _query.trim().toLowerCase();
    if (normalizedQuery.isEmpty) {
      return widget.flights;
    }

    return widget.flights.where((flight) {
      final searchableText = [
        flight.title,
        flight.location,
        flight.coordinateLabel,
        flight.date,
        flight.duration,
        flight.drone,
        flight.weather,
        flight.mediaType,
        flight.mediaPath,
        flight.mediaCaption,
        flight.purpose,
        flight.summary,
        flight.issues,
        flight.improvements,
      ].join(' ').toLowerCase();

      return searchableText.contains(normalizedQuery);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final filteredFlights = _filteredFlights;

    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            const _ScreenTitle(
              title: 'Flight Logs',
              subtitle: 'Search and review every saved drone flight.',
            ),
            const SizedBox(height: 18),
            _SearchBar(
              controller: _searchController,
              onChanged: (value) {
                setState(() {
                  _query = value;
                });
              },
            ),
            const SizedBox(height: 18),
            if (widget.flights.isEmpty)
              const _EmptyLogs()
            else if (filteredFlights.isEmpty)
              _NoSearchResults(query: _query)
            else
              for (final flight in filteredFlights) ...[
                _FlightLogCard(
                  flight: flight,
                  onDelete: () => widget.onDelete(flight),
                  onUpdate: widget.onUpdate,
                ),
                const SizedBox(height: 12),
              ],
          ],
        ),
      ),
    );
  }
}

class AddFlightScreen extends StatefulWidget {
  const AddFlightScreen({
    super.key,
    required this.checklistCompleted,
    required this.checklistTotal,
    required this.onSave,
  });

  final int checklistCompleted;
  final int checklistTotal;
  final ValueChanged<FlightRecord> onSave;

  @override
  State<AddFlightScreen> createState() => _AddFlightScreenState();
}

class _AddFlightScreenState extends State<AddFlightScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController(text: 'New practice flight');
  final _locationController = TextEditingController(text: 'Qingdao coast');
  final _latitudeController = TextEditingController(text: '36.0671');
  final _longitudeController = TextEditingController(text: '120.3826');
  final _dateController = TextEditingController(text: 'May 27, 2026');
  final _durationController = TextEditingController(text: '24 min');
  final _droneController = TextEditingController(text: 'DJI Mini 4 Pro');
  final _weatherController = TextEditingController(
    text: 'Cloudy - Wind level 4',
  );
  final _mediaTypeController = TextEditingController(text: 'Video');
  final _mediaPathController = TextEditingController(
    text: 'coastal-sunset-orbit.mp4',
  );
  final _mediaCaptionController = TextEditingController(
    text: 'Best clip is the low coastal tracking shot.',
  );
  final _purposeController = TextEditingController(
    text: 'Practice smooth coastal tracking shots for a short reel.',
  );
  final _summaryController = TextEditingController(
    text:
        'Low-altitude movement looked good, but wind made some clips unstable.',
  );
  final _issuesController = TextEditingController(
    text: 'Wind made the orbit less stable than planned.',
  );
  final _improvementsController = TextEditingController(
    text: 'Check wind direction earlier and leave more safety space.',
  );

  @override
  void dispose() {
    _titleController.dispose();
    _locationController.dispose();
    _latitudeController.dispose();
    _longitudeController.dispose();
    _dateController.dispose();
    _durationController.dispose();
    _droneController.dispose();
    _weatherController.dispose();
    _mediaTypeController.dispose();
    _mediaPathController.dispose();
    _mediaCaptionController.dispose();
    _purposeController.dispose();
    _summaryController.dispose();
    _issuesController.dispose();
    _improvementsController.dispose();
    super.dispose();
  }

  void _saveFlight() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final title = _titleController.text.trim();
    widget.onSave(
      FlightRecord(
        title: title,
        location: _locationController.text.trim(),
        latitude: _parseOptionalCoordinate(_latitudeController.text),
        longitude: _parseOptionalCoordinate(_longitudeController.text),
        date: _dateController.text.trim(),
        duration: _durationController.text.trim(),
        drone: _droneController.text.trim(),
        weather: _weatherController.text.trim(),
        mediaType: _mediaTypeController.text.trim(),
        mediaPath: _mediaPathController.text.trim(),
        mediaCaption: _mediaCaptionController.text.trim(),
        purpose: _purposeController.text.trim(),
        summary: _summaryController.text.trim(),
        issues: _issuesController.text.trim(),
        improvements: _improvementsController.text.trim(),
        checklistCompleted: widget.checklistCompleted,
        checklistTotal: widget.checklistTotal,
      ),
    );
    _resetForm();
  }

  void _resetForm() {
    _titleController.text = 'New practice flight';
    _locationController.clear();
    _latitudeController.clear();
    _longitudeController.clear();
    _dateController.text = 'May 27, 2026';
    _durationController.clear();
    _droneController.text = 'DJI Mini 4 Pro';
    _weatherController.clear();
    _mediaTypeController.text = 'Photo';
    _mediaPathController.clear();
    _mediaCaptionController.clear();
    _purposeController.clear();
    _summaryController.clear();
    _issuesController.clear();
    _improvementsController.clear();
  }

  double? _parseOptionalCoordinate(String value) {
    final trimmedValue = value.trim();
    if (trimmedValue.isEmpty) {
      return null;
    }

    return double.tryParse(trimmedValue);
  }

  String? _validateOptionalCoordinate(String? value) {
    final trimmedValue = value?.trim() ?? '';
    if (trimmedValue.isEmpty) {
      return null;
    }
    if (double.tryParse(trimmedValue) == null) {
      return 'Enter a valid number or leave this blank.';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const _ScreenTitle(
                  title: 'Add Flight',
                  subtitle:
                      'Capture the core details while the flight is still fresh.',
                ),
                const SizedBox(height: 18),
                _AddFlightChecklistSummary(
                  completed: widget.checklistCompleted,
                  total: widget.checklistTotal,
                ),
                const SizedBox(height: 18),
                const _FormSectionTitle('Basic Info'),
                const SizedBox(height: 10),
                _FlightTextField(
                  label: 'Title',
                  controller: _titleController,
                  requiredMessage: 'Add a short title for this flight.',
                ),
                const SizedBox(height: 10),
                _FlightTextField(
                  label: 'Location',
                  controller: _locationController,
                  requiredMessage: 'Location is required.',
                ),
                const SizedBox(height: 10),
                _FlightTextField(
                  label: 'Latitude',
                  controller: _latitudeController,
                  validator: _validateOptionalCoordinate,
                ),
                const SizedBox(height: 10),
                _FlightTextField(
                  label: 'Longitude',
                  controller: _longitudeController,
                  validator: _validateOptionalCoordinate,
                ),
                const SizedBox(height: 10),
                _FlightTextField(label: 'Date', controller: _dateController),
                const SizedBox(height: 10),
                _FlightTextField(
                  label: 'Duration',
                  controller: _durationController,
                  requiredMessage: 'Flight duration is required.',
                ),
                const SizedBox(height: 18),
                const _FormSectionTitle('Flight Context'),
                const SizedBox(height: 10),
                _FlightTextField(label: 'Drone', controller: _droneController),
                const SizedBox(height: 10),
                _FlightTextField(
                  label: 'Weather',
                  controller: _weatherController,
                ),
                const SizedBox(height: 18),
                const _FormSectionTitle('Media Metadata'),
                const SizedBox(height: 10),
                _FlightTextField(
                  label: 'Media Type',
                  controller: _mediaTypeController,
                ),
                const SizedBox(height: 10),
                _FlightTextField(
                  label: 'Media Path',
                  controller: _mediaPathController,
                ),
                const SizedBox(height: 10),
                _FlightTextField(
                  label: 'Media Caption',
                  controller: _mediaCaptionController,
                  maxLines: 2,
                ),
                const SizedBox(height: 18),
                const _FormSectionTitle('Creative Review'),
                const SizedBox(height: 10),
                _FlightTextField(
                  label: 'Purpose',
                  controller: _purposeController,
                  maxLines: 2,
                ),
                const SizedBox(height: 10),
                _FlightTextField(
                  label: 'Summary',
                  controller: _summaryController,
                  maxLines: 3,
                ),
                const SizedBox(height: 10),
                _FlightTextField(
                  label: 'Issues',
                  controller: _issuesController,
                  maxLines: 2,
                ),
                const SizedBox(height: 10),
                _FlightTextField(
                  label: 'Next Improvements',
                  controller: _improvementsController,
                  maxLines: 2,
                ),
                const SizedBox(height: 18),
                FilledButton.icon(
                  key: const Key('save-flight-button'),
                  onPressed: _saveFlight,
                  icon: const Icon(Icons.save_outlined),
                  label: const Text('Save Flight'),
                  style: FilledButton.styleFrom(
                    minimumSize: const Size.fromHeight(52),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class PreFlightChecklistScreen extends StatelessWidget {
  const PreFlightChecklistScreen({
    super.key,
    required this.completedItems,
    required this.onToggleItem,
    required this.onReset,
  });

  final Set<int> completedItems;
  final void Function(int index, bool isComplete) onToggleItem;
  final VoidCallback onReset;

  @override
  Widget build(BuildContext context) {
    final completedCount = completedItems.length;
    final totalCount = _preFlightChecklistItems.length;
    final isReady = completedCount == totalCount;

    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            const _ScreenTitle(
              title: 'Pre-flight Checklist',
              subtitle: 'Confirm the basics before every drone flight.',
            ),
            const SizedBox(height: 18),
            _ChecklistStatusCard(
              completed: completedCount,
              total: totalCount,
              isReady: isReady,
            ),
            const SizedBox(height: 18),
            for (
              var index = 0;
              index < _preFlightChecklistItems.length;
              index++
            )
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: _ChecklistItemTile(
                  title: _preFlightChecklistItems[index],
                  isComplete: completedItems.contains(index),
                  onChanged: (value) => onToggleItem(index, value ?? false),
                ),
              ),
            const SizedBox(height: 8),
            OutlinedButton.icon(
              key: const Key('reset-checklist-button'),
              onPressed: completedItems.isEmpty ? null : onReset,
              icon: const Icon(Icons.restart_alt),
              label: const Text('Reset Checklist'),
              style: OutlinedButton.styleFrom(
                minimumSize: const Size.fromHeight(52),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AddFlightChecklistSummary extends StatelessWidget {
  const _AddFlightChecklistSummary({
    required this.completed,
    required this.total,
  });

  final int completed;
  final int total;

  @override
  Widget build(BuildContext context) {
    final isReady = total > 0 && completed >= total;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isReady ? const Color(0xFFE6F5EE) : const Color(0xFFFFF8E6),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isReady ? const Color(0xFF7DBFA4) : const Color(0xFFE5C875),
        ),
      ),
      child: Row(
        children: [
          Icon(
            isReady ? Icons.check_circle_outline : Icons.warning_amber,
            color: isReady ? const Color(0xFF1D7373) : const Color(0xFF856A16),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isReady ? 'Checklist complete' : 'Checklist not complete',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: const Color(0xFF123737),
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'This flight will save $completed of $total pre-flight checks.',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: const Color(0xFF647B7A),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class FlightMapScreen extends StatelessWidget {
  const FlightMapScreen({
    super.key,
    required this.flights,
    required this.onUpdate,
  });

  final List<FlightRecord> flights;
  final void Function(FlightRecord oldFlight, FlightRecord newFlight) onUpdate;

  List<FlightRecord> get _mappedFlights {
    return flights.where((flight) => flight.hasCoordinates).toList();
  }

  @override
  Widget build(BuildContext context) {
    final mappedFlights = _mappedFlights;

    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            const _ScreenTitle(
              title: 'Flight Map',
              subtitle:
                  'Review recorded flight coordinates and map-ready logs.',
            ),
            const SizedBox(height: 18),
            _MapPreview(flights: mappedFlights),
            const SizedBox(height: 18),
            _MapStatsRow(
              totalFlights: flights.length,
              mappedFlights: mappedFlights.length,
            ),
            const SizedBox(height: 18),
            if (mappedFlights.isEmpty)
              const _LocationSummary(
                title: 'No mapped flights yet',
                subtitle: 'Add latitude and longitude to a flight record.',
              )
            else
              for (final flight in mappedFlights) ...[
                _LocationSummary(
                  title: flight.location,
                  subtitle: '${flight.coordinateLabel} - ${flight.title}',
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (_) => FlightDetailScreen(
                          flight: flight,
                          onUpdate: onUpdate,
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 10),
              ],
          ],
        ),
      ),
    );
  }
}

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({
    super.key,
    required this.flights,
    required this.language,
    required this.onLanguageChanged,
    required this.onResetDemoData,
  });

  final List<FlightRecord> flights;
  final AppLanguage language;
  final ValueChanged<AppLanguage> onLanguageChanged;
  final VoidCallback onResetDemoData;

  int get _totalFlightMinutes {
    var total = 0;
    for (final flight in flights) {
      total += _durationMinutesFor(flight.duration);
    }
    return total;
  }

  int get _mappedFlightCount {
    return flights.where((flight) => flight.hasCoordinates).length;
  }

  int get _mediaFlightCount {
    return flights.where((flight) => flight.hasMedia).length;
  }

  String get _primaryDrone {
    final counts = <String, int>{};
    for (final flight in flights) {
      final drone = flight.drone.trim();
      if (drone.isEmpty) {
        continue;
      }
      counts[drone] = (counts[drone] ?? 0) + 1;
    }

    if (counts.isEmpty) {
      return 'No drone yet';
    }

    final sortedEntries = counts.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    return sortedEntries.first.key;
  }

  List<_DroneProfileSummary> get _droneProfiles {
    final summaries = <String, _DroneProfileSummary>{};
    for (final flight in flights) {
      final drone = flight.drone.trim();
      if (drone.isEmpty) {
        continue;
      }
      summaries.putIfAbsent(drone, () => _DroneProfileSummary(model: drone));
      summaries[drone]!.addFlight(flight);
    }

    final profiles = summaries.values.toList()
      ..sort((a, b) {
        final flightComparison = b.totalFlights.compareTo(a.totalFlights);
        if (flightComparison != 0) {
          return flightComparison;
        }
        return b.totalMinutes.compareTo(a.totalMinutes);
      });
    return profiles;
  }

  String _buildExportJson() {
    const encoder = JsonEncoder.withIndent('  ');
    return encoder.convert({
      'app': 'SkyLog',
      'version': _appVersionLabel,
      'exportedAt': DateTime.now().toIso8601String(),
      'flights': flights.map((flight) => flight.toJson()).toList(),
    });
  }

  String _buildExportCsv() {
    final rows = <List<String>>[
      [
        'Title',
        'Location',
        'Latitude',
        'Longitude',
        'Date',
        'Duration',
        'Drone',
        'Weather',
        'Media Type',
        'Media Path',
        'Media Caption',
        'Purpose',
        'Summary',
        'Issues',
        'Next Improvements',
        'Checklist',
      ],
      for (final flight in flights)
        [
          flight.title,
          flight.location,
          flight.latitude?.toStringAsFixed(4) ?? '',
          flight.longitude?.toStringAsFixed(4) ?? '',
          flight.date,
          flight.duration,
          flight.drone,
          flight.weather,
          flight.mediaType,
          flight.mediaPath,
          flight.mediaCaption,
          flight.purpose,
          flight.summary,
          flight.issues,
          flight.improvements,
          flight.checklistLabel,
        ],
    ];

    return rows.map((row) => row.map(_escapeCsvCell).join(',')).join('\n');
  }

  String _escapeCsvCell(String value) {
    final shouldQuote =
        value.contains(',') || value.contains('"') || value.contains('\n');
    final escapedValue = value.replaceAll('"', '""');
    return shouldQuote ? '"$escapedValue"' : escapedValue;
  }

  String _buildFeedbackTemplate() {
    return '''
SkyLog Beta Feedback

Version: $_appVersionLabel
Flight records during test: ${flights.length}

1. What did you think SkyLog was for after the first minute?
2. Was the pre-flight checklist useful or unnecessary?
3. Was adding a flight record easy to understand?
4. Which field felt most useful?
5. Which field felt confusing or unnecessary?
6. Was the Logs screen easy to scan?
7. Did the Detail screen show enough information?
8. What would make you trust this app more?
9. What is one thing you liked?
10. What is one thing you would change before a wider beta?
'''
        .trim();
  }

  Future<void> _exportJson(BuildContext context) async {
    final exportJson = _buildExportJson();
    var copiedToClipboard = true;
    try {
      await Clipboard.setData(ClipboardData(text: exportJson));
    } catch (_) {
      copiedToClipboard = false;
    }

    if (!context.mounted) {
      return;
    }

    await showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            copiedToClipboard ? 'JSON Backup Copied' : 'JSON Backup Ready',
          ),
          content: SingleChildScrollView(
            child: Text(
              exportJson,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Done'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _exportCsv(BuildContext context) async {
    final exportCsv = _buildExportCsv();
    var copiedToClipboard = true;
    try {
      await Clipboard.setData(ClipboardData(text: exportCsv));
    } catch (_) {
      copiedToClipboard = false;
    }

    if (!context.mounted) {
      return;
    }

    await showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            copiedToClipboard ? 'CSV Table Copied' : 'CSV Table Ready',
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('CSV rows: ${flights.length}'),
              const SizedBox(height: 8),
              const Text(
                'Columns: Title, Location, Latitude, Longitude, Date, Duration',
              ),
              const SizedBox(height: 12),
              Flexible(
                child: SingleChildScrollView(
                  child: Text(
                    exportCsv,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Done'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _showPrivacyNote(BuildContext context) async {
    await showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Privacy and Local Data'),
          content: const Text(
            'SkyLog stores flight records on this device for the current beta. '
            'It does not create an account, upload records, or sync data to a '
            'cloud service. Export JSON Backup lets you copy your records when '
            'you want your own backup.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Done'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _showBetaNote(BuildContext context) async {
    await showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('About This Beta'),
          content: const Text(
            'SkyLog is a student-built beta for logging and reviewing drone '
            'flights. It is not a flight control app, official safety system, '
            'or replacement for local drone rules. Use it as a personal log and '
            'pre-flight reminder.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Done'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _copyFeedbackTemplate(BuildContext context) async {
    final template = _buildFeedbackTemplate();
    Clipboard.setData(ClipboardData(text: template)).ignore();

    await showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Feedback Template Ready'),
          content: SizedBox(
            width: double.maxFinite,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'SkyLog Beta Feedback',
                  style: Theme.of(
                    context,
                  ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 8),
                Flexible(
                  child: SingleChildScrollView(
                    child: Text(
                      template,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Done'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _showReleaseChecklist(BuildContext context) async {
    await showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Beta Release Checklist'),
          content: SingleChildScrollView(
            child: Text(
              '''
Before sharing SkyLog with a tester:

1. Reset demo data or create clean test records.
2. Complete the pre-flight checklist once.
3. Add a test flight and confirm it appears in Logs.
4. Open Detail and confirm checklist status is saved.
5. Export JSON Backup and confirm the dialog opens.
6. Open About This Beta and Privacy and Local Data.
7. Copy the Feedback Template.
8. Tell the tester data is local to their browser/device.
9. Tell the tester SkyLog is not a flight control or official safety app.
10. Record feedback in the project log after the test.
'''
                  .trim(),
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Done'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _showTesterInstructions(BuildContext context) async {
    await showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Tester Instructions'),
          content: SingleChildScrollView(
            child: Text(
              '''
Before testing:

- Use sample or non-sensitive flight data.
- Records stay local to this browser/device.
- Clearing browser data may remove saved records.
- SkyLog is not a flight control app or official safety system.

Please test:

1. Complete the pre-flight checklist.
2. Add a flight record.
3. Search for the record in Logs.
4. Open Detail and review checklist status.
5. Edit or delete a test record.
6. Export JSON Backup.
7. Copy the feedback template from Profile.

If the app looks messy, use Reset Demo Data in Profile.
'''
                  .trim(),
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Done'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _showTesterQuickStart(BuildContext context) async {
    await showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Tester Quick Start'),
          content: SingleChildScrollView(
            child: Text(
              '''
Start here if this is your first time testing SkyLog.

60-second test:

1. Open Home and check if the purpose is clear.
2. Open Checklist and complete the six items.
3. Open Add and create one sample flight.
4. Open Logs and find the sample flight.
5. Open Detail and check if the saved checklist status makes sense.
6. Return to Profile and copy the feedback template.

Please use sample data only. SkyLog stores records locally in this browser and is not a flight control or official safety app.
'''
                  .trim(),
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Done'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _showWebUpdateTips(BuildContext context) async {
    await showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Web Update Tips'),
          content: SingleChildScrollView(
            child: Text(
              '''
If SkyLog looks older than expected:

1. Refresh the page.
2. Open the link in a private/incognito window.
3. Try a different browser.
4. If needed, clear this site's browser data and reopen the link.

Why this happens:

SkyLog is a web app, so browsers may keep an older version cached for faster loading.

The fixed link stays the same:

https://houjue919.github.io/skylog/
'''
                  .trim(),
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Done'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _showDeploymentReadiness(BuildContext context) async {
    await showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Deployment Readiness'),
          content: SingleChildScrollView(
            child: Text(
              '''
Before publishing a fixed web link:

1. Run flutter analyze.
2. Run flutter test.
3. Run flutter build web.
4. Open the built web app locally.
5. Confirm Profile shows the current version.
6. Confirm local data/privacy notes are visible.
7. Confirm Tester Instructions are visible.
8. Confirm JSON Backup opens.
9. Share first with 3-5 trusted testers only.
10. Collect feedback before public posting.

Do not call this a public release yet. Treat it as a private beta link.
'''
                  .trim(),
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Done'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _showFixedWebBetaPath(BuildContext context) async {
    await showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Fixed Web Beta Path'),
          content: SingleChildScrollView(
            child: Text(
              '''
Recommended first fixed-link path:

1. Push SkyLog to a private or controlled GitHub repository.
2. Enable GitHub Pages with GitHub Actions as the source.
3. Run the Deploy SkyLog Web Beta workflow.
4. Share the resulting Pages URL with 3-5 trusted testers only.
5. Ask testers to read Tester Instructions first.
6. Collect feedback before posting anywhere public.

Important:

- The fixed link is still a private beta.
- Data remains local to each tester's browser/device.
- This is not a public release or official safety tool.
'''
                  .trim(),
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Done'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _showSmallBetaFeedbackPlan(BuildContext context) async {
    await showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Small Beta Feedback Plan'),
          content: SingleChildScrollView(
            child: Text(
              '''
Goal for v2.0:

Use the fixed SkyLog link to collect clear feedback from a small first group.

Who to ask:

- 2-3 regular users who can judge clarity and usability.
- 1-2 people interested in drones, photography, travel, or creative records.

What to ask them to test:

1. Open the fixed web link.
2. Read Tester Instructions.
3. Complete the checklist.
4. Add one sample flight.
5. Search for it in Logs.
6. Open Detail and review the saved checklist status.
7. Copy the feedback template.

Record feedback after each test in the project log before changing features.
'''
                  .trim(),
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Done'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _showAutomaticWebDeploy(BuildContext context) async {
    await showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Automatic Web Deploy'),
          content: SingleChildScrollView(
            child: Text(
              '''
SkyLog now updates the fixed web link automatically after stable changes are pushed to main.

Release flow:

1. Build the next small feature locally.
2. Run flutter analyze.
3. Run flutter test.
4. Run flutter build web.
5. Commit the stable version.
6. Push to main.
7. GitHub Actions deploys the web beta automatically.

Important:

- The URL stays the same.
- Only tested versions should be pushed to main.
- If the workflow fails, the previous working web version remains the fallback.
'''
                  .trim(),
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Done'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            _ScreenTitle(
              title: _text(language, 'Profile', '我的'),
              subtitle: _text(
                language,
                'Review beta status, data controls, and progress.',
                '查看测试状态、数据管理和项目进度。',
              ),
            ),
            const SizedBox(height: 18),
            _VersionBanner(language: language),
            const SizedBox(height: 18),
            _LanguageSelectorCard(
              language: language,
              onLanguageChanged: onLanguageChanged,
            ),
            const SizedBox(height: 18),
            const _PilotCard(),
            const SizedBox(height: 18),
            _ProfileStatsGrid(
              totalFlights: flights.length,
              totalMinutes: _totalFlightMinutes,
              mappedFlights: _mappedFlightCount,
              mediaFlights: _mediaFlightCount,
              primaryDrone: _primaryDrone,
            ),
            const SizedBox(height: 18),
            const _FormSectionTitle('My Drones'),
            const SizedBox(height: 10),
            _DroneSummaryList(droneProfiles: _droneProfiles),
            const SizedBox(height: 18),
            const _FormSectionTitle('Beta Testing'),
            const SizedBox(height: 10),
            _SettingsTile(
              key: const Key('tester-quick-start-button'),
              icon: Icons.playlist_add_check_circle_outlined,
              title: 'Tester Quick Start',
              subtitle: 'A short first-test path for new beta testers.',
              onTap: () => _showTesterQuickStart(context),
            ),
            const SizedBox(height: 10),
            _SettingsTile(
              key: const Key('tester-instructions-button'),
              icon: Icons.rule_folder_outlined,
              title: 'Tester Instructions',
              subtitle: 'Known limits and the flows testers should try.',
              onTap: () => _showTesterInstructions(context),
            ),
            const SizedBox(height: 10),
            _SettingsTile(
              key: const Key('web-update-tips-button'),
              icon: Icons.refresh_outlined,
              title: 'Web Update Tips',
              subtitle: 'What to do if the beta link shows an older version.',
              onTap: () => _showWebUpdateTips(context),
            ),
            const SizedBox(height: 10),
            _SettingsTile(
              key: const Key('copy-feedback-template-button'),
              icon: Icons.feedback_outlined,
              title: 'Copy Feedback Template',
              subtitle: 'Give testers clear questions after they try SkyLog.',
              onTap: () => _copyFeedbackTemplate(context),
            ),
            const SizedBox(height: 10),
            _SettingsTile(
              key: const Key('small-beta-feedback-plan-button'),
              icon: Icons.groups_2_outlined,
              title: 'Small Beta Feedback Plan',
              subtitle: 'Who should test v2.0 and what they should try.',
              onTap: () => _showSmallBetaFeedbackPlan(context),
            ),
            const SizedBox(height: 18),
            const _FormSectionTitle('Project Info'),
            const SizedBox(height: 10),
            _SettingsTile(
              key: const Key('about-beta-button'),
              icon: Icons.info_outline,
              title: 'About This Beta',
              subtitle: 'What SkyLog is ready for, and what it is not.',
              onTap: () => _showBetaNote(context),
            ),
            const SizedBox(height: 10),
            _SettingsTile(
              key: const Key('privacy-note-button'),
              icon: Icons.lock_outline,
              title: 'Privacy and Local Data',
              subtitle: 'Explain where beta flight records are stored.',
              onTap: () => _showPrivacyNote(context),
            ),
            const SizedBox(height: 18),
            const _FormSectionTitle('Release Tools'),
            const SizedBox(height: 10),
            _SettingsTile(
              key: const Key('beta-release-checklist-button'),
              icon: Icons.assignment_turned_in_outlined,
              title: 'Beta Release Checklist',
              subtitle: 'Run this before sharing SkyLog with a tester.',
              onTap: () => _showReleaseChecklist(context),
            ),
            const SizedBox(height: 10),
            _SettingsTile(
              key: const Key('deployment-readiness-button'),
              icon: Icons.cloud_upload_outlined,
              title: 'Deployment Readiness',
              subtitle: 'Checks required before creating a fixed web link.',
              onTap: () => _showDeploymentReadiness(context),
            ),
            const SizedBox(height: 10),
            _SettingsTile(
              key: const Key('automatic-web-deploy-button'),
              icon: Icons.sync_outlined,
              title: 'Automatic Web Deploy',
              subtitle: 'How stable pushes update the fixed beta link.',
              onTap: () => _showAutomaticWebDeploy(context),
            ),
            const SizedBox(height: 10),
            _SettingsTile(
              key: const Key('fixed-web-beta-path-button'),
              icon: Icons.link_outlined,
              title: 'Fixed Web Beta Path',
              subtitle: 'How the first stable tester link should be shared.',
              onTap: () => _showFixedWebBetaPath(context),
            ),
            const SizedBox(height: 18),
            const _FormSectionTitle('Data'),
            const SizedBox(height: 10),
            _BackupReportCard(
              totalFlights: flights.length,
              totalMinutes: _totalFlightMinutes,
              mappedFlights: _mappedFlightCount,
              mediaFlights: _mediaFlightCount,
            ),
            const SizedBox(height: 10),
            _SettingsTile(
              key: const Key('export-json-button'),
              icon: Icons.ios_share,
              title: 'Export JSON Backup',
              subtitle: 'Copy ${flights.length} flight records as JSON.',
              onTap: () => _exportJson(context),
            ),
            const SizedBox(height: 10),
            _SettingsTile(
              key: const Key('export-csv-button'),
              icon: Icons.table_chart_outlined,
              title: 'Export CSV Table',
              subtitle:
                  'Copy ${flights.length} records for spreadsheet review.',
              onTap: () => _exportCsv(context),
            ),
            const SizedBox(height: 10),
            _SettingsTile(
              key: const Key('reset-demo-data-button'),
              icon: Icons.restart_alt,
              title: 'Reset Demo Data',
              subtitle: 'Restore 3 clean sample records for screenshots.',
              onTap: onResetDemoData,
            ),
            const SizedBox(height: 10),
            const _SettingsTile(
              icon: Icons.settings_outlined,
              title: 'Settings',
              subtitle: 'Units, privacy, storage, and future sync options.',
            ),
          ],
        ),
      ),
    );
  }
}

class _ScreenTitle extends StatelessWidget {
  const _ScreenTitle({required this.title, required this.subtitle});

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.w800,
            color: const Color(0xFF123737),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          subtitle,
          style: Theme.of(
            context,
          ).textTheme.bodyLarge?.copyWith(color: const Color(0xFF5A6F6F)),
        ),
      ],
    );
  }
}

class _SearchBar extends StatelessWidget {
  const _SearchBar({required this.controller, required this.onChanged});

  final TextEditingController controller;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      onChanged: onChanged,
      decoration: InputDecoration(
        hintText: 'Search by title, location, drone, or weather',
        prefixIcon: const Icon(Icons.search),
        suffixIcon: controller.text.isEmpty
            ? null
            : IconButton(
                onPressed: () {
                  controller.clear();
                  onChanged('');
                },
                icon: const Icon(Icons.close),
                tooltip: 'Clear search',
              ),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFFE1E8E6)),
        ),
      ),
    );
  }
}

class _NoSearchResults extends StatelessWidget {
  const _NoSearchResults({required this.query});

  final String query;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFE1E8E6)),
      ),
      child: Column(
        children: [
          const Icon(Icons.search_off, size: 42, color: Color(0xFF1D7373)),
          const SizedBox(height: 12),
          Text(
            'No matching flights',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: const Color(0xFF123737),
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'No records match "$query". Try another title, location, drone, or weather.',
            textAlign: TextAlign.center,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: const Color(0xFF647B7A)),
          ),
        ],
      ),
    );
  }
}

class _EmptyLogs extends StatelessWidget {
  const _EmptyLogs();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFE1E8E6)),
      ),
      child: Column(
        children: [
          const Icon(Icons.flight_takeoff, size: 42, color: Color(0xFF1D7373)),
          const SizedBox(height: 12),
          Text(
            'No flight records yet',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: const Color(0xFF123737),
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Add your first flight to start building your SkyLog.',
            textAlign: TextAlign.center,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: const Color(0xFF647B7A)),
          ),
        ],
      ),
    );
  }
}

class _ChecklistStatusCard extends StatelessWidget {
  const _ChecklistStatusCard({
    required this.completed,
    required this.total,
    required this.isReady,
  });

  final int completed;
  final int total;
  final bool isReady;

  @override
  Widget build(BuildContext context) {
    final progress = total == 0 ? 0.0 : completed / total;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isReady ? const Color(0xFFE6F5EE) : Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isReady ? const Color(0xFF7DBFA4) : const Color(0xFFE1E8E6),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                isReady
                    ? Icons.check_circle_outline
                    : Icons.radio_button_unchecked,
                color: const Color(0xFF1D7373),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  isReady ? 'Ready to fly' : '$completed of $total complete',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: const Color(0xFF123737),
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          LinearProgressIndicator(
            value: progress,
            minHeight: 8,
            borderRadius: BorderRadius.circular(8),
            backgroundColor: const Color(0xFFE1E8E6),
          ),
          const SizedBox(height: 10),
          Text(
            isReady
                ? 'All safety basics are checked for this flight session.'
                : 'Work through the checklist before takeoff.',
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: const Color(0xFF647B7A)),
          ),
        ],
      ),
    );
  }
}

class _ChecklistItemTile extends StatelessWidget {
  const _ChecklistItemTile({
    required this.title,
    required this.isComplete,
    required this.onChanged,
  });

  final String title;
  final bool isComplete;
  final ValueChanged<bool?> onChanged;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: const Color(0xFFE1E8E6)),
        ),
        child: CheckboxListTile(
          value: isComplete,
          onChanged: onChanged,
          controlAffinity: ListTileControlAffinity.leading,
          activeColor: const Color(0xFF1D7373),
          title: Text(
            title,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: const Color(0xFF123737),
              fontWeight: isComplete ? FontWeight.w800 : FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}

class _FlightLogCard extends StatelessWidget {
  const _FlightLogCard({
    required this.flight,
    required this.onDelete,
    required this.onUpdate,
  });

  final FlightRecord flight;
  final VoidCallback onDelete;
  final void Function(FlightRecord oldFlight, FlightRecord newFlight) onUpdate;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute<void>(
              builder: (_) =>
                  FlightDetailScreen(flight: flight, onUpdate: onUpdate),
            ),
          );
        },
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: const Color(0xFFE1E8E6)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      flight.title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w800,
                        color: const Color(0xFF123737),
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: onDelete,
                    icon: const Icon(Icons.delete_outline),
                    color: const Color(0xFF9A4B4B),
                    tooltip: 'Delete flight',
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                '${flight.location} - ${flight.date}',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: const Color(0xFF647B7A),
                ),
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _InfoChip(icon: Icons.timer_outlined, label: flight.duration),
                  _InfoChip(icon: Icons.flight, label: flight.drone),
                  _InfoChip(icon: Icons.cloud_outlined, label: flight.weather),
                  if (flight.hasMedia)
                    _InfoChip(
                      icon: Icons.perm_media_outlined,
                      label: flight.mediaLabel,
                    ),
                  if (flight.purpose.isNotEmpty)
                    _InfoChip(icon: Icons.flag_outlined, label: flight.purpose),
                  _InfoChip(
                    icon: flight.wasChecklistComplete
                        ? Icons.check_circle_outline
                        : Icons.fact_check_outlined,
                    label: flight.checklistLabel,
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                flight.summary.isEmpty ? 'No summary yet.' : flight.summary,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: const Color(0xFF365150),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class FlightDetailScreen extends StatefulWidget {
  const FlightDetailScreen({
    super.key,
    required this.flight,
    required this.onUpdate,
  });

  final FlightRecord flight;
  final void Function(FlightRecord oldFlight, FlightRecord newFlight) onUpdate;

  @override
  State<FlightDetailScreen> createState() => _FlightDetailScreenState();
}

class _FlightDetailScreenState extends State<FlightDetailScreen> {
  late FlightRecord _flight;
  bool _isEditing = false;

  late final TextEditingController _titleController;
  late final TextEditingController _locationController;
  late final TextEditingController _latitudeController;
  late final TextEditingController _longitudeController;
  late final TextEditingController _dateController;
  late final TextEditingController _durationController;
  late final TextEditingController _droneController;
  late final TextEditingController _weatherController;
  late final TextEditingController _mediaTypeController;
  late final TextEditingController _mediaPathController;
  late final TextEditingController _mediaCaptionController;
  late final TextEditingController _purposeController;
  late final TextEditingController _summaryController;
  late final TextEditingController _issuesController;
  late final TextEditingController _improvementsController;

  @override
  void initState() {
    super.initState();
    _flight = widget.flight;
    _titleController = TextEditingController(text: _flight.title);
    _locationController = TextEditingController(text: _flight.location);
    _latitudeController = TextEditingController(
      text: _flight.latitude?.toString() ?? '',
    );
    _longitudeController = TextEditingController(
      text: _flight.longitude?.toString() ?? '',
    );
    _dateController = TextEditingController(text: _flight.date);
    _durationController = TextEditingController(text: _flight.duration);
    _droneController = TextEditingController(text: _flight.drone);
    _weatherController = TextEditingController(text: _flight.weather);
    _mediaTypeController = TextEditingController(text: _flight.mediaType);
    _mediaPathController = TextEditingController(text: _flight.mediaPath);
    _mediaCaptionController = TextEditingController(text: _flight.mediaCaption);
    _purposeController = TextEditingController(text: _flight.purpose);
    _summaryController = TextEditingController(text: _flight.summary);
    _issuesController = TextEditingController(text: _flight.issues);
    _improvementsController = TextEditingController(text: _flight.improvements);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _locationController.dispose();
    _latitudeController.dispose();
    _longitudeController.dispose();
    _dateController.dispose();
    _durationController.dispose();
    _droneController.dispose();
    _weatherController.dispose();
    _mediaTypeController.dispose();
    _mediaPathController.dispose();
    _mediaCaptionController.dispose();
    _purposeController.dispose();
    _summaryController.dispose();
    _issuesController.dispose();
    _improvementsController.dispose();
    super.dispose();
  }

  void _saveEdits() {
    final updatedFlight = FlightRecord(
      title: _titleController.text.trim(),
      location: _locationController.text.trim(),
      latitude: _parseOptionalCoordinate(_latitudeController.text),
      longitude: _parseOptionalCoordinate(_longitudeController.text),
      date: _dateController.text.trim(),
      duration: _durationController.text.trim(),
      drone: _droneController.text.trim(),
      weather: _weatherController.text.trim(),
      mediaType: _mediaTypeController.text.trim(),
      mediaPath: _mediaPathController.text.trim(),
      mediaCaption: _mediaCaptionController.text.trim(),
      purpose: _purposeController.text.trim(),
      summary: _summaryController.text.trim(),
      issues: _issuesController.text.trim(),
      improvements: _improvementsController.text.trim(),
      checklistCompleted: _flight.checklistCompleted,
      checklistTotal: _flight.checklistTotal,
    );

    widget.onUpdate(_flight, updatedFlight);
    setState(() {
      _flight = updatedFlight;
      _isEditing = false;
    });
  }

  double? _parseOptionalCoordinate(String value) {
    final trimmedValue = value.trim();
    if (trimmedValue.isEmpty) {
      return null;
    }

    return double.tryParse(trimmedValue);
  }

  String _buildAiPromptPreview() {
    return '''
You are helping a drone pilot write a concise, editable flight review draft.

Use only the flight record fields below. Do not invent safety facts, legal advice, or hidden flight data.

Flight title: ${_flight.title}
Location: ${_flight.location}
Date: ${_flight.date}
Duration: ${_flight.duration}
Drone: ${_flight.drone}
Weather: ${_flight.weather}
Checklist status: ${_flight.checklistLabel}
Purpose: ${_flight.purpose.isEmpty ? 'Not provided' : _flight.purpose}
Existing summary: ${_flight.summary.isEmpty ? 'Not provided' : _flight.summary}
Issues: ${_flight.issues.isEmpty ? 'Not provided' : _flight.issues}
Next improvements: ${_flight.improvements.isEmpty ? 'Not provided' : _flight.improvements}
Media caption: ${_flight.mediaCaption.isEmpty ? 'Not provided' : _flight.mediaCaption}

Return:
1. A 2-3 sentence flight summary draft.
2. One practical next improvement.
3. One reminder that this is not a flight safety system.
'''
        .trim();
  }

  String _valueOrFallback(String value, String fallback) {
    final trimmedValue = value.trim();
    return trimmedValue.isEmpty ? fallback : trimmedValue;
  }

  String _buildLocalDraftSummary() {
    final purpose = _valueOrFallback(
      _flight.purpose,
      'review this flight and preserve useful context',
    );
    final summary = _valueOrFallback(
      _flight.summary,
      'No previous summary was written.',
    );
    final issues = _valueOrFallback(
      _flight.issues,
      'No major issue was recorded.',
    );
    final improvements = _valueOrFallback(
      _flight.improvements,
      'Keep the next flight plan simple and review conditions before takeoff.',
    );
    final mediaCaption = _valueOrFallback(
      _flight.mediaCaption,
      'No media caption was recorded.',
    );

    return '''
Local draft summary

${_flight.title} was a ${_flight.duration} flight at ${_flight.location} using ${_flight.drone}. The recorded purpose was to $purpose. Conditions were noted as ${_flight.weather}, and the checklist status was ${_flight.checklistLabel}.

Review draft: $summary Media note: $mediaCaption

Issue to remember: $issues

Suggested next improvement: $improvements

This is a local rule-based draft, not AI output and not a flight safety system.
'''
        .trim();
  }

  Future<void> _showLocalDraftSummary(BuildContext context) async {
    final draftSummary = _buildLocalDraftSummary();

    await showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Local Draft Summary'),
          content: SingleChildScrollView(
            child: Text(
              draftSummary,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Done'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _showAiPromptPreview(BuildContext context) async {
    final promptPreview = _buildAiPromptPreview();

    await showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('AI Prompt Preview'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'No API call is made. This preview shows what a future AI summary feature could send.',
                ),
                const SizedBox(height: 12),
                const Text(
                  'Included fields: title, location, date, duration, drone, weather, checklist, purpose, summary, issues, improvements, media caption.',
                ),
                const SizedBox(height: 12),
                const Text(
                  'Not sent in this preview: photos, videos, API keys, account data, or exact map tiles.',
                ),
                const SizedBox(height: 12),
                Text(
                  promptPreview,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Done'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flight Detail'),
        actions: [
          TextButton.icon(
            onPressed: () {
              if (_isEditing) {
                _saveEdits();
              } else {
                setState(() {
                  _isEditing = true;
                });
              }
            },
            icon: Icon(_isEditing ? Icons.save_outlined : Icons.edit_outlined),
            label: Text(_isEditing ? 'Save' : 'Edit'),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          if (_isEditing)
            _FlightTextField(label: 'Title', controller: _titleController)
          else
            Text(
              _flight.title,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                color: const Color(0xFF123737),
                fontWeight: FontWeight.w800,
              ),
            ),
          const SizedBox(height: 8),
          if (_isEditing)
            _FlightTextField(label: 'Location', controller: _locationController)
          else
            Text(
              '${_flight.location} - ${_flight.date}',
              style: Theme.of(
                context,
              ).textTheme.bodyLarge?.copyWith(color: const Color(0xFF647B7A)),
            ),
          if (_isEditing) ...[
            const SizedBox(height: 10),
            _FlightTextField(label: 'Date', controller: _dateController),
          ],
          const SizedBox(height: 20),
          _DetailSection(
            title: 'Flight Data',
            children: _isEditing
                ? [
                    _FlightTextField(
                      label: 'Duration',
                      controller: _durationController,
                    ),
                    const SizedBox(height: 10),
                    _FlightTextField(
                      label: 'Drone',
                      controller: _droneController,
                    ),
                    const SizedBox(height: 10),
                    _FlightTextField(
                      label: 'Weather',
                      controller: _weatherController,
                    ),
                  ]
                : [
                    _DetailRow(label: 'Duration', value: _flight.duration),
                    _DetailRow(label: 'Drone', value: _flight.drone),
                    _DetailRow(label: 'Weather', value: _flight.weather),
                  ],
          ),
          const SizedBox(height: 16),
          _DetailSection(
            title: 'Pre-flight Checklist',
            children: [
              _DetailRow(label: 'Status', value: _flight.checklistLabel),
              _DetailRow(
                label: 'Result',
                value: _flight.wasChecklistComplete
                    ? 'Ready before takeoff'
                    : 'Not fully checked',
              ),
            ],
          ),
          const SizedBox(height: 16),
          _DetailSection(
            title: 'Media',
            children: _isEditing
                ? [
                    _FlightTextField(
                      label: 'Media Type',
                      controller: _mediaTypeController,
                    ),
                    const SizedBox(height: 10),
                    _FlightTextField(
                      label: 'Media Path',
                      controller: _mediaPathController,
                    ),
                    const SizedBox(height: 10),
                    _FlightTextField(
                      label: 'Media Caption',
                      controller: _mediaCaptionController,
                      maxLines: 3,
                    ),
                  ]
                : [
                    _DetailRow(label: 'Type', value: _flight.mediaType),
                    _DetailRow(label: 'Path', value: _flight.mediaPath),
                    _DetailRow(label: 'Caption', value: _flight.mediaCaption),
                    const SizedBox(height: 12),
                    _MediaPreview(flight: _flight),
                  ],
          ),
          const SizedBox(height: 16),
          _DetailSection(
            title: 'Map Location',
            children: [
              _DetailRow(label: 'Location', value: _flight.location),
              if (_isEditing) ...[
                const SizedBox(height: 10),
                _FlightTextField(
                  label: 'Latitude',
                  controller: _latitudeController,
                ),
                const SizedBox(height: 10),
                _FlightTextField(
                  label: 'Longitude',
                  controller: _longitudeController,
                ),
              ] else
                _DetailRow(
                  label: 'Coordinates',
                  value: _flight.coordinateLabel,
                ),
              const SizedBox(height: 12),
              _SmallMapPreview(flight: _flight),
            ],
          ),
          const SizedBox(height: 16),
          _DetailSection(
            title: 'Creative Review',
            children: _isEditing
                ? [
                    _FlightTextField(
                      label: 'Purpose',
                      controller: _purposeController,
                      maxLines: 2,
                    ),
                    const SizedBox(height: 10),
                    _FlightTextField(
                      label: 'Summary',
                      controller: _summaryController,
                      maxLines: 4,
                    ),
                    const SizedBox(height: 10),
                    _FlightTextField(
                      label: 'Issues',
                      controller: _issuesController,
                      maxLines: 3,
                    ),
                    const SizedBox(height: 10),
                    _FlightTextField(
                      label: 'Next Improvements',
                      controller: _improvementsController,
                      maxLines: 3,
                    ),
                  ]
                : [
                    _DetailRow(
                      label: 'Purpose',
                      value: _flight.purpose.isEmpty
                          ? 'No purpose has been added yet.'
                          : _flight.purpose,
                    ),
                    _DetailRow(
                      label: 'Summary',
                      value: _flight.summary.isEmpty
                          ? 'No summary has been added yet.'
                          : _flight.summary,
                    ),
                    _DetailRow(
                      label: 'Issues',
                      value: _flight.issues.isEmpty
                          ? 'No issues have been added yet.'
                          : _flight.issues,
                    ),
                    _DetailRow(
                      label: 'Next Improvements',
                      value: _flight.improvements.isEmpty
                          ? 'No next improvements have been added yet.'
                          : _flight.improvements,
                    ),
                  ],
          ),
          const SizedBox(height: 16),
          _DetailSection(
            title: 'AI Readiness',
            children: [
              const _DetailRow(
                label: 'Status',
                value:
                    'Prompt preview only. No network request or API key is used.',
              ),
              const SizedBox(height: 12),
              FilledButton.icon(
                key: const Key('ai-prompt-preview-button'),
                onPressed: () => _showAiPromptPreview(context),
                icon: const Icon(Icons.psychology_alt_outlined),
                label: const Text('Preview AI Prompt'),
              ),
              const SizedBox(height: 10),
              OutlinedButton.icon(
                key: const Key('local-draft-summary-button'),
                onPressed: () => _showLocalDraftSummary(context),
                icon: const Icon(Icons.edit_note_outlined),
                label: const Text('Generate Local Draft'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  const _InfoChip({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 260),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        color: const Color(0xFFEAF4F1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: const Color(0xFF1D7373)),
          const SizedBox(width: 6),
          Flexible(
            child: Text(
              label,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                color: const Color(0xFF123737),
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DetailSection extends StatelessWidget {
  const _DetailSection({required this.title, required this.children});

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFE1E8E6)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: const Color(0xFF123737),
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 12),
          ...children,
        ],
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 92,
            child: Text(
              label,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: const Color(0xFF647B7A),
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value.isEmpty ? 'Not set' : value,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: const Color(0xFF123737)),
            ),
          ),
        ],
      ),
    );
  }
}

class _SmallMapPreview extends StatelessWidget {
  const _SmallMapPreview({required this.flight});

  final FlightRecord flight;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120,
      decoration: BoxDecoration(
        color: const Color(0xFFDDEBE7),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFC9DCD8)),
      ),
      child: Stack(
        children: [
          const Positioned.fill(
            child: Icon(Icons.map_outlined, color: Color(0xFF89AAA5), size: 52),
          ),
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  flight.hasCoordinates
                      ? Icons.location_on
                      : Icons.location_off_outlined,
                  color: const Color(0xFF1D7373),
                  size: 34,
                ),
                const SizedBox(height: 6),
                Text(
                  flight.coordinateLabel,
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: const Color(0xFF123737),
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MediaPreview extends StatelessWidget {
  const _MediaPreview({required this.flight});

  final FlightRecord flight;

  @override
  Widget build(BuildContext context) {
    final hasMedia = flight.hasMedia;

    return Container(
      height: 116,
      decoration: BoxDecoration(
        color: const Color(0xFFEAF4F1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFC9DCD8)),
      ),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              hasMedia ? Icons.perm_media_outlined : Icons.image_not_supported,
              color: const Color(0xFF1D7373),
              size: 34,
            ),
            const SizedBox(height: 8),
            Text(
              hasMedia ? flight.mediaLabel : 'No media metadata yet',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                color: const Color(0xFF123737),
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FormSectionTitle extends StatelessWidget {
  const _FormSectionTitle(this.title);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleMedium?.copyWith(
        fontWeight: FontWeight.w800,
        color: const Color(0xFF123737),
      ),
    );
  }
}

class _FlightTextField extends StatelessWidget {
  const _FlightTextField({
    required this.label,
    required this.controller,
    this.maxLines = 1,
    this.requiredMessage,
    this.validator,
  });

  final String label;
  final TextEditingController controller;
  final int maxLines;
  final String? requiredMessage;
  final String? Function(String?)? validator;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      key: ValueKey<String>('flight-field-$label'),
      controller: controller,
      maxLines: maxLines,
      validator: (value) {
        final customResult = validator?.call(value);
        if (customResult != null) {
          return customResult;
        }
        if (requiredMessage == null) {
          return null;
        }
        if (value == null || value.trim().isEmpty) {
          return requiredMessage;
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFFE1E8E6)),
        ),
      ),
    );
  }
}

class _MapPreview extends StatelessWidget {
  const _MapPreview({required this.flights});

  final List<FlightRecord> flights;

  static const List<Offset> _pinPositions = [
    Offset(32, 42),
    Offset(214, 72),
    Offset(118, 150),
    Offset(268, 132),
  ];

  @override
  Widget build(BuildContext context) {
    final visibleFlights = flights.take(_pinPositions.length).toList();

    return Container(
      height: 220,
      decoration: BoxDecoration(
        color: const Color(0xFFDDEBE7),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFC9DCD8)),
      ),
      child: Stack(
        children: [
          const Center(
            child: Icon(Icons.map_outlined, size: 72, color: Color(0xFF89AAA5)),
          ),
          for (var index = 0; index < visibleFlights.length; index++)
            Positioned(
              left: _pinPositions[index].dx,
              top: _pinPositions[index].dy,
              child: _MapPin(label: '${index + 1}'),
            ),
          if (visibleFlights.isEmpty)
            Center(
              child: Text(
                'No coordinates yet',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: const Color(0xFF647B7A),
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _MapStatsRow extends StatelessWidget {
  const _MapStatsRow({required this.totalFlights, required this.mappedFlights});

  final int totalFlights;
  final int mappedFlights;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _StatCard(label: 'Mapped Flights', value: '$mappedFlights'),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _StatCard(label: 'Total Flights', value: '$totalFlights'),
        ),
      ],
    );
  }
}

class _MapPin extends StatelessWidget {
  const _MapPin({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 34,
      height: 34,
      decoration: const BoxDecoration(
        color: Color(0xFF1D7373),
        shape: BoxShape.circle,
      ),
      alignment: Alignment.center,
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelLarge?.copyWith(
          color: Colors.white,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}

class _LocationSummary extends StatelessWidget {
  const _LocationSummary({
    required this.title,
    required this.subtitle,
    this.onTap,
  });

  final String title;
  final String subtitle;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: const Color(0xFFE1E8E6)),
          ),
          child: Row(
            children: [
              const Icon(Icons.place_outlined, color: Color(0xFF1D7373)),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: const Color(0xFF123737),
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: const Color(0xFF647B7A),
                      ),
                    ),
                  ],
                ),
              ),
              if (onTap != null)
                const Icon(Icons.chevron_right, color: Color(0xFF647B7A)),
            ],
          ),
        ),
      ),
    );
  }
}

class _VersionBanner extends StatelessWidget {
  const _VersionBanner({required this.language});

  final AppLanguage language;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFEAF4F1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFC9DCD8)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.rocket_launch_outlined, color: Color(0xFF1D7373)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _appVersionLabel,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: const Color(0xFF123737),
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _text(language, _appStageLabel, '语言设置'),
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: const Color(0xFF365150),
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  _text(
                    language,
                    'Preparing SkyLog for English and Chinese private testers.',
                    '为英文和中文私测用户准备 SkyLog。',
                  ),
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: const Color(0xFF647B7A),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _LanguageSelectorCard extends StatelessWidget {
  const _LanguageSelectorCard({
    required this.language,
    required this.onLanguageChanged,
  });

  final AppLanguage language;
  final ValueChanged<AppLanguage> onLanguageChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFE1E8E6)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.translate_outlined, color: Color(0xFF1D7373)),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  _text(language, 'Language', '界面语言'),
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: const Color(0xFF123737),
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            _text(
              language,
              'Start of bilingual support for English and Chinese testers.',
              '中英文测试用户支持的第一步。',
            ),
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: const Color(0xFF647B7A)),
          ),
          const SizedBox(height: 12),
          SegmentedButton<AppLanguage>(
            key: const Key('language-selector'),
            segments: const [
              ButtonSegment<AppLanguage>(
                value: AppLanguage.english,
                label: Text('English'),
                icon: Icon(Icons.language_outlined),
              ),
              ButtonSegment<AppLanguage>(
                value: AppLanguage.chinese,
                label: Text('中文'),
                icon: Icon(Icons.translate_outlined),
              ),
            ],
            selected: {language},
            onSelectionChanged: (selection) {
              onLanguageChanged(selection.first);
            },
          ),
        ],
      ),
    );
  }
}

class _PilotCard extends StatelessWidget {
  const _PilotCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF123737), Color(0xFF1D7373)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Container(
            width: 54,
            height: 54,
            decoration: const BoxDecoration(
              color: Color(0xFFA7D8D3),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.person, color: Color(0xFF123737)),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'SkyLog Pilot',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '12 flights - 6h 35m logged',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: const Color(0xFFD6E7E5),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  const _SettingsTile({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: const Color(0xFFE1E8E6)),
          ),
          child: Row(
            children: [
              Icon(icon, color: const Color(0xFF1D7373)),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: const Color(0xFF123737),
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: const Color(0xFF647B7A),
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, color: Color(0xFF7A8F8E)),
            ],
          ),
        ),
      ),
    );
  }
}

class _ProfileStatsGrid extends StatelessWidget {
  const _ProfileStatsGrid({
    required this.totalFlights,
    required this.totalMinutes,
    required this.mappedFlights,
    required this.mediaFlights,
    required this.primaryDrone,
  });

  final int totalFlights;
  final int totalMinutes;
  final int mappedFlights;
  final int mediaFlights;
  final String primaryDrone;

  String get _flightTimeLabel {
    final hours = totalMinutes ~/ 60;
    final remainingMinutes = totalMinutes % 60;
    if (hours == 0) {
      return '${remainingMinutes}m';
    }
    if (remainingMinutes == 0) {
      return '${hours}h';
    }
    return '${hours}h ${remainingMinutes}m';
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _FormSectionTitle('Pilot Stats'),
        const SizedBox(height: 10),
        GridView.count(
          crossAxisCount: 2,
          childAspectRatio: 1.45,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          children: [
            _StatCard(label: 'Total Flights', value: '$totalFlights'),
            _StatCard(label: 'Flight Time', value: _flightTimeLabel),
            _StatCard(label: 'Mapped', value: '$mappedFlights'),
            _StatCard(label: 'With Media', value: '$mediaFlights'),
          ],
        ),
        const SizedBox(height: 12),
        _LocationSummary(title: 'Primary Drone', subtitle: primaryDrone),
      ],
    );
  }
}

class _DroneProfileSummary {
  _DroneProfileSummary({required this.model});

  final String model;
  int totalFlights = 0;
  int totalMinutes = 0;
  int mappedFlights = 0;
  int mediaFlights = 0;
  String latestDate = '';

  void addFlight(FlightRecord flight) {
    totalFlights += 1;
    totalMinutes += _durationMinutesFor(flight.duration);
    if (flight.hasCoordinates) {
      mappedFlights += 1;
    }
    if (flight.hasMedia) {
      mediaFlights += 1;
    }
    latestDate = latestDate.isEmpty ? flight.date : latestDate;
  }

  String get flightLabel =>
      totalFlights == 1 ? '1 flight' : '$totalFlights flights';

  String get timeLabel {
    return _formatMinutes(totalMinutes);
  }
}

class _DroneSummaryList extends StatelessWidget {
  const _DroneSummaryList({required this.droneProfiles});

  final List<_DroneProfileSummary> droneProfiles;

  @override
  Widget build(BuildContext context) {
    if (droneProfiles.isEmpty) {
      return const _LocationSummary(
        title: 'No drones yet',
        subtitle: 'Add a drone model when saving a flight record.',
      );
    }

    return Column(
      children: [
        for (final profile in droneProfiles) ...[
          _DroneProfileCard(profile: profile),
          const SizedBox(height: 10),
        ],
      ],
    );
  }
}

class _DroneProfileCard extends StatelessWidget {
  const _DroneProfileCard({required this.profile});

  final _DroneProfileSummary profile;

  @override
  Widget build(BuildContext context) {
    final subtitleStyle = Theme.of(
      context,
    ).textTheme.bodySmall?.copyWith(color: const Color(0xFF647B7A));

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFE1E8E6)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.flight_takeoff_outlined, color: Color(0xFF1D7373)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  profile.model,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: const Color(0xFF123737),
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${profile.flightLabel} - ${profile.timeLabel} total',
                  style: subtitleStyle,
                ),
                const SizedBox(height: 4),
                Text('Latest: ${profile.latestDate}', style: subtitleStyle),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _MiniStatChip(
                      icon: Icons.map_outlined,
                      label: '${profile.mappedFlights} mapped',
                    ),
                    _MiniStatChip(
                      icon: Icons.image_outlined,
                      label: '${profile.mediaFlights} media',
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _BackupReportCard extends StatelessWidget {
  const _BackupReportCard({
    required this.totalFlights,
    required this.totalMinutes,
    required this.mappedFlights,
    required this.mediaFlights,
  });

  final int totalFlights;
  final int totalMinutes;
  final int mappedFlights;
  final int mediaFlights;

  @override
  Widget build(BuildContext context) {
    final bodyStyle = Theme.of(
      context,
    ).textTheme.bodySmall?.copyWith(color: const Color(0xFF647B7A));

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFEAF4F1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFC9DCD8)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.health_and_safety_outlined,
                color: Color(0xFF1D7373),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Backup Report',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: const Color(0xFF123737),
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            '$totalFlights records - ${_formatMinutes(totalMinutes)} total flight time',
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              color: const Color(0xFF123737),
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '$mappedFlights map-ready records and $mediaFlights media-linked records are included in exports.',
            style: bodyStyle,
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: const [
              _MiniStatChip(icon: Icons.data_object, label: 'JSON backup'),
              _MiniStatChip(
                icon: Icons.table_chart_outlined,
                label: 'CSV table',
              ),
              _MiniStatChip(
                icon: Icons.devices_outlined,
                label: 'Local device',
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'Records are still stored on this browser/device. Export before clearing browser data or switching devices.',
            style: bodyStyle,
          ),
        ],
      ),
    );
  }
}

class _MiniStatChip extends StatelessWidget {
  const _MiniStatChip({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFFEAF4F1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: const Color(0xFF1D7373)),
          const SizedBox(width: 6),
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: const Color(0xFF123737),
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _DashboardHeader extends StatelessWidget {
  const _DashboardHeader();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'SkyLog',
                style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                  fontWeight: FontWeight.w800,
                  color: const Color(0xFF123737),
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'Record every drone flight.',
                style: Theme.of(
                  context,
                ).textTheme.bodyLarge?.copyWith(color: const Color(0xFF5A6F6F)),
              ),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFEAF4F1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  _appStageLabel,
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: const Color(0xFF1D7373),
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
        ),
        IconButton.filled(
          onPressed: () {},
          icon: const Icon(Icons.add),
          tooltip: 'Add Flight',
        ),
      ],
    );
  }
}

class _RecentFlightCard extends StatelessWidget {
  const _RecentFlightCard({required this.flight});

  final FlightRecord? flight;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFF123737),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Latest Flight',
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
              color: const Color(0xFFA7D8D3),
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            flight?.title ?? 'No flights recorded yet',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            flight == null
                ? 'Add your first flight to start tracking progress.'
                : '${flight!.location} - ${flight!.duration} - ${flight!.drone}',
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: const Color(0xFFD6E7E5)),
          ),
        ],
      ),
    );
  }
}

class _StatsGrid extends StatelessWidget {
  const _StatsGrid({required this.totalFlights, required this.totalMinutes});

  final int totalFlights;
  final int totalMinutes;

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      childAspectRatio: 1.0,
      children: [
        _StatCard(label: 'Total Flights', value: '$totalFlights'),
        _StatCard(label: 'Flight Time', value: _formatMinutes(totalMinutes)),
        _StatCard(label: 'This Month', value: '$totalFlights'),
        _StatCard(label: 'Saved Spots', value: '$totalFlights'),
      ],
    );
  }

  String _formatMinutes(int minutes) {
    final hours = minutes ~/ 60;
    final remainingMinutes = minutes % 60;
    if (hours == 0) {
      return '${remainingMinutes}m';
    }
    return '${hours}h ${remainingMinutes}m';
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFE1E8E6)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            value,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w800,
              color: const Color(0xFF123737),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: const Color(0xFF647B7A)),
          ),
        ],
      ),
    );
  }
}

class _ChecklistProgressCard extends StatelessWidget {
  const _ChecklistProgressCard({
    required this.completed,
    required this.total,
    required this.onTap,
  });

  final int completed;
  final int total;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final isReady = completed == total;

    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: const Color(0xFFE1E8E6)),
          ),
          child: Row(
            children: [
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: const Color(0xFFEAF4F1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  isReady
                      ? Icons.check_circle_outline
                      : Icons.fact_check_outlined,
                  color: const Color(0xFF1D7373),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Pre-flight Checklist',
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: const Color(0xFF123737),
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      isReady
                          ? 'Ready to fly'
                          : '$completed of $total safety checks complete',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: const Color(0xFF647B7A),
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, color: Color(0xFF7A8F8E)),
            ],
          ),
        ),
      ),
    );
  }
}

class _QuickActions extends StatelessWidget {
  const _QuickActions({
    required this.onAddFlight,
    required this.onOpenChecklist,
  });

  final VoidCallback onAddFlight;
  final VoidCallback onOpenChecklist;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quick Actions',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w800,
            color: const Color(0xFF123737),
          ),
        ),
        const SizedBox(height: 12),
        FilledButton.icon(
          onPressed: onAddFlight,
          icon: const Icon(Icons.flight_takeoff),
          label: const Text('Add Flight'),
          style: FilledButton.styleFrom(
            minimumSize: const Size.fromHeight(52),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
        const SizedBox(height: 10),
        OutlinedButton.icon(
          onPressed: onOpenChecklist,
          icon: const Icon(Icons.fact_check_outlined),
          label: const Text('Open Checklist'),
          style: OutlinedButton.styleFrom(
            minimumSize: const Size.fromHeight(52),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
      ],
    );
  }
}

class _RecentLogs extends StatelessWidget {
  const _RecentLogs({required this.flights});

  final List<FlightRecord> flights;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Recent Logs',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w800,
            color: const Color(0xFF123737),
          ),
        ),
        const SizedBox(height: 12),
        if (flights.isEmpty)
          const _LogTile(
            title: 'No recent logs',
            detail: 'Saved flights will appear here.',
          )
        else
          for (final flight in flights) ...[
            _LogTile(
              title: flight.title,
              detail: '${flight.date} - ${flight.duration} - ${flight.weather}',
            ),
            const SizedBox(height: 10),
          ],
      ],
    );
  }
}

class _LogTile extends StatelessWidget {
  const _LogTile({required this.title, required this.detail});

  final String title;
  final String detail;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFE1E8E6)),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: const Color(0xFFE2F0ED),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.map_outlined, color: Color(0xFF1D7373)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w800,
                    color: const Color(0xFF123737),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  detail,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: const Color(0xFF647B7A),
                  ),
                ),
              ],
            ),
          ),
          const Icon(Icons.chevron_right, color: Color(0xFF7A8F8E)),
        ],
      ),
    );
  }
}
