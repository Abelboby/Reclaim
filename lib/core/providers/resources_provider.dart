import 'package:flutter/foundation.dart';

class ResourcesProvider extends ChangeNotifier {
  bool _isLoading = false;
  String? _error;
  Map<String, List<SubstanceData>> _substanceData = {};
  List<PolicyInsight> _policyInsights = [];

  // Getters
  bool get isLoading => _isLoading;
  String? get error => _error;
  Map<String, List<SubstanceData>> get substanceData => _substanceData;
  List<PolicyInsight> get policyInsights => _policyInsights;

  Future<void> fetchSubstanceData() async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      // TODO: Replace with actual API call
      await Future.delayed(const Duration(seconds: 1));
      _substanceData = _getMockSubstanceData();

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _error = e.toString();
      notifyListeners();
    }
  }

  Future<void> fetchPolicyInsights() async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      // TODO: Replace with actual API call
      await Future.delayed(const Duration(seconds: 1));
      _policyInsights = _getMockPolicyInsights();

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _error = e.toString();
      notifyListeners();
    }
  }

  Map<String, List<SubstanceData>> _getMockSubstanceData() {
    return {
      'Kerala': [
        SubstanceData(
          substance: 'Alcohol',
          incidents: 245,
          recoveryRate: 65.5,
          trend: 'decreasing',
          hotspots: ['Ernakulam', 'Thiruvananthapuram', 'Kozhikode'],
          monthlyChange: -5.2,
        ),
        SubstanceData(
          substance: 'Opioids',
          incidents: 128,
          recoveryRate: 58.2,
          trend: 'stable',
          hotspots: ['Malappuram', 'Thrissur', 'Kannur'],
          monthlyChange: 0.8,
        ),
        SubstanceData(
          substance: 'Cannabis',
          incidents: 312,
          recoveryRate: 72.1,
          trend: 'increasing',
          hotspots: ['Wayanad', 'Idukki', 'Palakkad'],
          monthlyChange: 3.4,
        ),
      ],
    };
  }

  List<PolicyInsight> _getMockPolicyInsights() {
    return [
      PolicyInsight(
        title: 'Early Intervention Program',
        description: 'School-based prevention programs showing 45% reduction in substance abuse cases among youth.',
        impact: 'High',
        status: 'Active',
        implementationRate: 78.5,
        regions: ['Ernakulam', 'Kozhikode', 'Thrissur'],
        successMetrics: {
          'Youth Engagement': 82.0,
          'Parent Participation': 65.5,
          'School Adoption': 91.0,
        },
      ),
      PolicyInsight(
        title: 'Community Outreach Initiative',
        description: 'Local community-based rehabilitation programs with 60% success rate in preventing relapse.',
        impact: 'Medium',
        status: 'Pilot',
        implementationRate: 45.2,
        regions: ['Thiruvananthapuram', 'Kollam'],
        successMetrics: {
          'Community Participation': 72.0,
          'Recovery Rate': 60.0,
          'Cost Effectiveness': 85.0,
        },
      ),
      PolicyInsight(
        title: 'Healthcare Integration',
        description: 'Integration of addiction treatment with primary healthcare showing improved recovery outcomes.',
        impact: 'High',
        status: 'Proposed',
        implementationRate: 25.0,
        regions: ['All Districts'],
        successMetrics: {
          'Healthcare Access': 68.0,
          'Treatment Completion': 55.0,
          'Cost Reduction': 40.0,
        },
      ),
    ];
  }
}

class SubstanceData {
  final String substance;
  final int incidents;
  final double recoveryRate;
  final String trend;
  final List<String> hotspots;
  final double monthlyChange;

  SubstanceData({
    required this.substance,
    required this.incidents,
    required this.recoveryRate,
    required this.trend,
    required this.hotspots,
    required this.monthlyChange,
  });
}

class PolicyInsight {
  final String title;
  final String description;
  final String impact;
  final String status;
  final double implementationRate;
  final List<String> regions;
  final Map<String, double> successMetrics;

  PolicyInsight({
    required this.title,
    required this.description,
    required this.impact,
    required this.status,
    required this.implementationRate,
    required this.regions,
    required this.successMetrics,
  });
} 