import 'package:flutter/foundation.dart';
import '../models/farm_model.dart';
import '../models/zone_model.dart';
import '../models/tree_model.dart';
import '../models/disease_scan_model.dart';
import '../models/alert_model.dart';
import '../models/task_model.dart';
import '../models/harvest_batch_model.dart';
import '../models/weather_model.dart';
import '../models/pest_report_model.dart';
import 'ai_service.dart';
import 'sensor_service.dart';
import 'drone_service.dart';
import 'irrigation_service.dart';
import 'weather_service.dart';
import 'yield_service.dart';
import 'report_service.dart';
import 'fruit_detection_service.dart';

class FarmTimelineEvent {
  final String date;
  final String title;
  final String description;
  final String type; // 'scan', 'drone', 'irrigation', 'inspection', 'harvest'

  FarmTimelineEvent({
    required this.date,
    required this.title,
    required this.description,
    required this.type,
  });
}

class FarmStateProvider extends ChangeNotifier {
  // Services
  final AIService aiService = MockAIService();
  final SimulatedSensorService sensorService = SimulatedSensorService();
  final SimulatedDroneService droneService = SimulatedDroneService();
  final IrrigationService irrigationService = IrrigationService();
  final WeatherService weatherService = OpenMeteoWeatherService();
  final YieldPredictionService yieldService = MockYieldPredictionService();
  final ReportService reportService = ReportService();
  final FruitDetectionService fruitService = FruitDetectionService();

  // Selected State
  late FarmModel _currentFarm;
  List<FarmModel> _farms = [];
  List<ZoneModel> _zones = [];
  List<TreeModel> _trees = [];
  final List<DiseaseScanModel> _diseaseScans = [];
  List<AlertModel> _alerts = [];
  List<TaskModel> _tasks = [];
  List<HarvestBatchModel> _harvestBatches = [];
  List<PestReportModel> _pestReports = [];
  List<FarmTimelineEvent> _timelineEvents = [];
  WeatherModel _weather = WeatherModel.defaultNagpur();

  bool _isDemoMode = true;
  String _selectedLanguage = 'English';
  bool _isLoading = false;

  FarmModel get currentFarm => _currentFarm;
  List<FarmModel> get farms => _farms;
  List<ZoneModel> get zones => _zones;
  List<TreeModel> get trees => _trees;
  List<DiseaseScanModel> get diseaseScans => _diseaseScans;
  List<AlertModel> get alerts => _alerts;
  List<TaskModel> get tasks => _tasks;
  List<HarvestBatchModel> get harvestBatches => _harvestBatches;
  List<PestReportModel> get pestReports => _pestReports;
  List<FarmTimelineEvent> get timelineEvents => _timelineEvents;
  WeatherModel get weather => _weather;
  bool get isDemoMode => _isDemoMode;
  String get selectedLanguage => _selectedLanguage;
  bool get isLoading => _isLoading;

  FarmStateProvider() {
    _initializeData();
    _loadWeather();
  }

  void setLanguage(String lang) {
    _selectedLanguage = lang;
    notifyListeners();
  }

  void toggleDemoMode(bool value) {
    _isDemoMode = value;
    notifyListeners();
  }

  Future<void> _loadWeather() async {
    _weather = await weatherService.fetchWeather(
      latitude: _currentFarm.latitude,
      longitude: _currentFarm.longitude,
    );
    notifyListeners();
  }

