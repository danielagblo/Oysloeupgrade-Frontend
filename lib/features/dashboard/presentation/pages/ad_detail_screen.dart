import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_svg/svg.dart';
import 'package:oysloe_mobile/core/common/widgets/appbar.dart';
import 'package:oysloe_mobile/core/themes/theme.dart';
import 'package:oysloe_mobile/core/themes/typo.dart';
import 'package:oysloe_mobile/features/dashboard/presentation/widgets/ad_card.dart';
import 'package:oysloe_mobile/features/dashboard/presentation/widgets/ads_section.dart';
import 'package:oysloe_mobile/features/dashboard/presentation/widgets/rating_overview.dart'
    as rating_widget;
import 'package:oysloe_mobile/features/dashboard/presentation/widgets/reviews_bottom_sheet.dart'
    as reviews_widget;
import 'package:responsive_sizer/responsive_sizer.dart';

class AdDetailScreen extends StatefulWidget {
  final String? adId;
  final AdDealType? adType;
  final String? imageUrl;
  final String? title;
  final String? location;
  final List<String>? prices;

  const AdDetailScreen({
    super.key,
    this.adId,
    this.adType,
    this.imageUrl,
    this.title,
    this.location,
    this.prices,
  });

  @override
  State<AdDetailScreen> createState() => _AdDetailScreenState();
}

class _AdDetailScreenState extends State<AdDetailScreen> {
  bool _isExpanded = false;
  final TextEditingController _chatController = TextEditingController();
  // Seller cards scroller
  final ScrollController _cardsController = ScrollController();
  bool _canScrollLeft = false;
  bool _canScrollRight = true;
  final List<String> _sellerAdImages = const [
    'assets/images/ad1.jpg',
    'assets/images/ad2.jpg',
    'assets/images/ad3.jpg',
    'assets/images/ad4.jpg',
    'assets/images/ad5.jpg',
  ];

  Color _getAdTypeColor() {
    switch (widget.adType) {
      case AdDealType.rent:
        return Color(0xFF00FFF2);
      case AdDealType.sale:
        return Color(0xFFFF6B6B);
      case AdDealType.highPurchase:
        return Color(0xFF74FFA7);
      default:
        return Colors.grey;
    }
  }

  List<Map<String, String>> _getFeatures() {
    return [
      {'label': 'State', 'value': 'Brand new'},
      {'label': 'Manufacturer', 'value': 'Volkswagen'},
      {'label': 'Year make', 'value': '2021'},
      {'label': 'Model', 'value': 'Aud'},
      {'label': 'Body color', 'value': 'Black'},
      {'label': 'Model', 'value': 'Aud'},
      {'label': 'Body color', 'value': 'Black'},
      {'label': 'Model', 'value': 'Aud'},
      {'label': 'Body color', 'value': 'Black'},
      {'label': 'Description', 'value': 'Black'},
      {'label': 'Body color', 'value': 'Black'},
    ];
  }

  List<String> _getSafetyTips() {
    return [
      'Check the item carefully and ask relevant questions.',
      'Always make sure to make good tenancy agreement.',
      'Do not make any payment in advance before visiting.',
      'Report any ad or user seems fake, misleading, right away.',
      'Be sure you’re dealing with the property owner for safety.',
    ];
  }

  List<String> _quickChatSuggestions() {
    return [
      'Is this original?',
      'Do you have delivery?',
      'Can you confirm the condition?',
      'Do you have delivery?'
    ];
  }

