import 'package:flutter/material.dart';
import '../home/home_screen.dart';
import '../resources/resources_screen.dart';
import '../support/support_intro_screen.dart';
import '../profile/profile_screen.dart';
import '../report/report_screen.dart';
import '../../../core/constants/app_colors.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> with SingleTickerProviderStateMixin {
  int _selectedIndex = 0;
  late AnimationController _animationController;
  late Animation<double> _rotationAnimation;
  late Animation<double> _scaleAnimation;

  final List<Widget> _screens = const [
    HomeScreen(),
    ResourcesScreen(),
    SupportIntroScreen(),
    ProfileScreen(),
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    
    _rotationAnimation = Tween(begin: 0.0, end: 0.25)
        .animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOutBack,
    ));

    _scaleAnimation = Tween(begin: 1.0, end: 0.8)
        .animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _onFabTapped() async {
    await _animationController.forward();
    if (!mounted) return;
    
    await Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) {
          return FadeTransition(
            opacity: animation,
            child: const ReportScreen(),
          );
        },
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(0.0, 0.3);
          const end = Offset.zero;
          const curve = Curves.easeOutCubic;
          
          var tween = Tween(begin: begin, end: end)
              .chain(CurveTween(curve: curve));
          var offsetAnimation = animation.drive(tween);
          
          return SlideTransition(
            position: offsetAnimation,
            child: child,
          );
        },
        transitionDuration: const Duration(milliseconds: 400),
        reverseTransitionDuration: const Duration(milliseconds: 300),
      ),
    );
    
    await _animationController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      floatingActionButton: ScaleTransition(
        scale: _scaleAnimation,
        child: Container(
          height: 64,
          width: 64,
          margin: const EdgeInsets.only(top: 30),
          child: FloatingActionButton(
            backgroundColor: AppColors.turquoise,
            elevation: 8,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(32),
            ),
            onPressed: _onFabTapped,
            child: RotationTransition(
              turns: _rotationAnimation,
              child: const Icon(
                Icons.add,
                size: 32,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        height: 65,
        padding: EdgeInsets.zero,
        shape: const CircularNotchedRectangle(),
        notchMargin: 12,
        color: Theme.of(context).colorScheme.surface,
        elevation: 8,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Expanded(
              child: _buildNavItem(0, Icons.home_outlined, Icons.home, 'Home'),
            ),
            Expanded(
              child: _buildNavItem(1, Icons.library_books_outlined, Icons.library_books, 'Resources'),
            ),
            const Expanded(child: SizedBox(width: 40)),
            Expanded(
              child: _buildNavItem(2, Icons.psychology, Icons.psychology_outlined, 'Support'),
            ),
            Expanded(
              child: _buildNavItem(3, Icons.person_outline, Icons.person, 'Profile'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon, IconData selectedIcon, String label) {
    final isSelected = _selectedIndex == index;
    return InkWell(
      onTap: () => _onItemTapped(index),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            isSelected ? selectedIcon : icon,
            color: isSelected 
                ? AppColors.turquoise 
                : Theme.of(context).colorScheme.onSurface.withOpacity(0.64),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: isSelected 
                  ? AppColors.turquoise 
                  : Theme.of(context).colorScheme.onSurface.withOpacity(0.64),
            ),
          ),
        ],
      ),
    );
  }
} 