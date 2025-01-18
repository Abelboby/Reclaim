import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/providers/appointments_provider.dart';
import '../../../core/models/medical_professional.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/animations/app_animations.dart';
import 'package:table_calendar/table_calendar.dart';

class ProfessionalConsultationScreen extends StatefulWidget {
  const ProfessionalConsultationScreen({super.key});

  @override
  State<ProfessionalConsultationScreen> createState() => _ProfessionalConsultationScreenState();
}

class _ProfessionalConsultationScreenState extends State<ProfessionalConsultationScreen> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final List<Animation<double>> _animations;
  DateTime _selectedDay = DateTime.now();
  String _selectedSpecialty = 'All';
  String _selectedLanguage = 'All';

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _animations = List.generate(
      3,
      (index) => CurvedAnimation(
        parent: _controller,
        curve: Interval(
          index * 0.1,
          0.6 + (index * 0.1),
          curve: Curves.easeOutCubic,
        ),
      ),
    );

    _controller.forward();

    // Initialize the appointments provider
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AppointmentsProvider>().initialize();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverAppBar(
            expandedHeight: 120,
            floating: false,
            pinned: true,
            stretch: true,
            flexibleSpace: FlexibleSpaceBar(
              title: const Text(
                'Professional Consultation',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                    colors: [
                      AppColors.oceanBlue,
                      AppColors.turquoise,
                    ],
                  ),
                ),
                child: AppAnimations.shimmer(
                  child: Icon(
                    Icons.medical_services,
                    size: 80,
                    color: Colors.white.withOpacity(0.2),
                  ),
                ),
              ),
              stretchModes: const [
                StretchMode.zoomBackground,
                StretchMode.blurBackground,
              ],
            ),
          ),
          SliverToBoxAdapter(
            child: Consumer<AppointmentsProvider>(
              builder: (context, provider, _) {
                if (provider.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (provider.error != null) {
                  return Center(child: Text(provider.error!));
                }

                final professionals = provider.professionals;
                final specialties = ['All', ...professionals.map((p) => p.specialty).toSet()];
                final languages = ['All', ...professionals.expand((p) => p.languages).toSet()];

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 24),
                    AppAnimations.slideUp(
                      animation: _animations[0],
                      child: _buildFilters(specialties, languages),
                    ),
                    const SizedBox(height: 24),
                    AppAnimations.slideUp(
                      animation: _animations[1],
                      child: _buildProfessionalsList(professionals),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilters(List<String> specialties, List<String> languages) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          _buildDropdownFilter(
            'Specialty',
            specialties,
            _selectedSpecialty,
            (value) => setState(() => _selectedSpecialty = value!),
          ),
          const SizedBox(width: 16),
          _buildDropdownFilter(
            'Language',
            languages,
            _selectedLanguage,
            (value) => setState(() => _selectedLanguage = value!),
          ),
        ],
      ),
    );
  }

  Widget _buildDropdownFilter(
    String label,
    List<String> items,
    String selectedValue,
    void Function(String?) onChanged,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(8),
      ),
      child: DropdownButton<String>(
        value: selectedValue,
        items: items.map((item) {
          return DropdownMenuItem(
            value: item,
            child: Text(item),
          );
        }).toList(),
        onChanged: onChanged,
        underline: const SizedBox(),
        style: const TextStyle(
          color: Colors.black87,
          fontSize: 14,
        ),
      ),
    );
  }

  Widget _buildProfessionalsList(List<MedicalProfessional> professionals) {
    final filteredProfessionals = professionals.where((p) {
      final matchesSpecialty = _selectedSpecialty == 'All' || p.specialty == _selectedSpecialty;
      final matchesLanguage = _selectedLanguage == 'All' || p.languages.contains(_selectedLanguage);
      return matchesSpecialty && matchesLanguage;
    }).toList();

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: filteredProfessionals.length,
      itemBuilder: (context, index) {
        return _buildProfessionalCard(filteredProfessionals[index]);
      },
    );
  }

  Widget _buildProfessionalCard(MedicalProfessional professional) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: () => _showBookingDialog(professional),
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundImage: NetworkImage(professional.photoUrl),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          professional.name,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          professional.specialty,
                          style: TextStyle(
                            color: Colors.grey.shade600,
                          ),
                        ),
                        Row(
                          children: [
                            Icon(Icons.star, size: 16, color: Colors.amber.shade600),
                            const SizedBox(width: 4),
                            Text(
                              '${professional.rating} (${professional.reviewCount} reviews)',
                              style: TextStyle(
                                color: Colors.grey.shade600,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                professional.bio,
                style: const TextStyle(fontSize: 14),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  ...professional.qualifications.map((q) => _buildChip(q)),
                  ...professional.languages.map((l) => _buildChip(l, isLanguage: true)),
                ],
              ),
              const SizedBox(height: 12),
              Center(
                child: ElevatedButton(
                  onPressed: () => _showBookingDialog(professional),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.oceanBlue,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                  ),
                  child: const Text('Book Free Consultation'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildChip(String label, {bool isLanguage = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: isLanguage ? AppColors.turquoise.withOpacity(0.1) : Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 12,
          color: isLanguage ? AppColors.turquoise : Colors.grey.shade800,
        ),
      ),
    );
  }

  void _showBookingDialog(MedicalProfessional professional) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _BookingBottomSheet(
        professional: professional,
        selectedDay: _selectedDay,
      ),
    );
  }
}

