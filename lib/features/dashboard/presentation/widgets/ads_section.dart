import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:oysloe_mobile/features/dashboard/presentation/widgets/ad_card.dart';

class AdsSection extends StatelessWidget {
  const AdsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final items =
        <
          ({
            String img,
            String title,
            String loc,
            AdDealType type,
            List<String> prices,
          })
        >[
          (
            img: 'assets/images/ad1.jpg',
            title: 'Six bedroom apartment',
            loc: 'Santamaria-kotobabi',
            type: AdDealType.rent,
            prices: ['₵ 120 for 6 days'],
          ),
          (
            img: 'assets/images/ad2.jpg',
            title: 'Six bedroom apartment',
            loc: 'Santamaria-kotobabi',
            type: AdDealType.sale,
            prices: ['₵ 1,700,000'],
          ),
          (
            img: 'assets/images/ad3.jpg',
            title: 'Samsung galaxy ultra',
            loc: 'Santamaria-kotobabi',
            type: AdDealType.highPurchase,
            prices: ['₵ 120', '₵ 720', '₵ 65,000'],
          ),
          (
            img: 'assets/images/ad4.jpg',
            title: 'Samsung AQ ultra smart',
            loc: 'Santamaria-kotobabi',
            type: AdDealType.sale,
            prices: ['₵ 1,670,000'],
          ),
          (
            img: 'assets/images/ad5.jpg',
            title: 'Samsung AQ ultra smart',
            loc: 'Santamaria-kotobabi',
            type: AdDealType.sale,
            prices: ['₵ 1,670,000'],
          ),
          (
            img: 'assets/images/ad6.jpg',
            title: 'Samsung AQ ultra smart',
            loc: 'Santamaria-kotobabi',
            type: AdDealType.sale,
            prices: ['₵ 1,670,000'],
          ),
        ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.only(top: 1.2.h),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 1.4.h,
        crossAxisSpacing: 3.w,
        childAspectRatio: 0.95,
      ),
      itemCount: items.length,
      itemBuilder: (context, i) {
        final it = items[i];
        return AdCard(
          imageUrl: it.img,
          title: it.title,
          location: it.loc,
          prices: it.prices,
          type: it.type,
        );
      },
    );
  }
}
