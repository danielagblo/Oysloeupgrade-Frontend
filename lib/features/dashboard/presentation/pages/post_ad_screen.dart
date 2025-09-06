import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:oysloe_mobile/core/common/widgets/appbar.dart';
import 'package:oysloe_mobile/core/common/widgets/buttons.dart';
import 'package:oysloe_mobile/core/themes/theme.dart';
import 'package:oysloe_mobile/core/themes/typo.dart';
import 'package:oysloe_mobile/features/dashboard/presentation/widgets/ad_input.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class PostAdScreen extends StatefulWidget {
  const PostAdScreen({super.key});

  @override
  State<PostAdScreen> createState() => _PostAdScreenState();
}

class _PostAdScreenState extends State<PostAdScreen> {
  final _formKey = GlobalKey<FormState>();

  final _titleController = TextEditingController();
  final _priceController = TextEditingController();
  final _dailyPriceController = TextEditingController();
  final _weeklyPriceController = TextEditingController();
  final _monthlyPriceController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _brandController = TextEditingController();
  final _key1Controller = TextEditingController();
  final _key2Controller = TextEditingController();
  final _key3Controller = TextEditingController();

  String? _selectedCategory;
  String _selectedPurpose = 'Sale';
  String? _selectedDuration;
  String? _selectedAreaLocation;
  String? _selectedMapLocation;
  String? _selectedDailyDuration;
  String? _selectedWeeklyDuration;
  String? _selectedMonthlyDuration;
  String? _selectedBrand;
  String? _selectedKey1;
  String? _selectedKey2;
  String? _selectedKey3;

