class TimeSlot {
  final String id;
  final DateTime startTime;
  final DateTime endTime;
  final bool isBooked;

  TimeSlot({
    required this.id,
    required this.startTime,
    required this.endTime,
    this.isBooked = false,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'startTime': startTime.toIso8601String(),
      'endTime': endTime.toIso8601String(),
      'isBooked': isBooked,
    };
  }

  factory TimeSlot.fromJson(Map<String, dynamic> json) {
    return TimeSlot(
      id: json['id'],
      startTime: DateTime.parse(json['startTime']),
      endTime: DateTime.parse(json['endTime']),
      isBooked: json['isBooked'],
    );
  }
}

class MedicalProfessional {
  final String id;
  final String name;
  final String specialty;
  final List<String> qualifications;
  final String bio;
  final double rating;
  final int reviewCount;
  final List<String> languages;
  final String photoUrl;
  final int yearsOfExperience;
  final List<String> availableConsultationTypes; // ['video', 'in-person']

  MedicalProfessional({
    required this.id,
    required this.name,
    required this.specialty,
    required this.qualifications,
    required this.bio,
    required this.rating,
    required this.reviewCount,
    required this.languages,
    required this.photoUrl,
    required this.yearsOfExperience,
    required this.availableConsultationTypes,
  });

  // Generate available time slots for a given date
  List<TimeSlot> getAvailableSlots(DateTime date) {
    final slots = <TimeSlot>[];
    final startHour = 9; // 9 AM
    final endHour = 17; // 5 PM

    for (int hour = startHour; hour < endHour; hour++) {
      slots.add(
        TimeSlot(
          id: '${date.toIso8601String()}_$hour',
          startTime: DateTime(date.year, date.month, date.day, hour),
          endTime: DateTime(date.year, date.month, date.day, hour + 1),
        ),
      );
    }

    return slots;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'specialty': specialty,
      'qualifications': qualifications,
      'bio': bio,
      'rating': rating,
      'reviewCount': reviewCount,
      'languages': languages,
      'photoUrl': photoUrl,
      'yearsOfExperience': yearsOfExperience,
      'availableConsultationTypes': availableConsultationTypes,
    };
  }

  factory MedicalProfessional.fromJson(Map<String, dynamic> json) {
    return MedicalProfessional(
      id: json['id'],
      name: json['name'],
      specialty: json['specialty'],
      qualifications: List<String>.from(json['qualifications']),
      bio: json['bio'],
      rating: json['rating'].toDouble(),
      reviewCount: json['reviewCount'],
      languages: List<String>.from(json['languages']),
      photoUrl: json['photoUrl'],
      yearsOfExperience: json['yearsOfExperience'],
      availableConsultationTypes:
          List<String>.from(json['availableConsultationTypes']),
    );
  }
}
