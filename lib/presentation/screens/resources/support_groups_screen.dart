import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/providers/support_groups_provider.dart';
import '../../widgets/support_groups/group_card.dart';
import '../../widgets/support_groups/loading_group_card.dart';
import 'support_group_details_screen.dart';

class SupportGroupsScreen extends StatefulWidget {
  const SupportGroupsScreen({super.key});

  @override
  State<SupportGroupsScreen> createState() => _SupportGroupsScreenState();
}

class _SupportGroupsScreenState extends State<SupportGroupsScreen> {
  final _searchController = TextEditingController();
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = context.read<SupportGroupsProvider>();
      provider.fetchNearbyGroups();
      provider.fetchOnlineCommunities();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Support Groups'),
        centerTitle: true,
      ),
      body: Consumer<SupportGroupsProvider>(
        builder: (context, provider, child) {
          if (provider.error != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.error_outline,
                    size: 48,
                    color: Colors.red,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    provider.error!,
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.red),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      provider.fetchNearbyGroups();
                      provider.fetchOnlineCommunities();
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () async {
              await Future.wait([
                provider.fetchNearbyGroups(),
                provider.fetchOnlineCommunities(),
              ]);
            },
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(),
                  const SizedBox(height: 24),
                  _buildSearchBar(),
                  const SizedBox(height: 24),
                  _buildLocalGroups(provider),
                  const SizedBox(height: 24),
                  _buildOnlineCommunities(provider),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Icon(
          Icons.group_outlined,
          size: 48,
          color: AppColors.oceanBlue,
        ),
        const SizedBox(height: 16),
        Text(
          'Find Your Support Network',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: AppColors.oceanBlue,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Connect with others on the recovery journey',
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }

  Widget _buildSearchBar() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Consumer<SupportGroupsProvider>(
              builder: (context, provider, child) {
                return TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Search support groups...',
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: _isSearching
                        ? IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              _searchController.clear();
                              setState(() {
                                _isSearching = false;
                              });
                              provider.search('');
                            },
                          )
                        : null,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  onChanged: (value) {
                    setState(() {
                      _isSearching = value.isNotEmpty;
                    });
                    provider.search(value);
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLocalGroups(SupportGroupsProvider provider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Local Support Groups',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        if (provider.isLoading)
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 3,
            separatorBuilder: (context, index) => const SizedBox(height: 16),
            itemBuilder: (context, index) => const LoadingGroupCard(),
          )
        else if (provider.groups.isEmpty)
          Center(
            child: Column(
              children: [
                const Icon(
                  Icons.location_off,
                  size: 48,
                  color: Colors.grey,
                ),
                const SizedBox(height: 16),
                const Text(
                  'No local groups found',
                  style: TextStyle(color: Colors.grey),
                ),
                const SizedBox(height: 8),
                ElevatedButton(
                  onPressed: () => provider.fetchNearbyGroups(),
                  child: const Text('Try Again'),
                ),
              ],
            ),
          )
        else
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: provider.groups.length,
            separatorBuilder: (context, index) => const SizedBox(height: 16),
            itemBuilder: (context, index) {
              final group = provider.groups[index];
              return GroupCard(
                group: group,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SupportGroupDetailsScreen(group: group),
                    ),
                  );
                },
              );
            },
          ),
      ],
    );
  }

  Widget _buildOnlineCommunities(SupportGroupsProvider provider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Online Communities',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        if (provider.isLoading)
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 3,
            separatorBuilder: (context, index) => const SizedBox(height: 16),
            itemBuilder: (context, index) => const LoadingGroupCard(),
          )
        else if (provider.onlineCommunities.isEmpty)
          const Center(
            child: Text(
              'No online communities available',
              style: TextStyle(color: Colors.grey),
            ),
          )
        else
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: provider.onlineCommunities.length,
            separatorBuilder: (context, index) => const SizedBox(height: 16),
            itemBuilder: (context, index) {
              final community = provider.onlineCommunities[index];
              return GroupCard(
                group: community,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SupportGroupDetailsScreen(group: community),
                    ),
                  );
                },
              );
            },
          ),
      ],
    );
  }
} 