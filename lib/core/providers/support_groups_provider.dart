import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import '../models/support_group.dart';

class SupportGroupsProvider extends ChangeNotifier {
  List<SupportGroup> _groups = [];
  List<SupportGroup> _onlineCommunities = [];
  List<SupportGroup> _filteredGroups = [];
  List<SupportGroup> _filteredCommunities = [];
  bool _isLoading = false;
  String? _error;
  Position? _currentLocation;
  String _searchQuery = '';

  // Getters
  List<SupportGroup> get groups => _searchQuery.isEmpty ? _groups : _filteredGroups;
  List<SupportGroup> get onlineCommunities => _searchQuery.isEmpty ? _onlineCommunities : _filteredCommunities;
  bool get isLoading => _isLoading;
  String? get error => _error;
  Position? get currentLocation => _currentLocation;
  String get searchQuery => _searchQuery;

  // Search functionality
  void search(String query) {
    _searchQuery = query.toLowerCase();
    if (_searchQuery.isEmpty) {
      _filteredGroups = [];
      _filteredCommunities = [];
    } else {
      _filteredGroups = _groups.where((group) => 
        group.name.toLowerCase().contains(_searchQuery) ||
        group.description.toLowerCase().contains(_searchQuery) ||
        group.tags.any((tag) => tag.toLowerCase().contains(_searchQuery)) ||
        (group.address.isNotEmpty && group.address.toLowerCase().contains(_searchQuery))
      ).toList();

      _filteredCommunities = _onlineCommunities.where((community) =>
        community.name.toLowerCase().contains(_searchQuery) ||
        community.description.toLowerCase().contains(_searchQuery) ||
        community.tags.any((tag) => tag.toLowerCase().contains(_searchQuery))
      ).toList();
    }
    notifyListeners();
  }

  // Get nearby groups based on current location
  Future<void> fetchNearbyGroups() async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      // Get mock data regardless of location
      await Future.delayed(const Duration(seconds: 1));
      _groups = _getMockGroups();
      
      // Try to get location in background
      _getCurrentLocation().then((position) {
        _currentLocation = position;
        // TODO: In the future, we can use this location to sort groups by distance
        notifyListeners();
      }).catchError((e) {
        // Silently handle location errors
        _currentLocation = null;
      });

      if (_searchQuery.isNotEmpty) {
        search(_searchQuery);
      }

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _error = e.toString();
      notifyListeners();
    }
  }

  // Fetch online communities
  Future<void> fetchOnlineCommunities() async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      // TODO: Implement API call to fetch online communities
      // For now, using mock data
      await Future.delayed(const Duration(seconds: 1));
      _onlineCommunities = _getMockOnlineCommunities();
      if (_searchQuery.isNotEmpty) {
        search(_searchQuery);
      }

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _error = e.toString();
      notifyListeners();
    }
  }

  // Get current location
  Future<Position?> _getCurrentLocation() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        return null;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          return null;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        return null;
      }

      return await Geolocator.getCurrentPosition();
    } catch (e) {
      return null;
    }
  }

  // Mock data methods
  List<SupportGroup> _getMockGroups() {
    return [
      SupportGroup(
        id: '1',
        name: 'Kochi Recovery Center',
        description: 'Professional addiction recovery support with experienced counselors',
        address: 'MG Road, Ernakulam, Kochi, Kerala',
        latitude: 9.9816,
        longitude: 76.2999,
        meetingSchedule: 'Every Monday and Wednesday at 6 PM',
        memberCount: 45,
        rating: 4.7,
        tags: ['Alcohol', 'Drugs', 'Professional'],
      ),
      SupportGroup(
        id: '2',
        name: 'Trivandrum Healing Circle',
        description: 'A supportive community for individuals and families affected by addiction',
        address: 'Vazhuthacaud, Thiruvananthapuram, Kerala',
        latitude: 8.4855,
        longitude: 76.9492,
        meetingSchedule: 'Tuesdays and Fridays at 5:30 PM',
        memberCount: 30,
        rating: 4.8,
        tags: ['Family', 'Support', 'Counseling'],
      ),
      SupportGroup(
        id: '3',
        name: 'Calicut Wellness Community',
        description: 'Join our community dedicated to recovery and mental wellness',
        address: 'Beach Road, Kozhikode, Kerala',
        latitude: 11.2588,
        longitude: 75.7804,
        meetingSchedule: 'Daily meetings at 7 PM',
        memberCount: 55,
        rating: 4.5,
        tags: ['Daily', 'Community', 'Mental Health'],
      ),
      SupportGroup(
        id: '4',
        name: 'Thrissur Recovery Group',
        description: 'A safe and supportive environment for addiction recovery',
        address: 'MG Road, Thrissur, Kerala',
        latitude: 10.5276,
        longitude: 76.2144,
        meetingSchedule: 'Thursdays and Sundays at 6 PM',
        memberCount: 35,
        rating: 4.6,
        tags: ['Support', 'Weekly', 'Group Therapy'],
      ),
      SupportGroup(
        id: '5',
        name: 'Malappuram Support Network',
        description: 'Local support group focusing on youth recovery and prevention',
        address: 'Down Hill, Malappuram, Kerala',
        latitude: 11.0509,
        longitude: 76.0710,
        meetingSchedule: 'Every Saturday at 5 PM',
        memberCount: 25,
        rating: 4.4,
        tags: ['Youth', 'Prevention', 'Support'],
      ),
    ];
  }

  List<SupportGroup> _getMockOnlineCommunities() {
    return [
      SupportGroup(
        id: '101',
        name: 'Kerala Recovery Network',
        description: '24/7 online support group for Malayalam speakers in recovery',
        memberCount: 800,
        rating: 4.8,
        tags: ['Malayalam', '24/7', 'Online'],
        isOnline: true,
      ),
      SupportGroup(
        id: '102',
        name: 'Morning Motivation Kerala',
        description: 'Start your day with motivation and support in Malayalam',
        memberCount: 450,
        rating: 4.6,
        tags: ['Morning', 'Motivation', 'Malayalam'],
        isOnline: true,
        meetingSchedule: 'Daily at 7 AM IST',
      ),
      SupportGroup(
        id: '103',
        name: 'Kerala Youth Recovery',
        description: 'Online community for young Malayalis supporting each other in recovery',
        memberCount: 600,
        rating: 4.7,
        tags: ['Youth', 'Malayalam', 'Support'],
        isOnline: true,
        meetingSchedule: 'Wednesdays and Sundays at 8 PM IST',
      ),
      SupportGroup(
        id: '104',
        name: 'Family Support Kerala',
        description: 'Online support group for families affected by addiction in Kerala',
        memberCount: 350,
        rating: 4.9,
        tags: ['Family', 'Support', 'Malayalam'],
        isOnline: true,
        meetingSchedule: 'Tuesdays and Fridays at 7:30 PM IST',
      ),
      SupportGroup(
        id: '105',
        name: 'Mindful Kerala',
        description: 'Combining traditional Kerala wellness practices with recovery support',
        memberCount: 550,
        rating: 4.8,
        tags: ['Ayurveda', 'Meditation', 'Wellness'],
        isOnline: true,
        meetingSchedule: 'Daily guided sessions at 6 AM and 6 PM IST',
      ),
    ];
  }
} 