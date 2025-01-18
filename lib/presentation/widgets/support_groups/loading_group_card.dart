import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

class LoadingGroupCard extends StatelessWidget {
  const LoadingGroupCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                _buildShimmer(24, 24),
                const SizedBox(width: 8),
                Expanded(child: _buildShimmer(20, 24)),
                const SizedBox(width: 8),
                _buildShimmer(50, 24, radius: 12),
              ],
            ),
            const SizedBox(height: 8),
            _buildShimmer(double.infinity, 16),
            const SizedBox(height: 8),
            _buildShimmer(200, 12),
            const SizedBox(height: 8),
            Row(
              children: [
                _buildShimmer(100, 16),
                const Spacer(),
                _buildShimmer(60, 24, radius: 12),
                const SizedBox(width: 4),
                _buildShimmer(60, 24, radius: 12),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildShimmer(double width, double height, {double radius = 4}) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(radius),
      ),
      child: const SizedBox(),
    );
  }
} 