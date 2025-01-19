import 'package:flutter/foundation.dart';
import '../models/appointment.dart';
import '../models/medical_professional.dart';

class AppointmentsProvider extends ChangeNotifier {
  bool _isLoading = false;
  String? _error;
  List<Appointment> _appointments = [];
  List<MedicalProfessional> _professionals = [];

  // Getters
  bool get isLoading => _isLoading;
  String? get error => _error;
  List<Appointment> get appointments => _appointments;
  List<MedicalProfessional> get professionals => _professionals;

  List<Appointment> get upcomingAppointments => _appointments
      .where((apt) =>
          apt.status == 'upcoming' && apt.dateTime.isAfter(DateTime.now()))
      .toList()
    ..sort((a, b) => a.dateTime.compareTo(b.dateTime));

  List<Appointment> get pastAppointments => _appointments
      .where((apt) =>
          apt.status == 'completed' || apt.dateTime.isBefore(DateTime.now()))
      .toList()
    ..sort((a, b) => b.dateTime.compareTo(a.dateTime));

  // Initialize with mock data for now
  Future<void> initialize() async {
    try {
      _isLoading = true;
      notifyListeners();

      // TODO: Replace with actual API calls
      await Future.delayed(const Duration(seconds: 1));
      _professionals = _getMockProfessionals();
      _appointments = _getMockAppointments();

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _error = e.toString();
      notifyListeners();
    }
  }

  String _generateGoogleMeetLink() {
    // In a real app, this would integrate with Google Calendar API
    // For now, we'll generate a mock link
    final meetId =
        DateTime.now().millisecondsSinceEpoch.toString().substring(5);
    return 'https://meet.google.com/$meetId';
  }

  Future<void> bookAppointment(
      String doctorId, DateTime dateTime, String consultationType) async {
    try {
      _isLoading = true;
      notifyListeners();

      // TODO: Replace with actual API call
      await Future.delayed(const Duration(seconds: 1));

      final doctor = _professionals.firstWhere((p) => p.id == doctorId);
      final meetingLink =
          consultationType == 'video' ? _generateGoogleMeetLink() : null;

      final appointment = Appointment(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        doctorId: doctorId,
        doctorName: doctor.name,
        doctorSpecialty: doctor.specialty,
        doctorPhotoUrl: doctor.photoUrl,
        dateTime: dateTime,
        status: 'upcoming',
        consultationType: consultationType,
        meetingLink: meetingLink,
      );

      _appointments.add(appointment);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _error = e.toString();
      notifyListeners();
    }
  }

  Future<void> cancelAppointment(String appointmentId) async {
    try {
      _isLoading = true;
      notifyListeners();

      // TODO: Replace with actual API call
      await Future.delayed(const Duration(seconds: 1));

      final index = _appointments.indexWhere((apt) => apt.id == appointmentId);
      if (index != -1) {
        _appointments.removeAt(index);
      }

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _error = e.toString();
      notifyListeners();
    }
  }

  List<MedicalProfessional> _getMockProfessionals() {
    return [
      MedicalProfessional(
        id: '1',
        name: 'Dr. Sarah Johnson',
        specialty: 'Addiction Psychiatrist',
        qualifications: ['MD', 'PhD in Psychiatry'],
        bio:
            'Specialized in addiction treatment with 15 years of experience in helping patients overcome substance abuse.',
        rating: 4.8,
        reviewCount: 124,
        languages: ['English', 'Malayalam'],
        photoUrl: 'https://example.com/doctor1.jpg',
        yearsOfExperience: 15,
        availableConsultationTypes: ['video', 'in-person'],
      ),
      MedicalProfessional(
        id: '2',
        name: 'Dr. Rajesh Kumar',
        specialty: 'Clinical Psychologist',
        qualifications: ['PsyD', 'Certified Addiction Counselor'],
        bio:
            'Expert in cognitive behavioral therapy and addiction counseling with a focus on holistic recovery.',
        rating: 4.9,
        reviewCount: 98,
        languages: ['English', 'Malayalam', 'Hindi'],
        photoUrl: 'https://example.com/doctor2.jpg',
        yearsOfExperience: 12,
        availableConsultationTypes: ['video'],
      ),
    ];
  }

  List<Appointment> _getMockAppointments() {
    // Start with no appointments
    return [];
  }
}
