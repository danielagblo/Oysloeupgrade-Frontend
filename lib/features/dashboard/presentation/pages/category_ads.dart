import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../core/common/widgets/animated_gradient_search_input.dart';
import '../../../../core/common/widgets/app_empty_state.dart';
import '../../../../core/constants/api.dart';
import '../../../../core/themes/theme.dart';
import '../../../../core/themes/typo.dart';
import '../../../../core/utils/category_utils.dart';
import 'package:oysloe_mobile/features/dashboard/domain/entities/product_entity.dart';
import 'package:oysloe_mobile/core/utils/formatters.dart';
import 'package:go_router/go_router.dart';
import 'package:oysloe_mobile/core/routes/routes.dart';
import '../../domain/entities/category_entity.dart';
import '../bloc/categories/categories_cubit.dart';
import '../bloc/categories/categories_state.dart';
import '../bloc/products/products_cubit.dart';
import '../bloc/products/products_state.dart';
import '../widgets/ad_card.dart';
import '../widgets/multi_page_bottom_sheet.dart';
import '../widgets/ad_input.dart';

class CategoryAdsScreen extends StatefulWidget {
  const CategoryAdsScreen(
      {super.key, this.initialCategoryLabel, this.initialCategoryId});

  final String? initialCategoryLabel;
  final int? initialCategoryId;

  @override
  State<CategoryAdsScreen> createState() => _CategoryAdsScreenState();
}

