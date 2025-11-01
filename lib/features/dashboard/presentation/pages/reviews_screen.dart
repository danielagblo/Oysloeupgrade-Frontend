import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:oysloe_mobile/core/common/widgets/app_snackbar.dart';
import 'package:oysloe_mobile/core/common/widgets/appbar.dart';
import 'package:oysloe_mobile/core/common/widgets/buttons.dart';
import 'package:oysloe_mobile/core/di/dependency_injection.dart';
import 'package:oysloe_mobile/core/themes/theme.dart';
import 'package:oysloe_mobile/core/themes/typo.dart';
import 'package:oysloe_mobile/features/dashboard/domain/usecases/create_review_usecase.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class ReviewsScreen extends StatefulWidget {
  const ReviewsScreen({super.key, required this.productId});

  final int productId;

  @override
  State<ReviewsScreen> createState() => _ReviewsScreenState();
}

class _ReviewsScreenState extends State<ReviewsScreen> {
  int _selectedRating = 0;
  final TextEditingController _commentController = TextEditingController();
  bool _submitting = false;

  final List<String> _ratingLabels = [
    'Poor',
    'Average',
    'Good',
    'Very Good',
    'Excellent',
  ];

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  void _onStarTap(int rating) {
    setState(() {
      _selectedRating = rating;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.grayF9,
      appBar: const CustomAppBar(
        title: 'Feedback',
        backgroundColor: AppColors.white,
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight,
                ),
                child: IntrinsicHeight(
                  child: Padding(
                    padding: EdgeInsets.all(6.w),
                    child: Column(
                      children: [
                        SizedBox(height: 5.h),
                        Text(
                          'Review',
                          style: AppTypography.bodyLarge.copyWith(
                            color: AppColors.blueGray374957,
                            fontWeight: FontWeight.w600,
                            fontSize: 18.sp,
                          ),
                        ),
                        SizedBox(height: 1.h),
                        Text(
                          'Make a review',
                          style: AppTypography.body.copyWith(
                            color:
                                AppColors.blueGray374957.withValues(alpha: 0.7),
                          ),
                        ),
                        SizedBox(height: 4.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(5, (index) {
                            final starIndex = index + 1;
                            final isSelected = starIndex <= _selectedRating;

                            return GestureDetector(
                              onTap: () => _onStarTap(starIndex),
                              child: Container(
                                padding: EdgeInsets.symmetric(horizontal: 2.w),
                                child: Icon(
                                  Icons.star,
                                  size: 35,
                                  color: isSelected
                                      ? AppColors.blueGray374957
                                      : AppColors.grayD9,
                                ),
                              ),
                            );
                          }),
                        ),
                        SizedBox(height: 2.h),
                        SizedBox(
                          height: 3.h,
                          child: _selectedRating > 0
                              ? Text(
                                  _ratingLabels[_selectedRating - 1],
                                  style: AppTypography.body.copyWith(
                                    color: AppColors.blueGray374957
                                        .withValues(alpha: 0.7),
                                    fontWeight: FontWeight.w500,
                                  ),
                                )
                              : const SizedBox.shrink(),
                        ),
                        const Spacer(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SvgPicture.asset(
                              'assets/icons/shield_info.svg',
                              width: 16,
                              height: 16,
                            ),
                            SizedBox(width: 2.w),
                            Text(
                              'Reviews are verified before seen public',
                              style: AppTypography.bodySmall,
                            ),
                          ],
                        ),
                        SizedBox(height: 1.h),
                        Container(
                          decoration: BoxDecoration(
                            color: AppColors.grayF9,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: AppColors.blueGray374957
                                  .withValues(alpha: 0.32),
                            ),
                          ),
                          child: TextField(
                            controller: _commentController,
                            maxLines: 2,
                            decoration: InputDecoration(
                              hintText: 'Comment',
                              hintStyle: AppTypography.body,
                              border: InputBorder.none,
                              enabledBorder: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              errorBorder: InputBorder.none,
                              disabledBorder: InputBorder.none,
                              contentPadding: EdgeInsets.all(4.w),
                              filled: true,
                              fillColor: Colors.transparent,
                            ),
                            style: AppTypography.body.copyWith(
                              color: AppColors.blueGray374957,
                            ),
                          ),
                        ),
                        SizedBox(height: 2.h),
                        SizedBox(
                          width: double.infinity,
                          child: CustomButton.filled(
                            label: _submitting ? 'Sending…' : 'Send Review',
                            backgroundColor: AppColors.white,
                            onPressed: _submitting
                                ? null
                                : () async {
                                    if (_selectedRating <= 0) {
                                      showErrorSnackBar(
                                        context,
                                        'Please select a rating to submit.',
                                      );
                                      return;
                                    }

                                    setState(() => _submitting = true);
                                    final result = await sl<CreateReviewUseCase>()(
                                      CreateReviewParams(
                                        productId: widget.productId,
                                        rating: _selectedRating,
                                        comment:
                                            _commentController.text.trim(),
                                      ),
                                    );

                                    if (!mounted) return;

                                    result.fold(
                                      (failure) {
                                        final message = failure.message.isEmpty
                                            ? 'Unable to submit review.'
                                            : failure.message;
                                        showErrorSnackBar(context, message);
                                        setState(() => _submitting = false);
                                      },
                                      (_) async {
                                        showSuccessSnackBar(
                                            context, 'Review submitted.');
                                        Navigator.of(context).pop(true);
                                      },
                                    );
                                  },
                          ),
                        ),
                        SizedBox(height: 2.h),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
