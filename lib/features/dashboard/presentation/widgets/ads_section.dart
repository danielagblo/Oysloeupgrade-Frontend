import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../core/common/widgets/app_empty_state.dart';
import '../../../../core/constants/api.dart';
import '../../../../core/routes/routes.dart';
import '../../../../core/themes/theme.dart';
import '../../../../core/utils/formatters.dart';
import '../../domain/entities/product_entity.dart';
import '../bloc/products/products_cubit.dart';
import '../bloc/products/products_state.dart';
import 'ad_card.dart';

class AdsSection extends StatelessWidget {
  const AdsSection({super.key});

  static const String _defaultLocation = 'Accra, Ghana';
  static final CurrencyFormatter _currencyFormatter = CurrencyFormatter.ghana;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductsCubit, ProductsState>(
      builder: (context, state) {
        if (state.status == ProductsStatus.initial ||
            state.isLoading && !state.hasData) {
          return const _ProductsShimmer();
        }

        if (state.hasData) {
          return _ProductsGrid(products: state.products);
        }

        if (state.hasError) {
          return Column(
            children: [
              SizedBox(
                height: 4.h,
              ),
              AppEmptyState(message: state.message ?? 'Unable to load ads')
            ],
          );
        }

        return const AppEmptyState(message: 'No Ads to show');
      },
    );
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

  static List<String> _buildPrices(ProductEntity product) {
    final String rawPrice = product.price.trim();
    if (rawPrice.isEmpty) {
      return const <String>[];
    }

    return <String>[_currencyFormatter.formatRaw(rawPrice)];
  }

  static String _resolveLocation(ProductEntity product) {
    return product.location?.label ?? _defaultLocation;
  }

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
  const _ProductsGrid({
    required this.products,
  });

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
            final String imageUrl = AdsSection._resolveImage(product);
            final List<String> prices = AdsSection._buildPrices(product);
            final String location = AdsSection._resolveLocation(product);

            return GestureDetector(
              onTap: () => AdsSection._openDetails(
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
                type: AdsSection._resolveDealType(product),
              ),
            );
          },
        ),
      ],
    );
  }
}
