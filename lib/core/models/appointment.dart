class Appointment {
  final String id;
  final String doctorId;
  final String doctorName;
  final String doctorSpecialty;
  final String doctorPhotoUrl;
  final DateTime dateTime;
  final String status; // 'upcoming', 'completed', 'cancelled'
  final String consultationType; // 'video', 'in-person'
  final String? meetingLink;
  final String? notes;

  Appointment({
    required this.id,
    required this.doctorId,
    required this.doctorName,
    required this.doctorSpecialty,
    required this.doctorPhotoUrl,
    required this.dateTime,
    required this.status,
    required this.consultationType,
    this.meetingLink,
    this.notes,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'doctorId': doctorId,
      'doctorName': doctorName,
      'doctorSpecialty': doctorSpecialty,
      'doctorPhotoUrl': doctorPhotoUrl,
      'dateTime': dateTime.toIso8601String(),
      'status': status,
      'consultationType': consultationType,
      'meetingLink': meetingLink,
      'notes': notes,
    };
  }

  factory Appointment.fromJson(Map<String, dynamic> json) {
    return Appointment(
      id: json['id'],
      doctorId: json['doctorId'],
      doctorName: json['doctorName'],
      doctorSpecialty: json['doctorSpecialty'],
      doctorPhotoUrl: json['doctorPhotoUrl'],
      dateTime: DateTime.parse(json['dateTime']),
      status: json['status'],
      consultationType: json['consultationType'],
      meetingLink: json['meetingLink'],
      notes: json['notes'],
    );
  }
}
