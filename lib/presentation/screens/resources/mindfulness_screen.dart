import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import 'dart:async';
import 'package:audioplayers/audioplayers.dart';

class MindfulnessScreen extends StatefulWidget {
  const MindfulnessScreen({super.key});

  @override
  State<MindfulnessScreen> createState() => _MindfulnessScreenState();
}

class _MindfulnessScreenState extends State<MindfulnessScreen> with SingleTickerProviderStateMixin {
  late AnimationController _breathingController;
  late Animation<double> _breathingAnimation;
  Timer? _breathingTimer;
  String _breathingPhase = 'Inhale';
  int _breathingCount = 0;
  bool _isBreathingActive = false;
  final AudioPlayer _audioPlayer = AudioPlayer();
  Timer? _meditationTimer;
  int _remainingSeconds = 0;
  bool _isMeditating = false;

  @override
  void initState() {
    super.initState();
    _breathingController = AnimationController(
      duration: const Duration(seconds: 4),
      vsync: this,
    );
    _breathingAnimation = Tween<double>(begin: 1.0, end: 1.5).animate(
      CurvedAnimation(
        parent: _breathingController,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _breathingController.dispose();
    _breathingTimer?.cancel();
    _meditationTimer?.cancel();
    _audioPlayer.dispose();
    super.dispose();
  }

  void _startBreathingExercise() {
    setState(() {
      _isBreathingActive = true;
      _breathingCount = 0;
      _breathingPhase = 'Inhale';
    });

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => _BreathingOverlay(
        animation: _breathingAnimation,
        phase: _breathingPhase,
        count: _breathingCount,
        onClose: () {
          _stopBreathingExercise();
          Navigator.pop(context);
        },
      ),
    );

    _breathingController.repeat(reverse: true);
    
    _breathingTimer = Timer.periodic(const Duration(seconds: 4), (timer) {
      if (!_isBreathingActive) {
        timer.cancel();
        return;
      }
      
      setState(() {
        if (_breathingPhase == 'Inhale') {
          _breathingPhase = 'Hold';
        } else if (_breathingPhase == 'Hold') {
          _breathingPhase = 'Exhale';
        } else {
          _breathingPhase = 'Inhale';
          _breathingCount++;  // Increment count after each complete cycle
        }
      });

      // Rebuild the overlay with updated values
      if (context.mounted) {
        Navigator.pop(context);
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => _BreathingOverlay(
            animation: _breathingAnimation,
            phase: _breathingPhase,
            count: _breathingCount,
            onClose: () {
              _stopBreathingExercise();
              Navigator.pop(context);
            },
          ),
        );
      }
    });
  }

  void _stopBreathingExercise() {
    setState(() {
      _isBreathingActive = false;
    });
    _breathingController.stop();
    _breathingTimer?.cancel();
  }

