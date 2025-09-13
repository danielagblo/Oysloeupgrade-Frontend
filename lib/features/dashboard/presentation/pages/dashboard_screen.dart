import 'package:flutter/material.dart';
import 'package:oysloe_mobile/features/dashboard/presentation/pages/alerts_screen.dart';
import 'package:oysloe_mobile/features/dashboard/presentation/pages/home_screen.dart';
import 'package:oysloe_mobile/features/dashboard/presentation/pages/inbox_screen.dart';
import 'package:oysloe_mobile/features/dashboard/presentation/pages/post_ad_upload_images_screen.dart';
import 'package:oysloe_mobile/features/dashboard/presentation/pages/profile_screen.dart';
import 'package:oysloe_mobile/features/dashboard/presentation/widgets/bottom_navigation.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const AnimatedHomeScreen(),
    const AlertsScreen(),
    const PostAdUploadImagesScreen(),
    const InboxScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: _pages),
      bottomNavigationBar: CustomBottomNavigation(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}
