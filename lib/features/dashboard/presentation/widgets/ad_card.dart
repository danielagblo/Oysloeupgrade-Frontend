import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:oysloe_mobile/core/themes/theme.dart';
import 'package:oysloe_mobile/core/themes/typo.dart';

enum AdDealType { rent, sale, highPurchase }

class AdCard extends StatelessWidget {
  const AdCard({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.location,
    required this.prices,
    this.type = AdDealType.sale,
  });

  final String imageUrl;
  final String title;
  final String location;
  final List<String> prices;
  final AdDealType type;

  Color get _strokeColor {
    switch (type) {
      case AdDealType.rent:
        return const Color(0xFFFFECEC); // soft red
      case AdDealType.sale:
        return const Color(0xFFDEFEED); // soft green
      case AdDealType.highPurchase:
        return const Color(0xFFE4F8FF); // soft blue
    }
  }

  @override
  Widget build(BuildContext context) {
    final stroke = _strokeColor;

    return Container(
      decoration: BoxDecoration(
        color: AppColors.grayF9,
        borderRadius: BorderRadius.circular(18),
      ),
      padding: EdgeInsets.symmetric(horizontal: 1.0.h, vertical: 0.9.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: stroke, width: 2),
            ),
            clipBehavior: Clip.hardEdge,
            child: AspectRatio(
              aspectRatio: 16 / 10,
              child: _buildImage(imageUrl),
            ),
          ),
          SizedBox(height: 0.6.h),
          // Location
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.location_on, size: 15.sp, color: AppColors.gray8B959E),
              SizedBox(width: 1.w),
              Flexible(
                child: Text(
                  location,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTypography.labelSmall.copyWith(
                    color: AppColors.gray8B959E,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 0.35.h),
          // Title
          Text(
            title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: AppTypography.body.copyWith(
              color: AppColors.blueGray374957,
              fontWeight: FontWeight.w600,
              fontSize: 14.sp,
            ),
          ),
          SizedBox(height: 0.5.h),
          // Price(s)
          if (prices.length <= 1)
            Text(
              prices.isEmpty ? '' : prices.first,
              style: AppTypography.body.copyWith(
                color: AppColors.blueGray374957,
                fontWeight: FontWeight.w700,
                fontSize: 14.sp,
              ),
            )
          else if (type == AdDealType.highPurchase)
            Wrap(
              spacing: 1.6.w,
              runSpacing: 0.3.h,
              children: [
                for (final p in prices)
                  Text(
                    p,
                    style: AppTypography.body.copyWith(
                      color: AppColors.blueGray374957,
                      fontWeight: FontWeight.w700,
                      fontSize: 14.sp,
                    ),
                  ),
              ],
            )
          else
            Wrap(
              spacing: 1.w,
              runSpacing: 0.6.h,
              children: [
                for (final p in prices)
                  _PricePill(text: p, borderColor: stroke),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildImage(String url) {
    if (url.startsWith('http')) {
      return Image.network(url, fit: BoxFit.cover);
    }
    return Image.asset(url, fit: BoxFit.cover);
  }
}

class _PricePill extends StatelessWidget {
  const _PricePill({required this.text, required this.borderColor});

  final String text;
  final Color borderColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 2.4.w, vertical: 0.5.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: borderColor, width: 1.5),
      ),
      child: Text(
        text,
        style: AppTypography.labelSmall.copyWith(
          fontWeight: FontWeight.w700,
          color: AppColors.blueGray374957,
        ),
      ),
    );
  }
}
