import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/animations/app_animations.dart';
import 'package:fl_chart/fl_chart.dart';

class AnalyticsScreen extends StatefulWidget {
  const AnalyticsScreen({super.key});

  @override
  State<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final List<Animation<double>> _animations;
  int _selectedTimeRange = 30; // days

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _animations = List.generate(
      4,
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
                'Analytics & Insights',
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
                    Icons.analytics,
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
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 24),
                  AppAnimations.slideUp(
                    animation: _animations[0],
                    child: _buildTimeRangeSelector(),
                  ),
                  const SizedBox(height: 24),
                  AppAnimations.slideUp(
                    animation: _animations[1],
                    child: _buildTrendChart(),
                  ),
                  const SizedBox(height: 24),
                  AppAnimations.slideUp(
                    animation: _animations[2],
                    child: _buildTriggerAnalysis(),
                  ),
                  const SizedBox(height: 24),
                  AppAnimations.slideUp(
                    animation: _animations[3],
                    child: _buildLocationHeatmap(),
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeRangeSelector() {
    return Card(
      elevation: 0,
      color: Colors.grey.shade50,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _timeRangeButton('7D', 7),
            _timeRangeButton('30D', 30),
            _timeRangeButton('3M', 90),
            _timeRangeButton('6M', 180),
            _timeRangeButton('1Y', 365),
          ],
        ),
      ),
    );
  }

  Widget _timeRangeButton(String label, int days) {
    final isSelected = _selectedTimeRange == days;
    return InkWell(
      onTap: () => setState(() => _selectedTimeRange = days),
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.oceanBlue : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.grey.shade700,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget _buildTrendChart() {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        padding: const EdgeInsets.all(20),
        height: 300,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.trending_up,
                  color: AppColors.oceanBlue,
                  size: 24,
                ),
                const SizedBox(width: 12),
                Text(
                  'Recovery Trends',
                  style: TextStyle(
                    color: Colors.grey.shade800,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Expanded(
              child: LineChart(
                LineChartData(
                  gridData: FlGridData(show: false),
                  titlesData: FlTitlesData(show: false),
                  borderData: FlBorderData(show: false),
                  lineBarsData: [
                    LineChartBarData(
                      spots: List.generate(
                        7,
                        (index) => FlSpot(index.toDouble(), index % 3 == 0 ? 3 : 2),
                      ),
                      isCurved: true,
                      color: AppColors.oceanBlue,
                      barWidth: 3,
                      isStrokeCapRound: true,
                      dotData: FlDotData(show: false),
                      belowBarData: BarAreaData(
                        show: true,
                        color: AppColors.oceanBlue.withOpacity(0.1),
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

  Widget _buildTriggerAnalysis() {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.psychology,
                  color: AppColors.oceanBlue,
                  size: 24,
                ),
                const SizedBox(width: 12),
                Text(
                  'Trigger Analysis',
                  style: TextStyle(
                    color: Colors.grey.shade800,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            _buildTriggerItem('Stress', 75),
            const SizedBox(height: 12),
            _buildTriggerItem('Social Pressure', 60),
            const SizedBox(height: 12),
            _buildTriggerItem('Negative Emotions', 45),
            const SizedBox(height: 12),
            _buildTriggerItem('Environmental Cues', 30),
          ],
        ),
      ),
    );
  }

  Widget _buildTriggerItem(String label, double percentage) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: TextStyle(
                color: Colors.grey.shade700,
                fontSize: 14,
              ),
            ),
            Text(
              '${percentage.toInt()}%',
              style: TextStyle(
                color: AppColors.oceanBlue,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        TweenAnimationBuilder<double>(
          duration: const Duration(milliseconds: 1000),
          tween: Tween(begin: 0, end: percentage),
          builder: (context, value, child) {
            return LinearProgressIndicator(
              value: value / 100,
              backgroundColor: Colors.grey.shade200,
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.oceanBlue),
              borderRadius: BorderRadius.circular(4),
            );
          },
        ),
      ],
    );
  }

  Widget _buildLocationHeatmap() {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.location_on,
                  color: AppColors.oceanBlue,
                  size: 24,
                ),
                const SizedBox(width: 12),
                Text(
                  'High-Risk Areas',
                  style: TextStyle(
                    color: Colors.grey.shade800,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Container(
              height: 200,
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Text(
                  'Heatmap visualization will be implemented here',
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
} 