  void _startMeditationTimer(int minutes) {
    setState(() {
      _isMeditating = true;
      _remainingSeconds = minutes * 60;
    });

    _audioPlayer.play(AssetSource('sounds/meditation_bell.mp3'));

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => StreamBuilder<int>(
        stream: Stream.periodic(const Duration(seconds: 1), (i) => _remainingSeconds - i - 1)
            .take(_remainingSeconds),
        builder: (context, snapshot) {
          final seconds = snapshot.data ?? _remainingSeconds;
          if (seconds <= 0) {
            _isMeditating = false;
            _audioPlayer.play(AssetSource('sounds/meditation_bell.mp3'));
            Future.delayed(const Duration(seconds: 1), () {
              if (context.mounted) Navigator.pop(context);
            });
          }
          return _MeditationTimerOverlay(
            remainingSeconds: seconds,
            onClose: () {
              _stopMeditationTimer();
              Navigator.pop(context);
            },
          );
        },
      ),
    );
  }

  void _stopMeditationTimer() {
    setState(() {
      _isMeditating = false;
      _remainingSeconds = 0;
    });
    _meditationTimer?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mindfulness'),
        centerTitle: true,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.white,
              AppColors.turquoise.withOpacity(0.1),
            ],
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              const SizedBox(height: 24),
              _buildBreathingExercise(),
              const SizedBox(height: 24),
              _buildMeditationTimer(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.oceanBlue,
            AppColors.turquoise,
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.oceanBlue.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.self_improvement,
              size: 48,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Mindfulness Practice',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Take a moment to breathe and center yourself',
            style: TextStyle(
              fontSize: 16,
              color: Colors.white,
              fontWeight: FontWeight.w300,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBreathingExercise() {
    return Card(
      elevation: 8,
      shadowColor: AppColors.oceanBlue.withOpacity(0.2),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.white,
              AppColors.oceanBlue.withOpacity(0.05),
            ],
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.oceanBlue.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.air,
                    size: 24,
                    color: AppColors.oceanBlue,
                  ),
                ),
                const SizedBox(width: 12),
                const Text(
                  'Breathing Exercise',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Text(
              'Follow the animation to practice deep breathing. Inhale as the circle expands, hold, then exhale as it contracts.',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 15,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: _startBreathingExercise,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.oceanBlue,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 16,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  elevation: 4,
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.play_arrow),
                    SizedBox(width: 8),
                    Text(
                      'Start Breathing Exercise',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMeditationTimer() {
    return Card(
      elevation: 8,
      shadowColor: AppColors.turquoise.withOpacity(0.2),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.white,
              AppColors.turquoise.withOpacity(0.05),
            ],
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.turquoise.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.timer,
                    size: 24,
                    color: AppColors.turquoise,
                  ),
                ),
                const SizedBox(width: 12),
                const Text(
                  'Meditation Timer',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Text(
              'Choose a duration for your meditation. A bell will sound at the start and end.',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 15,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 20),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              alignment: WrapAlignment.center,
              children: [
                _buildTimerButton(5),
                _buildTimerButton(10),
                _buildTimerButton(15),
                _buildTimerButton(20),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimerButton(int minutes) {
    return SizedBox(
      width: 80,
      height: 80,
      child: ElevatedButton(
        onPressed: () => _startMeditationTimer(minutes),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.turquoise,
          foregroundColor: Colors.white,
          padding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          elevation: 4,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '$minutes',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Text(
              'min',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w300,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BreathingOverlay extends StatelessWidget {
  final Animation<double> animation;
  final String phase;
  final int count;
  final VoidCallback onClose;

  const _BreathingOverlay({
    required this.animation,
    required this.phase,
    required this.count,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black.withOpacity(0.9),
      child: Stack(
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ScaleTransition(
                  scale: animation,
                  child: Container(
                    width: 200,
                    height: 200,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppColors.turquoise,
                        width: 4,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.turquoise.withOpacity(0.3),
                          blurRadius: 20,
                          spreadRadius: 5,
                        ),
                      ],
                    ),
                    child: Center(
                      child: Text(
                        phase,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 40),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Text(
                    'Breath count: $count',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top: 40,
            right: 16,
            child: IconButton(
              icon: const Icon(
                Icons.close,
                color: Colors.white,
                size: 32,
              ),
              onPressed: onClose,
            ),
          ),
        ],
      ),
    );
  }
}

class _MeditationTimerOverlay extends StatelessWidget {
  final int remainingSeconds;
  final VoidCallback onClose;

  const _MeditationTimerOverlay({
    required this.remainingSeconds,
    required this.onClose,
  });

  String _formatDuration(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black.withOpacity(0.9),
      child: Stack(
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.self_improvement,
                    size: 80,
                    color: Colors.white70,
                  ),
                ),
                const SizedBox(height: 40),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 40,
                    vertical: 20,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.turquoise.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(40),
                    border: Border.all(
                      color: AppColors.turquoise.withOpacity(0.3),
                      width: 2,
                    ),
                  ),
                  child: Text(
                    _formatDuration(remainingSeconds),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 64,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top: 40,
            right: 16,
            child: IconButton(
              icon: const Icon(
                Icons.close,
                color: Colors.white,
                size: 32,
              ),
              onPressed: onClose,
            ),
          ),
        ],
      ),
    );
  }
} 