class _BookingBottomSheet extends StatefulWidget {
  final MedicalProfessional professional;
  final DateTime selectedDay;

  const _BookingBottomSheet({
    required this.professional,
    required this.selectedDay,
  });

  @override
  State<_BookingBottomSheet> createState() => _BookingBottomSheetState();
}

class _BookingBottomSheetState extends State<_BookingBottomSheet> {
  late DateTime _selectedDay;
  TimeSlot? _selectedTimeSlot;
  String? _selectedConsultationType;

  @override
  void initState() {
    super.initState();
    _selectedDay = widget.selectedDay;
    if (widget.professional.availableConsultationTypes.isNotEmpty) {
      _selectedConsultationType = widget.professional.availableConsultationTypes.first;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildHeader(),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildCalendar(),
                  const SizedBox(height: 24),
                  _buildConsultationTypeSelector(),
                  const SizedBox(height: 24),
                  _buildTimeSlots(),
                  const SizedBox(height: 24),
                  _buildBookButton(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade200,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 24,
                backgroundImage: NetworkImage(widget.professional.photoUrl),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.professional.name,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      widget.professional.specialty,
                      style: TextStyle(
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCalendar() {
    return TableCalendar(
      firstDay: DateTime.now(),
      lastDay: DateTime.now().add(const Duration(days: 30)),
      focusedDay: _selectedDay,
      selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
      onDaySelected: (selectedDay, focusedDay) {
        setState(() {
          _selectedDay = selectedDay;
          _selectedTimeSlot = null;
        });
      },
      calendarStyle: const CalendarStyle(
        selectedDecoration: BoxDecoration(
          color: AppColors.oceanBlue,
          shape: BoxShape.circle,
        ),
        todayDecoration: BoxDecoration(
          color: AppColors.turquoise,
          shape: BoxShape.circle,
        ),
      ),
    );
  }

  Widget _buildConsultationTypeSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Consultation Type',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 12,
          children: widget.professional.availableConsultationTypes.map((type) {
            final isSelected = type == _selectedConsultationType;
            return ChoiceChip(
              label: Text(
                type == 'video' ? 'Video Call' : 'In-Person',
                style: TextStyle(
                  color: isSelected ? Colors.white : Colors.grey.shade800,
                ),
              ),
              selected: isSelected,
              selectedColor: AppColors.oceanBlue,
              onSelected: (selected) {
                if (selected) {
                  setState(() => _selectedConsultationType = type);
                }
              },
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildTimeSlots() {
    final slots = widget.professional.getAvailableSlots(_selectedDay);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Available Time Slots',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        if (slots.isEmpty)
          Text(
            'No time slots available for this date',
            style: TextStyle(color: Colors.grey.shade600),
          )
        else
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: slots.map((slot) {
              final isSelected = _selectedTimeSlot == slot;
              return ChoiceChip(
                label: Text(
                  '${slot.startTime.hour}:${slot.startTime.minute.toString().padLeft(2, '0')}',
                  style: TextStyle(
                    color: isSelected ? Colors.white : Colors.grey.shade800,
                  ),
                ),
                selected: isSelected,
                selectedColor: AppColors.oceanBlue,
                onSelected: slot.isBooked
                    ? null
                    : (selected) {
                        if (selected) {
                          setState(() => _selectedTimeSlot = slot);
                        }
                      },
              );
            }).toList(),
          ),
      ],
    );
  }

  Widget _buildBookButton() {
    return ElevatedButton(
      onPressed: _selectedTimeSlot == null || _selectedConsultationType == null
          ? null
          : () {
              context.read<AppointmentsProvider>().bookAppointment(
                    widget.professional.id,
                    _selectedTimeSlot!.startTime,
                    _selectedConsultationType!,
                  );
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Appointment booked successfully!',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      if (_selectedConsultationType == 'video')
                        const Text(
                          'A Google Meet link has been generated and will be available in your profile.',
                          style: TextStyle(fontSize: 12),
                        ),
                    ],
                  ),
                  backgroundColor: Colors.green,
                  duration: const Duration(seconds: 5),
                ),
              );
            },
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.oceanBlue,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      child: const Text(
        'Confirm Booking',
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
} 