import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:oysloe_mobile/core/common/widgets/app_snackbar.dart';
import 'package:oysloe_mobile/core/di/dependency_injection.dart';
import 'package:oysloe_mobile/core/navigation/navigation_state.dart';
import 'package:oysloe_mobile/core/routes/routes.dart';
import 'package:oysloe_mobile/features/auth/domain/repositories/auth_repository.dart';
import 'package:oysloe_mobile/features/dashboard/presentation/bloc/products/products_cubit.dart';
import 'package:oysloe_mobile/features/dashboard/presentation/bloc/categories/categories_cubit.dart';
import 'package:oysloe_mobile/features/dashboard/presentation/bloc/profile/profile_cubit.dart';
import 'package:oysloe_mobile/features/dashboard/presentation/bloc/alerts/alerts_cubit.dart';
import 'package:oysloe_mobile/features/dashboard/presentation/bloc/locations/locations_cubit.dart';
import 'package:oysloe_mobile/features/dashboard/presentation/bloc/subcategories/subcategories_cubit.dart';
import 'package:oysloe_mobile/features/dashboard/presentation/bloc/terms_conditions/terms_conditions_cubit.dart';
import 'package:oysloe_mobile/features/dashboard/presentation/bloc/privacy_policies/privacy_policies_cubit.dart';
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

  // Dashboard-level cubits - created once and shared across all dashboard screens
  late final ProductsCubit _productsCubit;
  late final CategoriesCubit _categoriesCubit;
  late final ProfileCubit _profileCubit;
  late final AlertsCubit _alertsCubit;
  late final LocationsCubit _locationsCubit;
  late final SubcategoriesCubit _subcategoriesCubit;
  late final TermsConditionsCubit _termsConditionsCubit;
  late final PrivacyPoliciesCubit _privacyPoliciesCubit;

  @override
  void initState() {
    super.initState();
    _navigationState = NavigationState();
    _navigationState.setCurrentIndex(widget.currentIndex);

    // Initialize cubits once and fetch initial data
    _productsCubit = sl<ProductsCubit>()..fetch();
    _categoriesCubit = sl<CategoriesCubit>()..fetch();
    _profileCubit = sl<ProfileCubit>()..hydrate();
    _alertsCubit = sl<AlertsCubit>()..fetchAlerts();
    _locationsCubit = sl<LocationsCubit>()..fetch();
    _subcategoriesCubit = sl<SubcategoriesCubit>();
    _termsConditionsCubit = sl<TermsConditionsCubit>()..fetch();
    _privacyPoliciesCubit = sl<PrivacyPoliciesCubit>()..fetch();
  }

  @override
  void didUpdateWidget(NavigationShell oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.currentIndex != widget.currentIndex) {
      _navigationState.setCurrentIndex(widget.currentIndex);
    }
  }

  Future<bool> _ensureAuthenticated() async {
    final AuthRepository repository = sl<AuthRepository>();
    final session = await repository.cachedSession();
    final bool isLoggedIn = session != null;

    if (!isLoggedIn && mounted) {
      showErrorSnackBar(context, 'Please log in to continue.');
      context.go(AppRoutePaths.login);
    }

    return isLoggedIn;
  }

  Future<void> _onTabTapped(int index) async {
    switch (index) {
      case 0:
        context.go(AppRoutePaths.dashboardHome);
        break;
      case 1:
        if (!await _ensureAuthenticated()) return;
        context.go(AppRoutePaths.dashboardAlerts);
        break;
      case 2:
        if (!await _ensureAuthenticated()) return;
        context.go(AppRoutePaths.dashboardPostAd);
        break;
      case 3:
        if (!await _ensureAuthenticated()) return;
        context.go(AppRoutePaths.dashboardInbox);
        break;
      case 4:
        if (!await _ensureAuthenticated()) return;
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
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: _productsCubit),
        BlocProvider.value(value: _categoriesCubit),
        BlocProvider.value(value: _profileCubit),
        BlocProvider.value(value: _alertsCubit),
        BlocProvider.value(value: _locationsCubit),
        BlocProvider.value(value: _subcategoriesCubit),
        BlocProvider.value(value: _termsConditionsCubit),
        BlocProvider.value(value: _privacyPoliciesCubit),
      ],
      child: PopScope(
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
              onTap: (index) => _onTabTapped(index),
            );
          },
        ),
      ),
      ),
    );
  }

  @override
  void dispose() {
    _productsCubit.close();
    _categoriesCubit.close();
    _profileCubit.close();
    _alertsCubit.close();
    _locationsCubit.close();
    _subcategoriesCubit.close();
    _termsConditionsCubit.close();
    _privacyPoliciesCubit.close();
    _navigationState.dispose();
    super.dispose();
  }
}
