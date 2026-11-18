class Complaint {
  Complaint({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.status,
    required this.imageUrl,
    required this.latitude,
    required this.longitude,
    required this.address,
    required this.createdAt,
    required this.history,
  });

  final String id;
  final String title;
  final String description;
  final String category;
  final String status;
  final String imageUrl;
  final double latitude;
  final double longitude;
  final String address;
  final DateTime createdAt;
  final List<ComplaintHistory> history;

  factory Complaint.fromJson(Map<String, dynamic> json) {
    final location = json['location'] as Map<String, dynamic>? ?? {};
    final historyJson = (json['history'] as List<dynamic>? ?? []);

    return Complaint(
      id: json['_id']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      category: json['category']?.toString() ?? 'Other',
      status: json['status']?.toString() ?? 'Pending',
      imageUrl: json['imageUrl']?.toString() ?? '',
      latitude: (location['lat'] as num?)?.toDouble() ?? 0,
      longitude: (location['lng'] as num?)?.toDouble() ?? 0,
      address: location['address']?.toString() ?? 'Mock civic location',
      createdAt: DateTime.tryParse(json['createdAt']?.toString() ?? '') ??
          DateTime.now(),
      history: historyJson
          .map((item) => ComplaintHistory.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }
}

class ComplaintHistory {
  ComplaintHistory({
    required this.status,
    required this.note,
    required this.updatedAt,
  });

  final String status;
  final String note;
  final DateTime updatedAt;

  factory ComplaintHistory.fromJson(Map<String, dynamic> json) {
    return ComplaintHistory(
      status: json['status']?.toString() ?? 'Pending',
      note: json['note']?.toString() ?? '',
      updatedAt:
          DateTime.tryParse(json['updatedAt']?.toString() ?? '') ?? DateTime.now(),
    );
  }
}
