import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:oysloe_mobile/core/themes/theme.dart';

class CategoriesSection extends StatelessWidget {
  const CategoriesSection({super.key, this.onCategoryTap});

  final ValueChanged<String>? onCategoryTap;

  static const _categories = <({String label, String asset})>[
    (label: 'Electronics', asset: 'assets/images/electronics.png'),
    (label: 'Furniture', asset: 'assets/images/furniture.png'),
    (label: 'Vehicle', asset: 'assets/images/vehicle.png'),
    (label: 'Industry', asset: 'assets/images/industrial.png'),
    (label: 'Fashion', asset: 'assets/images/fashion.png'),
    (label: 'Grocery', asset: 'assets/images/grocery.png'),
    (label: 'Games', asset: 'assets/images/games.png'),
    (label: 'Cosmetics', asset: 'assets/images/cosmetics.png'),
    (label: 'Property', asset: 'assets/images/property.png'),
    (label: 'Services', asset: 'assets/images/services.png'),
  ];

  @override
  Widget build(BuildContext context) {
    const int crossAxisCount = 4;

    final int total = _categories.length;
    final int remainder = total % crossAxisCount;
    final int leftPad = remainder == 0 ? 0 : (crossAxisCount - remainder) ~/ 2;
    final int totalSlots = remainder == 0
        ? total
        : total + (crossAxisCount - remainder);
    final int lastRowStart = totalSlots - crossAxisCount;

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.only(top: 1.2.h),
      itemCount: totalSlots,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        mainAxisSpacing: 1.2.h,
        crossAxisSpacing: 2.4.w,
        childAspectRatio: 0.9,
      ),
      itemBuilder: (context, index) {
        if (index >= lastRowStart) {
          final pos = index - lastRowStart;
          if (remainder != 0 && (pos < leftPad || pos >= leftPad + remainder)) {
            return const SizedBox.shrink();
          }
          final catIndex = index - lastRowStart - leftPad + (total - remainder);
          final c = _categories[catIndex];
          return _CategoryCard(
            label: c.label,
            asset: c.asset,
            onTap: () {
              if (onCategoryTap != null) {
                onCategoryTap!(c.label);
              } else if (c.label.toLowerCase() == 'services') {
                context.pushNamed('services');
              }
            },
          );
        } else {
          final c = _categories[index];
          return _CategoryCard(
            label: c.label,
            asset: c.asset,
            onTap: () {
              if (onCategoryTap != null) {
                onCategoryTap!(c.label);
              } else if (c.label.toLowerCase() == 'services') {
                context.pushNamed('services');
              }
            },
          );
        }
      },
    );
  }
}

class _CategoryCard extends StatelessWidget {
  const _CategoryCard({required this.label, required this.asset, this.onTap});

  final String label;
  final String asset;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.grayF9,
          borderRadius: BorderRadius.circular(9),
        ),
        padding: EdgeInsets.symmetric(vertical: 1.2.h, horizontal: 2.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: const BoxDecoration(
                color: AppColors.white,
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: Padding(
                padding: const EdgeInsets.all(6.0),
                child: Image.asset(asset, fit: BoxFit.contain),
              ),
            ),
            SizedBox(height: 0.8.h),
            Text(
              label,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: AppColors.blueGray374957,
                fontSize: 13.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
