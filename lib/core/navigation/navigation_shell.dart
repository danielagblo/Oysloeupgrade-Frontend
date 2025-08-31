import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:oysloe_mobile/core/navigation/navigation_state.dart';
import 'package:oysloe_mobile/features/dashboard/presentation/widgets/bottom_navigation.dart';

class NavigationShell extends StatefulWidget {
  final Widget child;
  final int currentIndex;

  const NavigationShell({
    super.key,
    required this.child,
    required this.currentIndex,
  });

  @override
  State<NavigationShell> createState() => _NavigationShellState();
}

class _NavigationShellState extends State<NavigationShell> {
  late NavigationState _navigationState;

  @override
  void initState() {
    super.initState();
    _navigationState = NavigationState();
    _navigationState.setCurrentIndex(widget.currentIndex);
  }

  @override
  void didUpdateWidget(NavigationShell oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.currentIndex != widget.currentIndex) {
      _navigationState.setCurrentIndex(widget.currentIndex);
    }
  }

  void _onTabTapped(int index) {
    switch (index) {
      case 0:
        context.go('/dashboard/home');
        break;
      case 1:
        context.go('/dashboard/alerts');
        break;
      case 2:
        context.go('/dashboard/post-ad');
        break;
      case 3:
        context.go('/dashboard/inbox');
        break;
      case 4:
        context.go('/dashboard/profile');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;

        if (!_navigationState.handleBackPress()) {
          // If we can't pop within the current tab, handle app exit or go to home tab
          if (_navigationState.currentIndex != 0) {
            _onTabTapped(0);
          }
        }
      },
      child: Scaffold(
        body: widget.child,
        bottomNavigationBar: ListenableBuilder(
          listenable: _navigationState,
          builder: (context, _) {
            return CustomBottomNavigation(
              currentIndex: widget.currentIndex,
              onTap: _onTabTapped,
            );
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    _navigationState.dispose();
    super.dispose();
  }
}
