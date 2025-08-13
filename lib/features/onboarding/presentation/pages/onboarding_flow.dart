import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:oysloe_mobile/core/themes/typo.dart';
import 'package:oysloe_mobile/core/constants/body_paddings.dart';
import 'package:oysloe_mobile/core/common/widgets/buttons.dart';

class OnboardingFlow extends StatefulWidget {
  const OnboardingFlow({super.key});

  @override
  State<OnboardingFlow> createState() => _OnboardingFlowState();
}

class _OnboardingFlowState extends State<OnboardingFlow> {
  final PageController _controller = PageController();
  int _page = 0;

  static const List<_OnboardData> _pages = [
    _OnboardData(
      title: 'User Safety \nGuarantee',
      subtitle:
          'Buyers and sellers undergo strict checks and \nverification to ensure authenticity and reliability',
      image: 'assets/gifs/onboarding1.gif',
    ),
    _OnboardData(
      title: 'Scale you \nto Success',
      subtitle:
          'Watch your business grow with our designed \nmarketing tools, and automated processes.',
      image: 'assets/gifs/onboarding2.gif',
    ),
    _OnboardData(
      title: 'Your journey \nbegins now',
      subtitle:
          'Optimized for all business owners with\nseamless experience for everyone',
      image: 'assets/gifs/onboarding3.gif',
    ),
  ];

  void _goNext() {
    if (_page < _pages.length - 1) {
      _controller.nextPage(
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeOut,
      );
    } else {
      if (mounted) {
        context.goNamed('login');
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _controller,
                itemCount: _pages.length,
                onPageChanged: (i) => setState(() => _page = i),
                itemBuilder: (context, index) {
                  final data = _pages[index];
                  return Padding(
                    padding: BodyPaddings.horizontalPage,
                    child: Column(
                      children: [
                        Expanded(
                          child: Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              spacing: 2.h,
                              children: [
                                Image.asset(data.image, height: 22.h),
                                Text(
                                  data.title,
                                  style: AppTypography.large,
                                  textAlign: TextAlign.center,
                                ),
                                Text(
                                  data.subtitle,
                                  style: AppTypography.body.copyWith(
                                    fontSize: 14.sp,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                SizedBox(height: 1.2.h),
                                _PageIndicators(
                                  current: _page,
                                  total: _pages.length,
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 3.h),
                        Padding(
                          padding: EdgeInsets.only(bottom: 4.h),
                          child: CustomButton.filled(
                            label: _page == _pages.length - 1
                                ? 'Get started'
                                : 'Next',
                            textStyle: AppTypography.body,
                            isPrimary: false,
                            onPressed: _goNext,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PageIndicators extends StatelessWidget {
  const _PageIndicators({required this.current, required this.total});
  final int current;
  final int total;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(total, (i) {
        final active = i == current;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
          margin: const EdgeInsets.symmetric(horizontal: 4),
          height: 9,
          width: 9,
          decoration: BoxDecoration(
            color: active ? const Color(0xFF2E3642) : const Color(0xFFE0E2E5),
            borderRadius: BorderRadius.circular(4),
          ),
        );
      }),
    );
  }
}

class _OnboardData {
  final String title;
  final String subtitle;
  final String image;
  const _OnboardData({
    required this.title,
    required this.subtitle,
    required this.image,
  });
}
