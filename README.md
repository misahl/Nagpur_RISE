# 🍊 OrangeAI – AI-Powered Orange Farm Monitoring & Automation

A production-style mobile application built with **Flutter**, **Dart**, and **Material 3** for orange citrus farmers, field workers, and regional agricultural administrators. OrangeAI integrates deep-learning plant pathology diagnostics, geospatial orchard mapping, autonomous drone flight monitoring, live IoT tensiometry telemetry, open satellite weather station forecasts, automated drip irrigation management, and farm-to-mandi QR code traceability.

---

## 🌟 Key Functional Architecture & Modules

```
lib/
├── core/
│   ├── constants/       # AppColors (Nagpur Orange & Green), AppConstants, Disease Classes
│   ├── theme/           # Material 3 Theme with rounded geometry, custom inputs & elevation
│   └── utils/           # Formatters & telemetry utilities
├── models/
│   ├── user_model.dart             # Role-based identity (Farmer, Worker, Admin)
│   ├── farm_model.dart             # Complete agronomic orchard parameters
│   ├── zone_model.dart             # Zone boundaries & Green/Yellow/Orange/Red risk states
│   ├── tree_model.dart             # Individual tree profiles (Tree B-042, etc.)
│   ├── disease_scan_model.dart     # AI diagnosis, severity, confidence, indicators
│   ├── sensor_reading_model.dart   # IoT soil moisture, temp, humidity, pH, N-P-K, water tank
│   ├── alert_model.dart            # Categorized smart agricultural notifications
│   ├── task_model.dart             # Worker dispatch, inspection photos, notes & completion
│   ├── drone_mission_model.dart    # Flight telemetry, coverage %, hotspots, altitude
│   ├── harvest_batch_model.dart    # Post-harvest batches & QR provenance records
│   ├── weather_model.dart          # Live Open-Meteo station feed & 7-day forecast
│   └── pest_report_model.dart      # Sticky trap inspections and pest risk monitoring
├── services/
│   ├── auth_service.dart           # Authentication, role switching & session persistence
│   ├── farm_state_provider.dart    # Reactive central state engine for seamless demo flow
│   ├── ai_service.dart             # AIService interface with Mock & REST-ready Real implementations
│   ├── fruit_detection_service.dart# YOLOv8 fruit counting & maturity classification
│   ├── sensor_service.dart         # ESP32 compatible live IoT simulation stream
│   ├── drone_service.dart          # MAVLink waypoint tracking & autonomous mission simulator
│   ├── irrigation_service.dart     # Zone valve actuation, water metering & rain delay logic
│   ├── weather_service.dart        # Open-Meteo API integration with Nagpur fallback
│   ├── yield_service.dart          # ML harvest yield regression (8.4 tonnes forecast)
│   ├── ai_chat_service.dart        # Contextual Agronomist AI answering natural language queries
│   └── report_service.dart         # Official farm health audit PDF compilation
├── screens/
│   ├── auth/                       # Login, Register, Forgot Password
│   ├── dashboard/                  # Farmer, Worker, Admin Dashboards & Main Scaffold
│   ├── farm/                       # Farm Details, Farm Map, Zone Details, Tree Details, Tree Registry
│   ├── ai_scan/                    # AI Crop Scanner, Disease Result, YOLO Fruit Vision
│   ├── drone/                      # Autonomous Drone Mission Simulator
│   ├── sensors/                    # IoT Soil, Temperature, pH & NPK Gauges
│   ├── irrigation/                 # Precision Drip Irrigation & Valve Automation
│   ├── weather/                    # Microclimate Station & 7-Day Forecast
│   ├── alerts/                     # Real-time Smart Farm Alerts
│   ├── tasks/                      # Field Task Dispatch & Worker Inspections
│   ├── analytics/                  # Crop Health, Disease Heatmap, Pest Traps, Yield Forecast
│   ├── reports/                    # Farm Health Audit Reports & PDF View
│   ├── assistant/                  # AI Farm Assistant Chatbot
│   ├── traceability/               # Harvest Batches & QR Code Generation
│   ├── history/                    # Chronological Farm Activity Timeline
│   └── profile/                    # User Profile, Role Switching & Localization
└── widgets/
    ├── health_card.dart            # Crop health circular score card
    ├── metric_card.dart            # Standardized agricultural metric tiles
    ├── alert_card.dart             # Notification-style severity alert cards
    ├── task_card.dart              # Task checklist items with worker status
    ├── farm_map_widget.dart        # Interactive map with zone polygons, heatmap & pins
    ├── health_indicator.dart       # Circular health gauge with dynamic thresholds
    └── quick_action_item.dart      # Quick action launcher icons
```