  List<reviews_widget.ReviewComment> _getSampleReviews() {
    return [
      reviews_widget.ReviewComment(
        userName: 'Sandra Biom',
        userImage: 'assets/images/man.jpg',
        rating: 4,
        comment:
            'I have went with the seller to see this ad.i must confess i was impressed and i am willing to pay for it in the coming month.',
        date: 'Yesterday',
        likes: 20,
      ),
      reviews_widget.ReviewComment(
        userName: 'Sandra Biom',
        userImage: 'assets/images/man.jpg',
        rating: 4,
        comment:
            'I have went with the seller to see this ad.i must confess i was impressed and i am willing to pay for it in the coming month.',
        date: 'Today',
        likes: 20,
      ),
      reviews_widget.ReviewComment(
        userName: 'You',
        userImage: 'assets/images/man.jpg',
        rating: 4,
        comment:
            'I have went with the seller to see this ad.i must confess i was impressed and i am willing to pay for it in the coming month.',
        date: '1st April',
        likes: 20,
        canEdit: true,
      ),
      reviews_widget.ReviewComment(
        userName: 'Sandra Biom',
        userImage: 'assets/images/man.jpg',
        rating: 4,
        comment:
            'I have went with the seller to see this ad.i must confess i was impressed and i am willing to pay for it in the coming month.',
        date: '1st April',
        likes: 20,
      ),
      reviews_widget.ReviewComment(
        userName: 'John Doe',
        userImage: 'assets/images/man.jpg',
        rating: 5,
        comment: 'Excellent product, highly recommended!',
        date: '2nd April',
        likes: 15,
      ),
      reviews_widget.ReviewComment(
        userName: 'Alice Brown',
        userImage: 'assets/images/man.jpg',
        rating: 5,
        comment: 'Perfect condition, exactly as described!',
        date: '6th April',
        likes: 25,
      ),
      reviews_widget.ReviewComment(
        userName: 'Jane Smith',
        userImage: 'assets/images/man.jpg',
        rating: 3,
        comment: 'It is okay, could be better.',
        date: '3rd April',
        likes: 8,
      ),
      reviews_widget.ReviewComment(
        userName: 'David Wilson',
        userImage: 'assets/images/man.jpg',
        rating: 3,
        comment: 'Average quality, met my basic expectations.',
        date: '7th April',
        likes: 5,
      ),
    ];
  }

