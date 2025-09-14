import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:oysloe_mobile/core/navigation/navigation_state.dart';
import 'package:oysloe_mobile/features/dashboard/presentation/widgets/bottom_navigation.dart';
import 'package:oysloe_mobile/features/dashboard/presentation/widgets/profile_menu_drawer.dart';

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
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int? _forcedIndex; // When end drawer is open, highlight Profile tab

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
        // Open the right drawer for Profile instead of navigating
        // If drawer is already open, close it.
        if (_scaffoldKey.currentState?.isEndDrawerOpen ?? false) {
          Navigator.of(context).maybePop();
        } else {
          _scaffoldKey.currentState?.openEndDrawer();
        }
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;

        // Close end drawer first if it's open
        if (_scaffoldKey.currentState?.isEndDrawerOpen ?? false) {
          Navigator.of(context).maybePop();
          return;
        }

        if (!_navigationState.handleBackPress()) {
          // If we can't pop within the current tab, handle app exit or go to home tab
          if (_navigationState.currentIndex != 0) {
            _onTabTapped(0);
          }
        }
      },
      child: Scaffold(
        key: _scaffoldKey,
        body: widget.child,
        endDrawerEnableOpenDragGesture: false,
        endDrawer: LayoutBuilder(
          builder: (context, constraints) {
            final width = MediaQuery.of(context).size.width * 0.8;
            return SizedBox(
              width: width,
              child: const ProfileMenuDrawer(),
            );
          },
        ),
        onEndDrawerChanged: (isOpened) {
          setState(() {
            _forcedIndex = isOpened ? 4 : null;
          });
        },
        bottomNavigationBar: ListenableBuilder(
          listenable: _navigationState,
          builder: (context, _) {
            return CustomBottomNavigation(
              currentIndex: _forcedIndex ?? widget.currentIndex,
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