---

## 🚀 The Complete Demonstration Flow

The application is engineered to perform the full end-to-end user workflow:

1. **Farmer Authentication**:
   - Tap **"Farmer Demo"** on the login screen (pre-populated with Rajesh Patil, Kalmeshwar, Nagpur).
2. **Dashboard Overview**:
   - View **Farm Health (87%)**, **Weather (29°C)**, **Soil Moisture (64%)**, **Area (4.2 Acres)**, and **Orange Trees (1,240)**.
3. **Farm Map Inspection**:
   - Tap **"Farm Map"** or the preview widget.
   - Inspect the interactive orchard. Tap **Zone B** (flagged as Yellow/Moderate Risk, low moisture at 24%).
4. **AI Crop Scan**:
   - Tap **"AI Scan Zone"** or the bottom navigation **AI SCAN** tab.
   - The high-resolution citrus leaf sample (`canker_leaf.jpg`) is pre-loaded (or capture via camera/gallery).
   - Tap **"Analyze Image with AI"**.
   - The neural engine scans the leaf and presents the **Diagnosis**:
     - **Disease**: Citrus Canker (*Xanthomonas axonopodis*)
     - **Confidence**: 94%
     - **Severity**: High
     - **Detected Visual Indicators**: Raised corky lesions, oily chlorotic yellow halos.
     - **Action**: Apply Copper Oxychloride 50 WP (3g/L) and isolate nearby trees.
5. **System-wide State Reaction**:
   - Zone B status automatically flips to **RED (Diseased)** on the geospatial map and heatmap!
   - Tree B-042 profile updates with an incremented disease counter.
   - An immediate High-Priority **Disease Alert** is dispatched to the Alerts tab.
   - A new field task *"Inspect & Isolate Tree B-042"* is automatically scheduled for worker **Ramesh Pawar**.
6. **Field Worker Execution**:
   - Switch role to **Farm Worker** from the top bar or Profile screen.
   - Open the worker portal, select the newly assigned inspection task.
   - Attach field photo, add treatment notes, and tap **"MARK TASK COMPLETED"**.
   - Farm health score rebounds to 86.5%!
7. **Weather & Precision Irrigation**:
   - Open **Weather Station**: Open-Meteo API forecasts rain probability.
   - Open **Smart Irrigation**: System shows AI recommendation: *"Zone B soil moisture deficit, but rain expected in 3 hours. Postponing irrigation cycle recommended to prevent waterlogging."*
   - Tap **"START IRRIGATION"** to simulate live drip valves and water meter consumption!
8. **Drone Survey Simulation**:
   - Launch an autonomous drone flight across Zone A → Zone B.
   - Watch real-time aerial footage, battery drain, and coverage progress to 100%.
9. **Fruit Vision & Yield Prediction**:
   - Open **Fruit AI** to view YOLO computer vision cluster counting (37 detected fruits, 32 healthy).
   - Open **Yield Prediction** to view the projected harvest: **8.4 Tonnes (Dec 10 – Jan 05)** with Mandi valuation of ₹3.52 Lakh.
10. **QR Traceability & Report Export**:
    - Open **Harvest Batches** to inspect batch `OR-2026-001`.
    - Generate a scannable **QR Code** for instant consumer and APMC mandi verification.
    - Generate and review the official **Farm Health PDF Audit Report**.

---

## 🛠️ Testing & Running the App

### Run Flutter Unit & Widget Tests:
```bash
flutter test
```

### Run on Windows Desktop:
```bash
flutter run -d windows
```

### Run on Web (Chrome):
```bash
flutter run -d chrome
```

### Build Android APK:
```bash
flutter build apk --debug
```
