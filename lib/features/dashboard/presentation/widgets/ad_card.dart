import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
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
    this.onTap,
  });

  final String imageUrl;
  final String title;
  final String location;
  final List<String> prices;
  final AdDealType type;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.grayF9,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildImageSection(),
            _buildContentSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildImageSection() {
    return Expanded(
      flex: 7,
      child: Container(
        margin: EdgeInsets.all(8.sp),
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
        ),
        clipBehavior: Clip.antiAlias,
        child: _buildImage(imageUrl),
      ),
    );
  }

  Widget _buildContentSection() {
    return Expanded(
      flex: 3,
      child: Padding(
        padding: EdgeInsets.fromLTRB(12.sp, 8.sp, 12.sp, 10.sp),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildLocationRow(),
            SizedBox(height: 4.sp),
            _buildTitle(),
            const Spacer(),
            _buildPriceSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildLocationRow() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SvgPicture.asset(
          'assets/icons/location.svg',
          height: 10.sp,
          colorFilter: ColorFilter.mode(
            AppColors.gray8B959E,
            BlendMode.srcIn,
          ),
        ),
        SizedBox(width: 4.sp),
        Flexible(
          child: Text(
            location,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTypography.labelSmall.copyWith(
              color: AppColors.gray8B959E,
              fontSize: 11.sp,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTitle() {
    return Text(
      title,
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
      style: AppTypography.body.copyWith(
        color: AppColors.blueGray374957,
        fontWeight: FontWeight.w600,
        fontSize: 13.sp,
        height: 1.2,
      ),
    );
  }

  Widget _buildPriceSection() {
    if (prices.isEmpty) return const SizedBox.shrink();

    if (prices.length == 1) {
      return _buildSinglePrice();
    }

    return _buildMultiplePrices();
  }

  Widget _buildSinglePrice() {
    return Text(
      prices.first,
      style: AppTypography.body.copyWith(
        color: AppColors.blueGray374957,
        fontWeight: FontWeight.w700,
        fontSize: 13.sp,
      ),
    );
  }

  Widget _buildMultiplePrices() {
    return Wrap(
      spacing: 8.sp,
      runSpacing: 4.sp,
      children: prices.take(3).map((price) {
        return Text(
          price,
          style: AppTypography.body.copyWith(
            color: AppColors.blueGray374957,
            fontWeight: FontWeight.w700,
            fontSize: 13.sp,
          ),
        );
      }).toList(),
    );
  }

  Widget _buildImage(String url) {
    if (url.startsWith('http')) {
      return Image.network(
        url,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => _buildErrorWidget(),
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return _buildLoadingWidget(loadingProgress);
        },
      );
    }

    return Image.asset(
      url,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) => _buildErrorWidget(),
    );
  }

  Widget _buildErrorWidget() {
    return Container(
      color: AppColors.grayF9,
      child: Center(
        child: Icon(
          Icons.image_not_supported_outlined,
          color: AppColors.gray8B959E,
          size: 24.sp,
        ),
      ),
    );
  }

  Widget _buildLoadingWidget(ImageChunkEvent loadingProgress) {
    return Container(
      color: AppColors.grayF9,
      child: Center(
        child: CircularProgressIndicator(
          value: loadingProgress.expectedTotalBytes != null
              ? loadingProgress.cumulativeBytesLoaded /
                  loadingProgress.expectedTotalBytes!
              : null,
        ),
      ),
    );
  }
}