  @override
  void dispose() {
    _titleController.dispose();
    _priceController.dispose();
    _dailyPriceController.dispose();
    _weeklyPriceController.dispose();
    _monthlyPriceController.dispose();
    _descriptionController.dispose();
    _brandController.dispose();
    _key1Controller.dispose();
    _key2Controller.dispose();
    _key3Controller.dispose();
    super.dispose();
  }

Widget _buildPriceSection() {
  switch (_selectedPurpose) {
    case 'Sale':
      return AdInput(
        controller: _priceController,
        labelText: 'Price',
        hintText: '\$',
        keyboardType: TextInputType.number,
      );

    case 'PayLater':
      return Column(
        children: [
          Row(
            children: [
              Expanded(
                child: AdInput(
                  controller: _dailyPriceController,
                  labelText: 'Daily',
                  hintText: '\$',
                  keyboardType: TextInputType.number,
                ),
              ),
              SizedBox(width: 4.w),
              Expanded(
                child: AdDropdown<String>(
                  labelText: '',
                  value: _selectedDailyDuration,
                  hintText: 'Duration',
                  onChanged: (value) {
                    setState(() {
                      _selectedDailyDuration = value;
                    });
                  },
                  items: [
                    '1 Week',
                    '2 Weeks',
                    '1 Month',
                    '3 Months',
                    '6 Months'
                  ]
                      .map((duration) => DropdownMenuItem(
                            value: duration,
                            child: Text(duration),
                          ))
                      .toList(),
                ),
              ),
            ],
          ),
          SizedBox(height: 3.h),
          Row(
            children: [
              Expanded(
                child: AdInput(
                  controller: _weeklyPriceController,
                  labelText: 'Weekly',
                  hintText: '\$',
                  keyboardType: TextInputType.number,
                ),
              ),
              SizedBox(width: 4.w),
              Expanded(
                child: AdDropdown<String>(
                  labelText: '',
                  value: _selectedWeeklyDuration,
                  hintText: 'Duration',
                  onChanged: (value) {
                    setState(() {
                      _selectedWeeklyDuration = value;
                    });
                  },
                  items: [
                    '1 Week',
                    '2 Weeks',
                    '1 Month',
                    '3 Months',
                    '6 Months'
                  ]
                      .map((duration) => DropdownMenuItem(
                            value: duration,
                            child: Text(duration),
                          ))
                      .toList(),
                ),
              ),
            ],
          ),
          SizedBox(height: 3.h),
          Row(
            children: [
              Expanded(
                child: AdInput(
                  controller: _monthlyPriceController,
                  labelText: 'Monthly',
                  hintText: '\$',
                  keyboardType: TextInputType.number,
                ),
              ),
              SizedBox(width: 4.w),
              Expanded(
                child: AdDropdown<String>(
                  labelText: '',
                  value: _selectedMonthlyDuration,
                  hintText: 'Duration',
                  onChanged: (value) {
                    setState(() {
                      _selectedMonthlyDuration = value;
                    });
                  },
                  items: [
                    '1 Week',
                    '2 Weeks',
                    '1 Month',
                    '3 Months',
                    '6 Months'
                  ]
                      .map((duration) => DropdownMenuItem(
                            value: duration,
                            child: Text(duration),
                          ))
                      .toList(),
                ),
              ),
            ],
          ),
        ],
      );

    case 'Rent':
      return Row(
        children: [
          Expanded(
            flex: 2,
            child: AdInput(
              controller: _priceController,
              labelText: 'Price',
              hintText: '\$',
              keyboardType: TextInputType.number,
            ),
          ),
          SizedBox(width: 4.w),
          Expanded(
            child: AdDropdown<String>(
              labelText: '',
              value: _selectedDuration,
              hintText: 'Duration',
              onChanged: (value) {
                setState(() {
                  _selectedDuration = value;
                });
              },
              items: [
                '1 Week',
                '2 Weeks',
                '1 Month',
                '3 Months',
                '6 Months'
              ]
                  .map((duration) => DropdownMenuItem(
                        value: duration,
                        child: Text(duration),
                      ))
                  .toList(),
            ),
          ),
        ],
      );

    default:
      return Container();
  }
}
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.grayF9,
      appBar: CustomAppBar(
        title: 'Post Ad',
        backgroundColor: AppColors.white,
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: EdgeInsets.all(4.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AdCategoryDropdown(
                labelText: 'Product Category',
                value: _selectedCategory,
                onChanged: (value) {
                  setState(() {
                    _selectedCategory = value;
                  });
                },
              ),
              SizedBox(height: 3.h),
              AdInput(
                controller: _titleController,
                labelText: 'Title',
                hintText: 'Add a title',
              ),
              SizedBox(height: 3.h),
              Text(
                'Declare ad purpose?',
                style: AppTypography.bodySmall.copyWith(
                  color: AppColors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 2.w),
              Row(
                children: [
                  _buildPurposeOption('Sale'),
                  SizedBox(width: 4.w),
                  _buildPurposeOption('PayLater'),
                  SizedBox(width: 4.w),
                  _buildPurposeOption('Rent'),
                ],
              ),
              SizedBox(height: 3.h),
              _buildPriceSection(),
              SizedBox(height: 3.h),
              AdLocationDropdown(
                labelText: 'Ad Area Location',
                value: _selectedAreaLocation,
                onChanged: (value) {
                  setState(() {
                    _selectedAreaLocation = value;
                  });
                },
              ),
              SizedBox(height: 2.w),
              Wrap(
                spacing: 2.w,
                runSpacing: 1.w,
                children: [
                  'Home Spintex',
                  'Shop Accra',
                  'Shop East Legon',
                  'Shop Kumasi'
                ].map((location) => _buildLocationChip(location)).toList(),
              ),
              SizedBox(height: 3.w),
              Row(
                children: [
                  SvgPicture.asset(
                    'assets/icons/shield_info.svg',
                  ),
                  SizedBox(width: 2.w),
                  Expanded(
                    child: Text(
                      'We only take the actual location of your product only for verifiable and safety concerns.',
                      style: AppTypography.labelSmall.copyWith(
                        color: AppColors.gray8B959E,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 3.h),
              AdLocationDropdown(
                labelText: 'Ad Actual Map Location',
                value: _selectedMapLocation,
                onChanged: (value) {
                  setState(() {
                    _selectedMapLocation = value;
                  });
                },
              ),
              SizedBox(height: 2.w),
              Wrap(
                spacing: 2.w,
                runSpacing: 1.w,
                children: [
                  'Home Spintex',
                  'Shop Accra',
                  'Shop East Legon',
                  'Shop Kumasi'
                ].map((location) => _buildLocationChip(location)).toList(),
              ),
              SizedBox(height: 3.h),
              Text(
                'Key Features',
                style: AppTypography.bodySmall.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 2.w),
              AdDropdown<String>(
                value: _selectedBrand,
                hintText: 'Brand',
                onChanged: (value) {
                  setState(() {
                    _selectedBrand = value;
                  });
                },
                items: [
                  'Apple',
                  'Samsung',
                  'Nike',
                  'Sony',
                  'LG',
                  'HP',
                  'Dell',
                  'Other'
                ]
                    .map((brand) => DropdownMenuItem(
                          value: brand,
                          child: Text(brand),
                        ))
                    .toList(),
              ),
              SizedBox(height: 3.w),
              AdDropdown<String>(
                value: _selectedKey1,
                hintText: 'Key 1',
                onChanged: (value) {
                  setState(() {
                    _selectedKey1 = value;
                  });
                },
                items: ['New', 'Used', 'Refurbished', 'Like New']
                    .map((key) => DropdownMenuItem(
                          value: key,
                          child: Text(key),
                        ))
                    .toList(),
              ),
              SizedBox(height: 3.w),
              AdDropdown<String>(
                value: _selectedKey2,
                hintText: 'Key 2',
                onChanged: (value) {
                  setState(() {
                    _selectedKey2 = value;
                  });
                },
                items: ['Original', 'Copy', 'Generic']
                    .map((key) => DropdownMenuItem(
                          value: key,
                          child: Text(key),
                        ))
                    .toList(),
              ),
              SizedBox(height: 3.w),
              AdDropdown<String>(
                value: _selectedKey3,
                hintText: 'Key 3',
                onChanged: (value) {
                  setState(() {
                    _selectedKey3 = value;
                  });
                },
                items: ['Warranty', 'No Warranty', '1 Year', '2 Years']
                    .map((key) => DropdownMenuItem(
                          value: key,
                          child: Text(key),
                        ))
                    .toList(),
              ),
              SizedBox(height: 3.h),
              AdInput(
                controller: _descriptionController,
                labelText: 'Description',
                hintText: 'Type more',
                maxLines: 4,
                maxLength: 500,
              ),
              SizedBox(height: 6.w),
              CustomButton.filled(
                  label: 'Finish',
                  backgroundColor: AppColors.white,
                  onPressed: () {}),
              SizedBox(height: 3.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPurposeOption(String purpose) {
    final isSelected = _selectedPurpose == purpose;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedPurpose = purpose;
            _selectedDuration = null;
            _selectedDailyDuration = null;
            _selectedWeeklyDuration = null;
            _selectedMonthlyDuration = null;
          });
        },
        child: Container(
          height: 12.w,
          padding: EdgeInsets.all(2.w),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Stack(
            children: [
              Positioned(
                top: 0,
                right: 0,
                child: Container(
                  width: 15,
                  height: 15,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isSelected
                          ? AppColors.blueGray374957
                          : AppColors.gray8B959E,
                      width: 1,
                    ),
                    color: Colors.transparent,
                  ),
                  child: isSelected
                      ? Center(
                          child: Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppColors.blueGray374957,
                            ),
                          ),
                        )
                      : null,
                ),
              ),
              Positioned(
                left: 2,
                top: 0,
                bottom: 0,
                child: Center(
                  child: Text(
                    purpose,
                    style: AppTypography.body.copyWith(
                      color:
                          isDark ? AppColors.white : AppColors.blueGray374957,
                      fontSize: 14.sp,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLocationChip(String location) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 2.w),
      decoration: BoxDecoration(
        color: isDark ? AppColors.blueGray374957 : AppColors.white,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Text(
        location,
        style: AppTypography.bodySmall.copyWith(
          fontSize: 11.sp,
          fontWeight: FontWeight.normal,
          color: isDark ? AppColors.white : Color(0xFF222222),
        ),
      ),
    );
  }
}