  void _showReviewsBottomSheet(int initialFilter) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      isDismissible: true,
      enableDrag: false,
      builder: (context) => reviews_widget.ReviewsBottomSheet(
        rating: 4.5,
        reviewCount: 234,
        initialFilter: initialFilter,
        ratingBreakdown: [
          reviews_widget.RatingBreakdown(stars: 5, percentage: 25),
          reviews_widget.RatingBreakdown(stars: 4, percentage: 50),
          reviews_widget.RatingBreakdown(stars: 3, percentage: 25),
          reviews_widget.RatingBreakdown(stars: 2, percentage: 0),
          reviews_widget.RatingBreakdown(stars: 1, percentage: 0),
        ],
        reviews: _getSampleReviews(),
      ),
    );
  }

  Widget _actionChip({
    required String label,
    String? svgAsset,
    IconData? icon,
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        decoration: BoxDecoration(
          color: AppColors.grayF9,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (svgAsset != null)
              SvgPicture.asset(svgAsset, width: 14, height: 14)
            else if (icon != null)
              Icon(icon, size: 14, color: Colors.black87),
            const SizedBox(width: 4),
            Text(
              label,
              style: AppTypography.bodySmall
                  .copyWith(fontWeight: FontWeight.bold, fontSize: 13.sp),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _suggestionChip(String text) {
    return InkWell(
      onTap: () {
        _chatController.text = text;
        _chatController.selection =
            TextSelection.collapsed(offset: text.length);
      },
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: AppColors.grayF9,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          text,
          style: AppTypography.bodySmall,
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _cardsController.addListener(() {
      if (!_cardsController.hasClients) return;
      final max = _cardsController.position.maxScrollExtent;
      final offset = _cardsController.offset;
      final canLeft = offset > 0;
      final canRight = offset < max;
      if (canLeft != _canScrollLeft || canRight != _canScrollRight) {
        setState(() {
          _canScrollLeft = canLeft;
          _canScrollRight = canRight;
        });
      }
    });
  }

  void _scrollCards(bool forward) {
    if (!_cardsController.hasClients) return;
    final double cardWidth = 28.w;
    const double spacing = 12.0;
    final double delta = cardWidth + spacing;
    final target = forward
        ? _cardsController.offset + delta
        : _cardsController.offset - delta;
    final clamped = target.clamp(
      0.0,
      _cardsController.position.maxScrollExtent,
    );
    _cardsController.animateTo(
      clamped,
      duration: const Duration(milliseconds: 260),
      curve: Curves.easeOut,
    );
  }

  @override
  void dispose() {
    _chatController.dispose();
    _cardsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final features = _getFeatures();
    final hasMoreThanEightFeatures = features.length > 8;
    final featuresToShow = _isExpanded ? features : features.take(8).toList();

    return Scaffold(
      backgroundColor: AppColors.grayF9,
      appBar: CustomAppBar(
        titleWidget: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
          decoration: BoxDecoration(
            color: Color(0xFFF4F4F4),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text('2/4'),
        ),
        actions: [
          AppBarAction.svg(
            label: '24',
            iconSize: 18,
            onTap: () => context.pushNamed('report'),
            svgAsset: 'assets/icons/flag.svg',
          ),
          AppBarAction.svg(
            label: '10',
            iconSize: 18,
            onTap: () {},
            svgAsset: 'assets/icons/favorite.svg',
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Ad type indicator line
            Container(
              width: double.infinity,
              height: 4,
              color: _getAdTypeColor(),
            ),
            // Ad image
            if (widget.imageUrl != null)
              Container(
                width: double.infinity,
                height: 250,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(widget.imageUrl!),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            // Location, Title and Price container
            Container(
              width: double.infinity,
              margin: EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(16),
                  bottomRight: Radius.circular(16),
                ),
              ),
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Location
                  Row(
                    children: [
                      SvgPicture.asset(
                        'assets/icons/location.svg',
                        width: 10,
                        height: 10,
                      ),
                      SizedBox(width: 4),
                      Text(
                        widget.location ?? 'Lashibi, Accra',
                        style: AppTypography.bodySmall,
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  // Title
                  Text(
                    widget.title ??
                        'Six bedroom apartment boys quarters self compound',
                    style: AppTypography.bodyLarge.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 12),
                  if (widget.prices != null && widget.prices!.isNotEmpty)
                    Wrap(
                      spacing: 24,
                      runSpacing: 8,
                      children: widget.prices!
                          .map(
                            (price) => Text(
                              price,
                              style: AppTypography.body.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          )
                          .toList(),
                    )
                  else
                    Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '₵ 120',
                              style: AppTypography.body.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              'Daily for 3 months',
                              style: AppTypography.bodySmall.copyWith(
                                color: Colors.grey[600],
                                fontSize: 12.sp,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(width: 24),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '₵ 720',
                              style: AppTypography.body.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              'Weekly for 4 months',
                              style: AppTypography.bodySmall.copyWith(
                                color: Colors.grey[600],
                                fontSize: 12.sp,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(width: 24),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '₵ 65,000',
                              style: AppTypography.body.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              'Monthly for 6 months',
                              style: AppTypography.bodySmall.copyWith(
                                color: Colors.grey[600],
                                fontSize: 12.sp,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                ],
              ),
            ),
            SizedBox(height: 3.h),
            // Features Container
            Container(
              margin: EdgeInsets.symmetric(horizontal: 8),
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Stack(
                children: [
                  Column(
                    children: featuresToShow.map((feature) {
                      return Container(
                        margin: EdgeInsets.only(bottom: 12),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              width: 6,
                              height: 6,
                              margin: EdgeInsets.zero,
                              decoration: BoxDecoration(
                                color: AppColors.blueGray374957,
                                shape: BoxShape.circle,
                              ),
                            ),
                            SizedBox(width: 12),
                            Expanded(
                              child: RichText(
                                text: TextSpan(
                                  text: '${feature['label']} ',
                                  style: AppTypography.bodySmall.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.blueGray374957),
                                  children: [
                                    TextSpan(
                                      text: feature['value'],
                                      style: AppTypography.bodySmall.copyWith(
                                        color: AppColors.blueGray374957
                                            .withValues(alpha: 0.85),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                  if (!_isExpanded && hasMoreThanEightFeatures)
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        height: 30,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              AppColors.grayF9.withValues(alpha: 0.0),
                              AppColors.grayF9.withValues(alpha: 0.8),
                              AppColors.grayF9,
                            ],
                          ),
                        ),
                        child: Center(
                          child: TextButton.icon(
                            onPressed: () {
                              setState(() {
                                _isExpanded = true;
                              });
                            },
                            icon: Icon(Icons.expand_more,
                                size: 18, color: Colors.black87),
                            label: Text(
                              'Show all features',
                              style: AppTypography.bodySmall.copyWith(
                                color: Colors.black87,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            style: TextButton.styleFrom(
                              foregroundColor: Colors.black87,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 6),
                              backgroundColor: AppColors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            SizedBox(height: 3.h),

            /// [Safety Tips Container]
            Container(
              width: double.infinity,
              margin: EdgeInsets.symmetric(horizontal: 10),
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Safety tips',
                    style: AppTypography.body.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 8),
                  Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: AppColors.grayF9,
                    ),
                    child: Text(
                      'Follow this tips and report anything that feels off',
                      style: AppTypography.bodySmall,
                    ),
                  ),
                  SizedBox(height: 16),
                  ..._getSafetyTips().map((tip) => Padding(
                        padding: EdgeInsets.only(bottom: 12),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              width: 6,
                              height: 6,
                              margin: EdgeInsets.zero,
                              decoration: BoxDecoration(
                                color: AppColors.blueGray374957,
                                shape: BoxShape.circle,
                              ),
                            ),
                            SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                tip,
                                style: AppTypography.body.copyWith(
                                  fontSize: 13.5.sp,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      )),
                ],
              ),
            ),
            SizedBox(height: 1.h),
            Container(
                margin: EdgeInsets.symmetric(horizontal: 10),
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              _actionChip(
                                label: 'Mark Ad as taken',
                                svgAsset: 'assets/icons/mark_as_taken.svg',
                                onTap: () {},
                              ),
                              const SizedBox(width: 12),
                              _actionChip(
                                label: 'Report Seller',
                                svgAsset: 'assets/icons/flag.svg',
                                onTap: () {
                                  context.pushNamed('report');
                                },
                              ),
                              const SizedBox(width: 12),
                              _actionChip(
                                label: 'Favorite',
                                svgAsset: 'assets/icons/unfavorite.svg',
                                onTap: () {},
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: _actionChip(
                                label: 'Caller 1',
                                svgAsset: 'assets/icons/outgoing_call.svg',
                                onTap: () {},
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: _actionChip(
                                label: 'Caller 2',
                                svgAsset: 'assets/icons/outgoing_call.svg',
                                onTap: () {},
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: _actionChip(
                                label: 'Make an offer',
                                svgAsset: 'assets/icons/make_offer.svg',
                                onTap: () {},
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 3.h),
                    // Quick Chat header
                    Row(
                      children: [
                        SvgPicture.asset(
                          'assets/icons/quick_chat.svg',
                          width: 15,
                          height: 15,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Quick Chat',
                          style: AppTypography.body.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 12),
                    // Quick Chat suggestions
                    Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      children:
                          _quickChatSuggestions().map(_suggestionChip).toList(),
                    ),
                    SizedBox(height: 16),
                    // Chat input row
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _chatController,
                            decoration: InputDecoration(
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide: BorderSide(
                                    color: AppColors.grayBFBF, width: 1.5),
                              ),
                              hintText: 'Start a chat',
                              hintStyle: AppTypography.body,
                              isDense: true,
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 12),
                              filled: true,
                              fillColor: AppColors.white,
                              suffixIcon: IconButton(
                                onPressed: () {},
                                icon: SvgPicture.asset(
                                  'assets/icons/send.svg',
                                  width: 17,
                                  height: 17,
                                ),
                              ),
                              border: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: AppColors.blueGray374957
                                        .withValues(alpha: 0.6),
                                    width: 1.5),
                                borderRadius: BorderRadius.circular(24),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            color: AppColors.white,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: AppColors.blueGray374957
                                  .withValues(alpha: 0.2),
                            ),
                          ),
                          child: IconButton(
                            onPressed: () {},
                            icon: SvgPicture.asset('assets/icons/audio.svg',
                                height: 20, width: 20),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 2.h),
                    // Secure chat note
                    Row(
                      children: [
                        Stack(
                          clipBehavior: Clip.none,
                          children: [
                            Container(
                              padding: const EdgeInsets.only(
                                  left: 10, right: 18, top: 3, bottom: 3),
                              decoration: BoxDecoration(
                                color: AppColors.primary,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                'Chat is secured',
                                style: AppTypography.bodySmall
                                    .copyWith(fontSize: 12.sp),
                              ),
                            ),
                            Positioned(
                              top: -3,
                              right: -6,
                              child: Container(
                                padding: const EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                  color: AppColors.primary,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: SvgPicture.asset(
                                  'assets/icons/lock_on.svg',
                                  height: 14,
                                  width: 14,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(width: 3.w),
                        SvgPicture.asset(
                          'assets/icons/shield.svg',
                          width: 14,
                          height: 14,
                        ),
                        SizedBox(width: 1.w),
                        Expanded(
                          child: Text(
                            'Always chat here for safety reasons!',
                            style: AppTypography.bodySmall
                                .copyWith(color: Colors.grey[600]),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                )),
            SizedBox(height: 1.h),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 10),
              padding: EdgeInsets.only(left: 10, right: 10, top: 16, bottom: 8),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Elektromart Gh Ltd',
                            ),
                            const SizedBox(height: 6),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: AppColors.primary,
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(
                                    Icons.check_circle,
                                    size: 14,
                                    color: AppColors.blueGray374957,
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    'High Level',
                                    style: AppTypography.labelSmall.copyWith(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12.sp,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 10),
                        decoration: BoxDecoration(
                          color: AppColors.grayF9,
                          borderRadius: BorderRadius.circular(24),
                        ),
                        child: Text(
                          'Seller Ads',
                          style: AppTypography.bodySmall,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 2.h),
                  SizedBox(
                    height: 8.h,
                    child: Stack(
                      children: [
                        ListView.separated(
                          controller: _cardsController,
                          scrollDirection: Axis.horizontal,
                          padding: const EdgeInsets.only(left: 28, right: 64),
                          itemBuilder: (context, index) {
                            final img =
                                _sellerAdImages[index % _sellerAdImages.length];
                            return ClipRRect(
                              borderRadius: BorderRadius.circular(16),
                              child: Image.asset(
                                img,
                                width: 20.w,
                                fit: BoxFit.cover,
                              ),
                            );
                          },
                          separatorBuilder: (_, __) =>
                              const SizedBox(width: 12),
                          itemCount: _sellerAdImages.length,
                        ),
                        if (_canScrollLeft)
                          Align(
                            alignment: Alignment.centerLeft,
                            child: InkWell(
                              onTap: () => _scrollCards(false),
                              borderRadius: BorderRadius.circular(28),
                              child: Container(
                                margin: const EdgeInsets.only(left: 4),
                                width: 30,
                                height: 30,
                                decoration: BoxDecoration(
                                  color: AppColors.white,
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: AppColors.blueGray374957
                                        .withValues(alpha: 0.08),
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color:
                                          Colors.black.withValues(alpha: 0.04),
                                      blurRadius: 8,
                                      offset: const Offset(0, 2),
                                    )
                                  ],
                                ),
                                child: const Icon(Icons.chevron_left),
                              ),
                            ),
                          ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: InkWell(
                            onTap: _canScrollRight
                                ? () => _scrollCards(true)
                                : null,
                            borderRadius: BorderRadius.circular(28),
                            child: Container(
                              margin: const EdgeInsets.only(right: 4),
                              width: 30,
                              height: 30,
                              decoration: BoxDecoration(
                                color: AppColors.white,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: AppColors.blueGray374957
                                      .withValues(alpha: 0.08),
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.04),
                                    blurRadius: 8,
                                    offset: const Offset(0, 2),
                                  )
                                ],
                              ),
                              child: const Icon(Icons.chevron_right),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                    decoration: BoxDecoration(
                      color: AppColors.grayF9,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            // Avatar with brand logo
                            Stack(
                              clipBehavior: Clip.none,
                              children: [
                                CircleAvatar(
                                  radius: 27,
                                  backgroundImage:
                                      AssetImage('assets/images/man.jpg'),
                                ),
                                Positioned(
                                  bottom: 0,
                                  right: -2,
                                  child: Image.asset(
                                    'assets/icons/brand_logo.png',
                                    width: 30,
                                    height: 30,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(width: 16),
                            // User info
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Jan, 2024',
                                    style: AppTypography.bodySmall.copyWith(
                                      color: Color(0xFF646161),
                                    ),
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    'Alexander Kowri',
                                    style: AppTypography.bodySmall.copyWith(
                                      fontSize: 15.sp,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    'Total ads: 2K',
                                    style: AppTypography.bodySmall,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  /// [Rating breakdown]
                  SizedBox(height: 1.h),
                  rating_widget.RatingOverview(
                    rating: 4.5,
                    reviewCount: 234,
                    selectedFilter: 0, // 0 for "All"
                    ratingBreakdown: [
                      rating_widget.RatingBreakdown(stars: 5, percentage: 25),
                      rating_widget.RatingBreakdown(stars: 4, percentage: 50),
                      rating_widget.RatingBreakdown(stars: 3, percentage: 25),
                      rating_widget.RatingBreakdown(stars: 2, percentage: 0),
                      rating_widget.RatingBreakdown(stars: 1, percentage: 0),
                    ],
                    onFilterChanged: (filterIndex) {
                      _showReviewsBottomSheet(filterIndex);
                    },
                    onViewReviewsPressed: () {
                      _showReviewsBottomSheet(0);
                    },
                  ),
                ],
              ),
            ),

            /// [Similar Ads]
            SizedBox(height: 1.h),
            Container(
              width: double.infinity,
              height: 45,
              decoration: BoxDecoration(
                color: AppColors.white,
              ),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 8),
                child: Text(
                  'Similar Ads',
                  style:
                      AppTypography.body.copyWith(fontWeight: FontWeight.bold),
                ),
              ),
            ),
            SizedBox(height: 1.h),
            Container(
              color: AppColors.white,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: AdsSection(),
              ),
            )
          ],
        ),
      ),
    );
  }
}
