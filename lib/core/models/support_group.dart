class SupportGroup {
  final String id;
  final String name;
  final String description;
  final String address;
  final double latitude;
  final double longitude;
  final String meetingSchedule;
  final int memberCount;
  final double rating;
  final List<String> tags;
  final bool isOnline;

  SupportGroup({
    required this.id,
    required this.name,
    required this.description,
    this.address = '',
    this.latitude = 0.0,
    this.longitude = 0.0,
    this.meetingSchedule = '',
    this.memberCount = 0,
    this.rating = 0.0,
    this.tags = const [],
    this.isOnline = false,
  });

  factory SupportGroup.fromJson(Map<String, dynamic> json) {
    return SupportGroup(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      address: json['address'] as String? ?? '',
      latitude: (json['latitude'] as num?)?.toDouble() ?? 0.0,
      longitude: (json['longitude'] as num?)?.toDouble() ?? 0.0,
      meetingSchedule: json['meetingSchedule'] as String? ?? '',
      memberCount: json['memberCount'] as int? ?? 0,
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      tags: (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList() ?? [],
      isOnline: json['isOnline'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'address': address,
      'latitude': latitude,
      'longitude': longitude,
      'meetingSchedule': meetingSchedule,
      'memberCount': memberCount,
      'rating': rating,
      'tags': tags,
      'isOnline': isOnline,
    };
  }
} 