  void _initializeData() {
    // 1. Initial Farm
    _currentFarm = FarmModel(
      id: 'farm_001',
      ownerId: 'farmer_01',
      name: 'Green Valley Orange Farm',
      location: 'Kalmeshwar, Nagpur Rural, Maharashtra',
      areaAcres: 4.2,
      orangeVariety: 'Nagpur Mandarin (Citrus reticulata)',
      numberOfTrees: 1240,
      treeAgeYears: 6,
      soilType: 'Deep Black Soil / Sandy Loam',
      irrigationType: 'Automated Drip System',
      healthScore: 87.0,
      diseaseRisk: 12.0,
      pestRisk: 8.0,
      soilCondition: 'Optimal Moisture & Aeration',
      weatherTemp: 29.0,
      irrigationStatus: 'Scheduled (Evening)',
      latitude: 21.1458,
      longitude: 79.0882,
    );

    _farms = [
      _currentFarm,
      FarmModel(
        id: 'farm_002',
        ownerId: 'farmer_01',
        name: 'Shree Ganesh Citrus Grove',
        location: 'Katol Road, Nagpur',
        areaAcres: 3.5,
        orangeVariety: 'Nagpur Seedless Hybrid',
        numberOfTrees: 980,
        treeAgeYears: 4,
        soilType: 'Clay Loam',
        irrigationType: 'Micro-Sprinkler',
        healthScore: 92.0,
        diseaseRisk: 6.0,
        pestRisk: 4.0,
      ),
    ];

    // 2. Zones (GREEN = Healthy, YELLOW = Moderate Risk, ORANGE = Needs Inspection, RED = Diseased)
    _zones = [
      ZoneModel(
        id: 'zone_a',
        farmId: 'farm_001',
        name: 'Zone A',
        numberOfTrees: 340,
        healthScore: 94.0,
        diseaseCases: 0,
        pestRisk: 'LOW',
        soilMoisture: 65.0,
        lastInspectionDate: '03 Oct 2026',
        statusColor: 'GREEN',
        description: 'North plot, young vigorous canopy with high blossom density',
        centerLat: 21.1465,
        centerLng: 79.0875,
      ),
      ZoneModel(
        id: 'zone_b',
        farmId: 'farm_001',
        name: 'Zone B',
        numberOfTrees: 320,
        healthScore: 72.0,
        diseaseCases: 2,
        pestRisk: 'MEDIUM',
        soilMoisture: 24.0,
        lastInspectionDate: '04 Oct 2026',
        statusColor: 'YELLOW', // Becomes RED after Citrus Canker scan
        description: 'Central plot, lower soil moisture gradient, requires inspection',
        centerLat: 21.1458,
        centerLng: 79.0888,
      ),
      ZoneModel(
        id: 'zone_c',
        farmId: 'farm_001',
        name: 'Zone C',
        numberOfTrees: 300,
        healthScore: 68.0,
        diseaseCases: 4,
        pestRisk: 'HIGH',
        soilMoisture: 42.0,
        lastInspectionDate: '01 Oct 2026',
        statusColor: 'RED',
        description: 'Southern ridge, micro-climate humidity trap, history of fungal spores',
        centerLat: 21.1448,
        centerLng: 79.0880,
      ),
      ZoneModel(
        id: 'zone_d',
        farmId: 'farm_001',
        name: 'Zone D',
        numberOfTrees: 280,
        healthScore: 91.0,
        diseaseCases: 0,
        pestRisk: 'LOW',
        soilMoisture: 58.0,
        lastInspectionDate: '04 Oct 2026',
        statusColor: 'GREEN',
        description: 'Eastern slope, healthy vegetative growth and optimum drip coverage',
        centerLat: 21.1452,
        centerLng: 79.0895,
      ),
    ];

    // 3. Tree Registry
    _trees = [
      TreeModel(
        id: 'tree_b_042',
        farmId: 'farm_001',
        zoneId: 'zone_b',
        treeCode: 'Tree B-042',
        ageYears: 6,
        variety: 'Nagpur Mandarin',
        healthScore: 72.0,
        currentStatus: 'Needs Inspection',
        diseaseHistoryCount: 2,
        lastInspection: '04 Oct 2026',
        notes: 'Suspected lesions on mid-canopy leaves. Flagged for close diagnosis.',
        latitude: 21.1459,
        longitude: 79.0889,
      ),
      TreeModel(
        id: 'tree_a_015',
        farmId: 'farm_001',
        zoneId: 'zone_a',
        treeCode: 'Tree A-015',
        ageYears: 5,
        variety: 'Nagpur Mandarin',
        healthScore: 96.0,
        currentStatus: 'Healthy',
        diseaseHistoryCount: 0,
        lastInspection: '03 Oct 2026',
        notes: 'Optimal vegetative flush, strong root anchor, no signs of chlorosis.',
        latitude: 21.1466,
        longitude: 79.0874,
      ),
      TreeModel(
        id: 'tree_c_089',
        farmId: 'farm_001',
        zoneId: 'zone_c',
        treeCode: 'Tree C-089',
        ageYears: 7,
        variety: 'Nagpur Mandarin',
        healthScore: 64.0,
        currentStatus: 'Diseased',
        diseaseHistoryCount: 3,
        lastInspection: '01 Oct 2026',
        notes: 'Previous fungal twig blight treated. Monitoring branch regrowth.',
        latitude: 21.1449,
        longitude: 79.0881,
      ),
      TreeModel(
        id: 'tree_d_102',
        farmId: 'farm_001',
        zoneId: 'zone_d',
        treeCode: 'Tree D-102',
        ageYears: 6,
        variety: 'Nagpur Mandarin',
        healthScore: 92.0,
        currentStatus: 'Healthy',
        diseaseHistoryCount: 0,
        lastInspection: '04 Oct 2026',
        notes: 'Uniform fruit setting, deep green leaves with zero miner damage.',
        latitude: 21.1453,
        longitude: 79.0896,
      ),
    ];

    // 4. Initial Alerts
    _alerts = [
      AlertModel(
        id: 'alert_001',
        farmId: 'farm_001',
        title: 'High Disease Risk Detected',
        message: 'High fungal disease risk detected in Zone C due to elevated local micro-humidity.',
        type: 'Disease',
        severity: 'High',
        timestamp: DateTime.now().subtract(const Duration(hours: 3)),
        relatedZone: 'Zone C',
      ),
      AlertModel(
        id: 'alert_002',
        farmId: 'farm_001',
        title: 'Critical Soil Moisture Deficit',
        message: 'Soil moisture in Zone B is critically low at 24%. Irrigation cycle needed.',
        type: 'Water',
        severity: 'Medium',
        timestamp: DateTime.now().subtract(const Duration(hours: 5)),
        relatedZone: 'Zone B',
      ),
      AlertModel(
        id: 'alert_003',
        farmId: 'farm_001',
        title: 'Heavy Rainfall Probability',
        message: 'Heavy rainfall expected later this week. Please inspect drainage contours.',
        type: 'Weather',
        severity: 'Low',
        timestamp: DateTime.now().subtract(const Duration(hours: 12)),
      ),
    ];

    // 5. Initial Tasks
    _tasks = [
      TaskModel(
        id: 'task_001',
        farmId: 'farm_001',
        zoneId: 'zone_a',
        zoneName: 'Zone A',
        title: 'Inspect Zone A Foliage Flush',
        description: 'Verify new leaf growth for citrus leafminer serpentine tracks.',
        priority: 'Medium',
        assignedWorkerId: 'worker_01',
        assignedWorkerName: 'Ramesh Pawar',
        deadline: 'Today, 5:00 PM',
        status: 'In Progress',
      ),
      TaskModel(
        id: 'task_002',
        farmId: 'farm_001',
        zoneId: 'zone_b',
        zoneName: 'Zone B',
        title: 'Irrigate Zone B Drip Lateral',
        description: 'Flush drip lines and run lateral valves for 45 minutes.',
        priority: 'High',
        assignedWorkerId: 'worker_01',
        assignedWorkerName: 'Ramesh Pawar',
        deadline: 'Today, 6:30 PM',
        status: 'Pending',
      ),
      TaskModel(
        id: 'task_003',
        farmId: 'farm_001',
        zoneId: 'zone_c',
        zoneName: 'Zone C',
        title: 'Check Pest Traps in Zone C',
        description: 'Count fruit fly and psyllid count in delta sticky traps.',
        priority: 'Medium',
        assignedWorkerId: 'worker_02',
        assignedWorkerName: 'Suresh More',
        deadline: 'Tomorrow, 10:00 AM',
        status: 'Pending',
      ),
      TaskModel(
        id: 'task_004',
        farmId: 'farm_001',
        zoneId: 'zone_a',
        zoneName: 'Zone A',
        title: 'Perform Drone Multispectral Scan',
        description: 'Run automated mission over North and Central quadrants.',
        priority: 'Low',
        assignedWorkerId: 'worker_01',
        assignedWorkerName: 'Ramesh Pawar',
        deadline: 'Completed',
        status: 'Completed',
        completedAt: DateTime.now().subtract(const Duration(days: 1)),
        inspectionNotes: 'All flight waypoints mapped successfully. 142 aerial frames uploaded.',
      ),
    ];

    // 6. Harvest Batches
    _harvestBatches = [
      HarvestBatchModel(
        id: 'batch_001',
        batchCode: 'OR-2026-001',
        farmId: 'farm_001',
        farmName: 'Green Valley Orange Farm',
        harvestDate: '04 Oct 2026',
        quantityKg: 2450.0,
        qualityGrade: 'Grade A+ (Premium Export)',
        status: 'Quality Certified',
        sugarBrix: 11.8,
        averageWeightGram: 185.0,
      ),
      HarvestBatchModel(
        id: 'batch_002',
        batchCode: 'OR-2026-002',
        farmId: 'farm_001',
        farmName: 'Green Valley Orange Farm',
        harvestDate: '05 Oct 2026',
        quantityKg: 1850.0,
        qualityGrade: 'Grade A (Table Market)',
        status: 'Packaged & Ready',
        sugarBrix: 11.2,
        averageWeightGram: 172.0,
      ),
    ];

    // 7. Pest Reports
    _pestReports = [
      PestReportModel(
        id: 'pest_001',
        farmId: 'farm_001',
        zoneId: 'zone_b',
        zoneName: 'Zone B',
        pestType: 'Citrus Leafminer (Phyllocnistis citrella)',
        severity: 'MEDIUM',
        photoUrl: '',
        date: DateTime.now().subtract(const Duration(days: 1)),
        notes: 'Found in 3 trees. Serpentine leaf galleries noted on tender leaves.',
        trapCount: '5 pheromone traps inspected',
      ),
      PestReportModel(
        id: 'pest_002',
        farmId: 'farm_001',
        zoneId: 'zone_c',
        zoneName: 'Zone C',
        pestType: 'Asian Citrus Psyllid (Diaphorina citri)',
        severity: 'HIGH',
        photoUrl: '',
        date: DateTime.now().subtract(const Duration(days: 3)),
        notes: 'Small nymphs clustered on shoot tips. Systemic spray scheduled.',
        trapCount: '8 sticky cards checked',
      ),
    ];

    // 8. Historical Timeline
    _timelineEvents = [
      FarmTimelineEvent(
        date: '05 Oct',
        title: 'IoT Sensor Calibration',
        description: 'Soil probe telemetry refreshed with 64% farm-wide moisture baseline.',
        type: 'inspection',
      ),
      FarmTimelineEvent(
        date: '04 Oct',
        title: 'Autonomous Drone Scan Completed',
        description: '67% orchard coverage mapped; 142 aerial RGB frames analyzed.',
        type: 'drone',
      ),
      FarmTimelineEvent(
        date: '03 Oct',
        title: 'Drip Irrigation Cycle Executed',
        description: 'Zone A and Zone D received 1,200 Liters of precision water fertigation.',
        type: 'irrigation',
      ),
      FarmTimelineEvent(
        date: '02 Oct',
        title: 'Pest Inspection Logged',
        description: 'Field traps surveyed in Zone C; moderate psyllid pressure flagged.',
        type: 'inspection',
      ),
    ];
  }