class _CategoryAdsScreenState extends State<CategoryAdsScreen>
    with SingleTickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();

  late AnimationController _animationController;
  late Animation<double> _animation;

  bool _showAppBarSearch = false;

  int? _selectedCategoryId;
  String? _selectedCategoryLabel;
  String? _selectedLocation;
  String? _selectedPurpose;
  String? _selectedHighlight;
  String? _selectedPricing;
  String? _selectedParam1;
  String? _selectedParam2;
  String? _selectedParam3;
  String? _pendingCategoryLabel;

  static const double _scrollThreshold = 80.0;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 250),
      vsync: this,
    );

    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    );

    _scrollController.addListener(_onScroll);

    _selectedCategoryLabel = widget.initialCategoryLabel?.trim();
    _pendingCategoryLabel =
        widget.initialCategoryId == null ? _selectedCategoryLabel : null;

    final List<CategoryEntity> categories =
        context.read<CategoriesCubit>().state.categories;
    _selectedCategoryId = widget.initialCategoryId ??
        _findCategoryIdByLabel(_pendingCategoryLabel, categories);

    if (_selectedCategoryId != null) {
      _pendingCategoryLabel = null;
      _updateLabelFromCategories(_selectedCategoryId, categories);
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _onScroll() {
    final offset = _scrollController.offset;
    final shouldShow = offset > _scrollThreshold;

    if (_showAppBarSearch != shouldShow) {
      setState(() {
        _showAppBarSearch = shouldShow;
      });

      if (shouldShow) {
        _animationController.forward();
        HapticFeedback.lightImpact();
      } else {
        _animationController.reverse();
      }
    }
  }

  int? _findCategoryIdByLabel(
    String? label,
    List<CategoryEntity> categories,
  ) {
    if (label == null || label.trim().isEmpty) return null;
    final String normalized = label.trim().toLowerCase();
    for (final CategoryEntity category in categories) {
      if (category.name.trim().toLowerCase() == normalized) {
        return category.id;
      }
    }
    return null;
  }

  Map<int, String> _categoryNameMap(List<CategoryEntity> categories) {
    if (categories.isEmpty) return const <int, String>{};
    return <int, String>{
      for (final CategoryEntity category in categories)
        category.id: category.name,
    };
  }

  String _displayCategoryLabel(
    int? id,
    Map<int, String> nameMap, {
    String fallback = 'Category',
  }) {
    if (id == null) {
      return _selectedCategoryLabel ?? fallback;
    }
    return nameMap[id] ?? _selectedCategoryLabel ?? 'Category $id';
  }

  void _updateLabelFromCategories(
    int? id,
    List<CategoryEntity> categories,
  ) {
    if (id == null) return;
    for (final CategoryEntity category in categories) {
      if (category.id == id) {
        _selectedCategoryLabel = category.name;
        return;
      }
    }
  }

  Future<void> _openCategoryChooser() async {
    final ProductsState productsState = context.read<ProductsCubit>().state;
    final CategoriesState categoriesState =
        context.read<CategoriesCubit>().state;

    final Map<int, String> nameMap =
        _categoryNameMap(categoriesState.categories);

    final List<MultiPageSheetSection<String>> sections =
        <MultiPageSheetSection<String>>[];

    final List<CategoryStat> topStats = productsState.hasData
        ? computeTopCategories(
            productsState.products,
            topN: 5,
            resolveName: (id) => nameMap[id],
          )
        : const <CategoryStat>[];

    if (topStats.isNotEmpty) {
      sections.add(
        MultiPageSheetSection<String>(
          heading: 'Popular categories',
          items: topStats
              .map((CategoryStat stat) =>
                  _buildCategoryItem(stat.categoryId, stat.label))
              .toList(),
        ),
      );
    }

    final Set<int> topIds = topStats.map((stat) => stat.categoryId).toSet();
    final List<CategoryEntity> otherCategories = categoriesState.categories
        .where((category) => !topIds.contains(category.id))
        .take(5)
        .toList();

    if (otherCategories.isNotEmpty) {
      sections.add(
        MultiPageSheetSection<String>(
          heading: 'Other categories',
          items: otherCategories
              .map((CategoryEntity category) =>
                  _buildCategoryItem(category.id, category.name))
              .toList(),
        ),
      );
    }

    if (sections.isEmpty) {
      return;
    }

    final String? picked = await showMultiPageBottomSheet<String>(
      context: context,
      rootPage: MultiPageSheetPage<String>(
        title: 'Product Category',
        sections: sections,
      ),
    );

    if (picked != null) {
      setState(() {
        _selectedCategoryId = int.tryParse(picked);
        _updateLabelFromCategories(
          _selectedCategoryId,
          categoriesState.categories,
        );
      });
    }
  }

  Future<String?> _pickOne(String title, List<String> options) async {
    final String? picked = await showMultiPageBottomSheet<String>(
      context: context,
      rootPage: MultiPageSheetPage<String>(
        title: title,
        sections: [
          MultiPageSheetSection<String>(
            items: options
                .map((e) => MultiPageSheetItem<String>(label: e, value: e))
                .toList(),
          )
        ],
      ),
    );
    return picked;
  }

  static MultiPageSheetItem<String> _buildCategoryItem(int id, String label) {
    if (label.toLowerCase() == 'electronics') {
      // Provide a nested sheet like the post-ad flow; children all map back to the same category id
      return MultiPageSheetItem<String>(
        label: label,
        childBuilder: () => MultiPageSheetPage<String>(
          title: label,
          sections: [
            MultiPageSheetSection<String>(
              items: [
                MultiPageSheetItem<String>(
                    label: 'Phones', value: id.toString()),
                MultiPageSheetItem<String>(
                    label: 'Computers', value: id.toString()),
                MultiPageSheetItem<String>(
                    label: 'Accessories', value: id.toString()),
              ],
            ),
          ],
        ),
      );
    }

    return MultiPageSheetItem<String>(label: label, value: id.toString());
  }

  @override
  Widget build(BuildContext context) {
    final CategoriesState categoriesState =
        context.watch<CategoriesCubit>().state;
    final Map<int, String> categoryNames =
        _categoryNameMap(categoriesState.categories);
    final String categoryFilterLabel =
        _displayCategoryLabel(_selectedCategoryId, categoryNames);

    return BlocListener<CategoriesCubit, CategoriesState>(
      listenWhen: (_, current) =>
          _pendingCategoryLabel != null && current.hasData,
      listener: (_, state) {
        final int? resolved =
            _findCategoryIdByLabel(_pendingCategoryLabel, state.categories);
        if (resolved != null) {
          setState(() {
            _selectedCategoryId = resolved;
            _pendingCategoryLabel = null;
            _updateLabelFromCategories(resolved, state.categories);
          });
        }
      },
      child: _buildBody(categoryFilterLabel),
    );
  }

  Widget _buildBody(String categoryFilterLabel) {
    return Scaffold(
      body: Column(
        children: [
          SafeArea(
            bottom: false,
            child: Container(
              height: 60,
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              child: AnimatedBuilder(
                animation: _animation,
                builder: (context, child) {
                  return Stack(
                    children: [
                      AnimatedPositioned(
                        duration: const Duration(milliseconds: 250),
                        curve: Curves.easeOutCubic,
                        left: _animation.value > 0 ? 0 : null,
                        right: _animation.value > 0 ? null : 0,
                        top: 0,
                        bottom: 0,
                        width: _animation.value > 0
                            ? null
                            : MediaQuery.of(context).size.width - (8.w),
                        child: AnimatedAlign(
                          duration: const Duration(milliseconds: 250),
                          curve: Curves.easeOutCubic,
                          alignment: _animation.value > 0
                              ? Alignment.centerLeft
                              : Alignment.center,
                          child: Text(
                            'Oysloe',
                            style: AppTypography.bodyLarge.copyWith(
                              fontSize: (21 - (_animation.value * 2)).sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      if (_animation.value > 0)
                        Positioned(
                          left: 105,
                          right: 0,
                          top: 11,
                          bottom: 11,
                          child: Transform.scale(
                            scale: _animation.value,
                            alignment: Alignment.centerLeft,
                            child: Opacity(
                              opacity: _animation.value,
                              child: AnimatedGradientSearchInput.compact(
                                controller: _searchController,
                              ),
                            ),
                          ),
                        ),
                    ],
                  );
                },
              ),
            ),
          ),
          Expanded(
            child: RefreshIndicator(
              color: AppColors.blueGray374957,
              onRefresh: () => context.read<ProductsCubit>().fetch(),
              child: SingleChildScrollView(
                controller: _scrollController,
                physics: const AlwaysScrollableScrollPhysics(
                  parent: BouncingScrollPhysics(),
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 2.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      SizedBox(height: 2.5.h),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8.w),
                        child: AnimatedBuilder(
                          animation: _animation,
                          builder: (context, child) {
                            return AnimatedOpacity(
                              opacity: 1.0 -
                                  (_animation.value * 1.2).clamp(0.0, 1.0),
                              duration: const Duration(milliseconds: 200),
                              child: Transform.translate(
                                offset: Offset(0, _animation.value * -15),
                                child: AnimatedGradientSearchInput.full(
                                  controller: _searchController,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      GridView(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 4,
                          mainAxisSpacing: 1.0.h,
                          crossAxisSpacing: 1.6.w,
                          childAspectRatio: 2.6,
                        ),
                        children: [
                          _FilterPill(
                            label: categoryFilterLabel,
                            icon: Icons.unfold_more,
                            onTap: _openCategoryChooser,
                          ),
                          _FilterPill(
                            label: _selectedLocation ?? 'Locations',
                            icon: Icons.place_outlined,
                            onTap: () async {
                              final picked = await _pickOne(
                                  'Locations', AdLocationDropdown.locations);
                              if (picked != null) {
                                setState(() => _selectedLocation = picked);
                              }
                            },
                          ),
                          _FilterPill(
                            label: _selectedPurpose ?? 'Ad Purpose',
                            icon: Icons.sell_outlined,
                            onTap: () async {
                              const options = ['Sale', 'Rent', 'High Purchase'];
                              final picked =
                                  await _pickOne('Ad Purpose', options);
                              if (picked != null) {
                                setState(() => _selectedPurpose = picked);
                              }
                            },
                          ),
                          _FilterPill(
                            label: _selectedHighlight ?? 'Highlights',
                            icon: Icons.collections_outlined,
                            onTap: () async {
                              const options = [
                                'New Arrival',
                                'Top Rated',
                                'Discount',
                                'Trending'
                              ];
                              final picked =
                                  await _pickOne('Highlights', options);
                              if (picked != null) {
                                setState(() => _selectedHighlight = picked);
                              }
                            },
                          ),
                          _FilterPill(
                            label: _selectedPricing ?? 'Pricing',
                            icon: Icons.link_outlined,
                            onTap: () async {
                              const options = [
                                'Any',
                                'Under GHS 1,000',
                                'GHS 1,000 - 5,000',
                                'Above GHS 5,000'
                              ];
                              final picked = await _pickOne('Pricing', options);
                              if (picked != null) {
                                setState(() => _selectedPricing = picked);
                              }
                            },
                          ),
                          _FilterPill(
                            label: _selectedParam1 ?? 'Parameter 1',
                            icon: Icons.more_vert,
                            onTap: () async {
                              const options = [
                                'Option 1',
                                'Option 2',
                                'Option 3'
                              ];
                              final picked =
                                  await _pickOne('Parameter 1', options);
                              if (picked != null) {
                                setState(() => _selectedParam1 = picked);
                              }
                            },
                          ),
                          _FilterPill(
                            label: _selectedParam2 ?? 'Parameter 2',
                            icon: Icons.more_vert,
                            onTap: () async {
                              const options = [
                                'Option 1',
                                'Option 2',
                                'Option 3'
                              ];
                              final picked =
                                  await _pickOne('Parameter 2', options);
                              if (picked != null) {
                                setState(() => _selectedParam2 = picked);
                              }
                            },
                          ),
                          _FilterPill(
                            label: _selectedParam3 ?? 'Parameter 3',
                            icon: Icons.more_vert,
                            onTap: () async {
                              const options = [
                                'Option 1',
                                'Option 2',
                                'Option 3'
                              ];
                              final picked =
                                  await _pickOne('Parameter 3', options);
                              if (picked != null) {
                                setState(() => _selectedParam3 = picked);
                              }
                            },
                          ),
                        ],
                      ),
                      SizedBox(height: 3.h),
                      _CategoryProductsGrid(
                        selectedCategoryId: _selectedCategoryId,
                      ),
                      SizedBox(height: 3.h),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FilterPill extends StatelessWidget {
  const _FilterPill(
      {required this.label, required this.icon, required this.onTap});

  final String label;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
        decoration: BoxDecoration(
          color: AppColors.redFF6B6B,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTypography.bodySmall.copyWith(
                  color: AppColors.blueGray374957,
                  fontWeight: FontWeight.w600,
                  fontSize: 12.sp,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Icon(
              icon,
              size: 14,
              color: AppColors.blueGray374957,
            ),
          ],
        ),
      ),
    );
  }
}

class _CategoryProductsGrid extends StatelessWidget {
  const _CategoryProductsGrid({required this.selectedCategoryId});

  final int? selectedCategoryId;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductsCubit, ProductsState>(
      builder: (context, state) {
        if (state.status == ProductsStatus.initial ||
            state.isLoading && !state.hasData) {
          return const _ProductsShimmer();
        }

        if (state.hasData) {
          final List<ProductEntity> filtered = selectedCategoryId == null
              ? state.products
              : state.products
                  .where((p) => p.category == selectedCategoryId)
                  .toList();

          if (filtered.isEmpty) {
            return Column(
              children: [
                SizedBox(height: 15.h),
                const AppEmptyState(message: 'No Ads to show'),
              ],
            );
          }

          return _ProductsGrid(products: filtered);
        }

        if (state.hasError) {
          return Column(
            children: [
              SizedBox(height: 4.h),
              AppEmptyState(message: state.message ?? 'Unable to load ads'),
            ],
          );
        }

        return const AppEmptyState(message: 'No Ads to show');
      },
    );
  }
}

class _ProductsShimmer extends StatelessWidget {
  const _ProductsShimmer();

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors.grayE4,
      highlightColor: AppColors.white,
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        padding: EdgeInsets.only(top: 1.2.h),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 0.9.h,
          crossAxisSpacing: 1.5.w,
          childAspectRatio: 0.97,
        ),
        itemCount: 6,
        itemBuilder: (BuildContext context, int index) {
          return Container(
            decoration: BoxDecoration(
              color: AppColors.grayF9,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 7,
                  child: Container(
                    margin: EdgeInsets.all(8.sp),
                    decoration: BoxDecoration(
                      color: AppColors.grayE4,
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(12.sp, 8.sp, 12.sp, 10.sp),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: 10.sp,
                          width: 60.sp,
                          decoration: BoxDecoration(
                            color: AppColors.grayE4,
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        SizedBox(height: 6.sp),
                        Container(
                          height: 12.sp,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: AppColors.grayE4,
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        SizedBox(height: 6.sp),
                        Container(
                          height: 12.sp,
                          width: 40.sp,
                          decoration: BoxDecoration(
                            color: AppColors.grayE4,
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _ProductsGrid extends StatelessWidget {
  const _ProductsGrid({required this.products});

  final List<ProductEntity> products;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: EdgeInsets.only(top: 1.2.h),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 0.9.h,
            crossAxisSpacing: 1.5.w,
            childAspectRatio: 0.97,
          ),
          itemCount: products.length,
          itemBuilder: (BuildContext context, int index) {
            final ProductEntity product = products[index];
            final String imageUrl = _resolveImage(product);
            final List<String> prices = _buildPrices(product);
            final String location = _resolveLocation(product);

            return GestureDetector(
              onTap: () => _openDetails(
                context,
                product,
                imageUrl,
                prices,
                location,
              ),
              child: AdCard(
                imageUrl: imageUrl,
                title: product.name,
                location: location,
                prices: prices,
                type: _resolveDealType(product),
              ),
            );
          },
        ),
      ],
    );
  }

  static const String _defaultLocation = 'Accra, Ghana';

  static AdDealType _resolveDealType(ProductEntity product) {
    final String normalizedType = product.type.trim().toLowerCase();
    switch (normalizedType) {
      case 'rent':
        return AdDealType.rent;
      case 'high_purchase':
      case 'hire_purchase':
      case 'hire-purchase':
        return AdDealType.highPurchase;
      case 'sale':
      default:
        return AdDealType.sale;
    }
  }

  static List<String> _buildPrices(ProductEntity product) {
    final String rawPrice = product.price.trim();
    if (rawPrice.isEmpty) {
      return const <String>[];
    }

    return <String>[CurrencyFormatter.ghana.formatRaw(rawPrice)];
  }

  static String _resolveLocation(ProductEntity product) {
    return product.location?.label ?? _defaultLocation;
  }

  static String _resolveImage(ProductEntity product) {
    if (product.image.isNotEmpty) {
      return _prepareImageUrl(product.image);
    }

    if (product.images.isNotEmpty) {
      return _prepareImageUrl(product.images.first);
    }

    return '';
  }

  static String _prepareImageUrl(String rawUrl) {
    final String url = rawUrl.trim();
    if (url.startsWith('http')) {
      return url;
    }

    final Uri baseUri = Uri.parse(AppStrings.baseUrl);
    final String origin = '${baseUri.scheme}://${baseUri.host}';
    if (url.startsWith('/')) {
      return '$origin$url';
    }
    return '$origin/$url';
  }

  static void _openDetails(
    BuildContext context,
    ProductEntity product,
    String imageUrl,
    List<String> prices,
    String location,
  ) {
    final AdDealType dealType = _resolveDealType(product);
    final String currentLocation = GoRouterState.of(context).uri.toString();
    final bool isAlertsRoute =
        currentLocation.startsWith(AppRoutePaths.dashboardAlerts);
    final String routeName = isAlertsRoute
        ? AppRouteNames.dashboardAlertsAdDetail
        : AppRouteNames.dashboardHomeAdDetail;

    context.pushNamed(
      routeName,
      pathParameters: <String, String>{
        'adId': product.pid.isNotEmpty ? product.pid : product.id.toString(),
      },
      extra: <String, dynamic>{
        'adType': dealType,
        'imageUrl': imageUrl,
        'title': product.name,
        'location': location,
        'prices': prices,
        'product': product,
      },
    );
  }
}
