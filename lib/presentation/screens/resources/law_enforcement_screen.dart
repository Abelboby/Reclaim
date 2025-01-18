import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/animations/app_animations.dart';
import '../../../core/providers/resources_provider.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';

class LawEnforcementScreen extends StatefulWidget {
  const LawEnforcementScreen({super.key});

  @override
  State<LawEnforcementScreen> createState() => _LawEnforcementScreenState();
}

class _LawEnforcementScreenState extends State<LawEnforcementScreen> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final List<Animation<double>> _animations;
  String _selectedRegion = 'Kerala';

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
    
    // Fetch data when screen loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<ResourcesProvider>(context, listen: false);
      provider.fetchSubstanceData();
      provider.fetchPolicyInsights();
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
                'Law Enforcement & Policy',
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
                    Icons.policy,
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
            child: Consumer<ResourcesProvider>(
              builder: (context, provider, _) {
                if (provider.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (provider.error != null) {
                  return Center(child: Text(provider.error!));
                }

                final substanceData = provider.substanceData[_selectedRegion] ?? [];
                final policyInsights = provider.policyInsights;

                return SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 24),
                      AppAnimations.slideUp(
                        animation: _animations[0],
                        child: _buildSubstanceDataOverview(substanceData),
                      ),
                      const SizedBox(height: 24),
                      AppAnimations.slideUp(
                        animation: _animations[1],
                        child: _buildTrendAnalysis(substanceData),
                      ),
                      const SizedBox(height: 24),
                      AppAnimations.slideUp(
                        animation: _animations[2],
                        child: _buildPolicyInsights(policyInsights),
                      ),
                      const SizedBox(height: 24),
                      AppAnimations.slideUp(
                        animation: _animations[3],
                        child: _buildHotspotMap(substanceData),
                      ),
                      const SizedBox(height: 32),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubstanceDataOverview(List<SubstanceData> data) {
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
                  Icons.analytics_outlined,
                  color: AppColors.oceanBlue,
                  size: 24,
                ),
                const SizedBox(width: 12),
                Text(
                  'Substance Data Overview',
                  style: TextStyle(
                    color: Colors.grey.shade800,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            ...data.map((item) => _buildSubstanceItem(item)).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildSubstanceItem(SubstanceData data) {
    final trendColor = data.trend == 'increasing' 
        ? Colors.red 
        : data.trend == 'decreasing' 
            ? Colors.green 
            : Colors.orange;

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  data.substance,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${data.incidents} incidents',
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Icon(
                      data.trend == 'increasing' 
                          ? Icons.trending_up 
                          : data.trend == 'decreasing' 
                              ? Icons.trending_down 
                              : Icons.trending_flat,
                      color: trendColor,
                      size: 20,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${data.monthlyChange.abs()}%',
                      style: TextStyle(
                        color: trendColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  'Recovery rate: ${data.recoveryRate}%',
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTrendAnalysis(List<SubstanceData> data) {
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
                  Icons.show_chart,
                  color: AppColors.oceanBlue,
                  size: 24,
                ),
                const SizedBox(width: 12),
                Text(
                  'Recovery Rate Trends',
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
                  lineBarsData: data.map((item) {
                    final color = item.trend == 'increasing' 
                        ? Colors.red 
                        : item.trend == 'decreasing' 
                            ? Colors.green 
                            : Colors.orange;
                    
                    return LineChartBarData(
                      spots: List.generate(
                        6,
                        (index) => FlSpot(
                          index.toDouble(),
                          item.recoveryRate + (index * item.monthlyChange / 2),
                        ),
                      ),
                      isCurved: true,
                      color: color,
                      barWidth: 3,
                      isStrokeCapRound: true,
                      dotData: FlDotData(show: false),
                      belowBarData: BarAreaData(
                        show: true,
                        color: color.withOpacity(0.1),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPolicyInsights(List<PolicyInsight> insights) {
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
                  Icons.policy,
                  color: AppColors.oceanBlue,
                  size: 24,
                ),
                const SizedBox(width: 12),
                Text(
                  'Policy Insights',
                  style: TextStyle(
                    color: Colors.grey.shade800,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            ...insights.map((insight) => _buildPolicyItem(insight)).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildPolicyItem(PolicyInsight insight) {
    final statusColor = insight.status == 'Active' 
        ? Colors.green 
        : insight.status == 'Pilot' 
            ? Colors.orange 
            : Colors.blue;

    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  insight.title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  insight.status,
                  style: TextStyle(
                    color: statusColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            insight.description,
            style: TextStyle(
              color: Colors.grey.shade600,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 12),
          LinearProgressIndicator(
            value: insight.implementationRate / 100,
            backgroundColor: Colors.grey.shade200,
            valueColor: AlwaysStoppedAnimation<Color>(AppColors.oceanBlue),
            borderRadius: BorderRadius.circular(4),
          ),
          const SizedBox(height: 4),
          Text(
            'Implementation: ${insight.implementationRate}%',
            style: TextStyle(
              color: Colors.grey.shade600,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHotspotMap(List<SubstanceData> data) {
    final allHotspots = data.expand((item) => item.hotspots).toSet().toList();

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
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: allHotspots.map((hotspot) {
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppColors.oceanBlue.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    hotspot,
                    style: TextStyle(
                      color: AppColors.oceanBlue,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
} 