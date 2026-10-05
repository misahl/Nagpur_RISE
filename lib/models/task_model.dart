class TaskModel {
  final String id;
  final String farmId;
  final String zoneId;
  final String zoneName;
  final String title;
  final String description;
  final String priority; // 'Low', 'Medium', 'High'
  final String assignedWorkerId;
  final String assignedWorkerName;
  final String deadline;
  final String status; // 'Pending', 'In Progress', 'Completed'
  final String inspectionNotes;
  final String inspectionImageUrl;
  final DateTime? completedAt;

  TaskModel({
    required this.id,
    required this.farmId,
    required this.zoneId,
    required this.zoneName,
    required this.title,
    required this.description,
    required this.priority,
    required this.assignedWorkerId,
    required this.assignedWorkerName,
    required this.deadline,
    this.status = 'Pending',
    this.inspectionNotes = '',
    this.inspectionImageUrl = '',
    this.completedAt,
  });

  TaskModel copyWith({
    String? status,
    String? inspectionNotes,
    String? inspectionImageUrl,
    DateTime? completedAt,
  }) {
    return TaskModel(
      id: id,
      farmId: farmId,
      zoneId: zoneId,
      zoneName: zoneName,
      title: title,
      description: description,
      priority: priority,
      assignedWorkerId: assignedWorkerId,
      assignedWorkerName: assignedWorkerName,
      deadline: deadline,
      status: status ?? this.status,
      inspectionNotes: inspectionNotes ?? this.inspectionNotes,
      inspectionImageUrl: inspectionImageUrl ?? this.inspectionImageUrl,
      completedAt: completedAt ?? this.completedAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'farmId': farmId,
      'zoneId': zoneId,
      'zoneName': zoneName,
      'title': title,
      'description': description,
      'priority': priority,
      'assignedWorkerId': assignedWorkerId,
      'assignedWorkerName': assignedWorkerName,
      'deadline': deadline,
      'status': status,
      'inspectionNotes': inspectionNotes,
      'inspectionImageUrl': inspectionImageUrl,
      'completedAt': completedAt?.toIso8601String(),
    };
  }

  factory TaskModel.fromMap(Map<String, dynamic> map) {
    return TaskModel(
      id: map['id'] ?? '',
      farmId: map['farmId'] ?? '',
      zoneId: map['zoneId'] ?? '',
      zoneName: map['zoneName'] ?? 'Zone A',
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      priority: map['priority'] ?? 'Medium',
      assignedWorkerId: map['assignedWorkerId'] ?? 'worker_1',
      assignedWorkerName: map['assignedWorkerName'] ?? 'Ramesh Patil',
      deadline: map['deadline'] ?? 'Today, 5:00 PM',
      status: map['status'] ?? 'Pending',
      inspectionNotes: map['inspectionNotes'] ?? '',
      inspectionImageUrl: map['inspectionImageUrl'] ?? '',
      completedAt: map['completedAt'] != null 
          ? DateTime.parse(map['completedAt']) 
          : null,
    );
  }
}