  // Farm Actions
  void selectFarm(FarmModel farm) {
    _currentFarm = farm;
    _loadWeather();
    notifyListeners();
  }

  void addFarm(FarmModel farm) {
    _farms.add(farm);
    _currentFarm = farm;
    notifyListeners();
  }

  // AI Scan Workflow Execution (Matches the user's Main Demonstration Flow step-by-step)
  Future<DiseaseScanModel> runAiScan({
    required dynamic imageFile,
    required String zoneId,
    required String treeCode,
    String? forcedDisease,
  }) async {
    _isLoading = true;
    notifyListeners();

    final zone = _zones.firstWhere((z) => z.id == zoneId, orElse: () => _zones[1]);

    // AI Analysis
    final scanResult = await aiService.analyzeLeafImage(
      imageFile: imageFile,
      farmId: _currentFarm.id,
      zoneId: zone.id,
      zoneName: zone.name,
      treeId: 'tree_b_042',
      treeCode: treeCode,
      forcedDisease: forcedDisease ?? 'Citrus Canker',
    );

    _diseaseScans.insert(0, scanResult);

    // Update Zone B to RED / Diseased
    final zoneIndex = _zones.indexWhere((z) => z.id == zone.id);
    if (zoneIndex != -1) {
      _zones[zoneIndex] = _zones[zoneIndex].copyWith(
        statusColor: 'RED',
        healthScore: 68.0,
        diseaseCases: _zones[zoneIndex].diseaseCases + 1,
        lastInspectionDate: 'Today (AI Verified)',
      );
    }

    // Update Tree B-042
    final treeIndex = _trees.indexWhere((t) => t.treeCode == treeCode);
    if (treeIndex != -1) {
      _trees[treeIndex] = _trees[treeIndex].copyWith(
        currentStatus: 'Diseased',
        healthScore: 65.0,
        diseaseHistoryCount: _trees[treeIndex].diseaseHistoryCount + 1,
        lastInspection: 'Today',
        notes: 'AI Detected: ${scanResult.diseaseName} (${(scanResult.confidence * 100).toInt()}%)',
      );
    }

    // Update Farm Health & Disease Risk
    _currentFarm = _currentFarm.copyWith(
      healthScore: 84.0,
      diseaseRisk: 18.0,
    );

    // Generate Alert
    final newAlert = AlertModel(
      id: 'alert_${DateTime.now().millisecondsSinceEpoch}',
      farmId: _currentFarm.id,
      title: 'Citrus Canker Confirmed in ${zone.name}',
      message: 'AI Scan verified Citrus Canker on $treeCode with ${(scanResult.confidence * 100).toInt()}% confidence. Immediate copper spray recommended.',
      type: 'Disease',
      severity: 'High',
      timestamp: DateTime.now(),
      relatedZone: zone.name,
    );
    _alerts.insert(0, newAlert);

    // Add Timeline Event
    _timelineEvents.insert(
      0,
      FarmTimelineEvent(
        date: 'Today',
        title: 'AI Detected ${scanResult.diseaseName} in ${zone.name}',
        description: 'Analyzed $treeCode with ${(scanResult.confidence * 100).toInt()}% confidence score.',
        type: 'scan',
      ),
    );

    // Prompt / add inspection task for worker
    final newTask = TaskModel(
      id: 'task_${DateTime.now().millisecondsSinceEpoch}',
      farmId: _currentFarm.id,
      zoneId: zone.id,
      zoneName: zone.name,
      title: 'Inspect & Isolate $treeCode (${scanResult.diseaseName})',
      description: 'Spray Copper Oxychloride 50 WP (3g/L). Sanitize cutters and inspect 5 adjacent orange trees.',
      priority: 'High',
      assignedWorkerId: 'worker_01',
      assignedWorkerName: 'Ramesh Pawar',
      deadline: 'Today, 6:00 PM',
      status: 'Pending',
    );
    _tasks.insert(0, newTask);

    _isLoading = false;
    notifyListeners();
    return scanResult;
  }

  // Worker completes task
  void completeTask({
    required String taskId,
    required String inspectionNotes,
    String? inspectionPhoto,
  }) {
    final index = _tasks.indexWhere((t) => t.id == taskId);
    if (index != -1) {
      _tasks[index] = _tasks[index].copyWith(
        status: 'Completed',
        inspectionNotes: inspectionNotes,
        inspectionImageUrl: inspectionPhoto ?? 'assets/images/canker_leaf.jpg',
        completedAt: DateTime.now(),
      );

      // Farm health improvement after worker intervention
      _currentFarm = _currentFarm.copyWith(
        healthScore: 86.5,
        diseaseRisk: 14.0,
      );

      _timelineEvents.insert(
        0,
        FarmTimelineEvent(
          date: 'Today',
          title: 'Worker Inspection Completed: ${_tasks[index].title}',
          description: inspectionNotes,
          type: 'inspection',
        ),
      );

      notifyListeners();
    }
  }

  void assignNewTask(TaskModel task) {
    _tasks.insert(0, task);
    notifyListeners();
  }

  void addPestReport(PestReportModel report) {
    _pestReports.insert(0, report);
    notifyListeners();
  }

  void addHarvestBatch(HarvestBatchModel batch) {
    _harvestBatches.insert(0, batch);
    notifyListeners();
  }

  void markAlertRead(String alertId) {
    final index = _alerts.indexWhere((a) => a.id == alertId);
    if (index != -1) {
      _alerts[index] = _alerts[index].copyWith(isRead: true);
      notifyListeners();
    }
  }
}
