import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:oysloe_mobile/core/common/widgets/appbar.dart';
import 'package:oysloe_mobile/core/common/widgets/buttons.dart';
import 'package:oysloe_mobile/core/routes/routes.dart';
import 'package:oysloe_mobile/core/themes/theme.dart';
import 'package:oysloe_mobile/core/themes/typo.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class DottedBorder extends StatelessWidget {
  final Widget child;
  final Color color;
  final double strokeWidth;
  final double dashWidth;
  final double dashSpace;
  final BorderRadius borderRadius;

  const DottedBorder({
    super.key,
    required this.child,
    this.color = Colors.grey,
    this.strokeWidth = 2.0,
    this.dashWidth = 5.0,
    this.dashSpace = 3.0,
    this.borderRadius = BorderRadius.zero,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: DottedBorderPainter(
        color: color,
        strokeWidth: strokeWidth,
        dashWidth: dashWidth,
        dashSpace: dashSpace,
        borderRadius: borderRadius,
      ),
      child: child,
    );
  }
}

class DottedBorderPainter extends CustomPainter {
  final Color color;
  final double strokeWidth;
  final double dashWidth;
  final double dashSpace;
  final BorderRadius borderRadius;

  DottedBorderPainter({
    required this.color,
    required this.strokeWidth,
    required this.dashWidth,
    required this.dashSpace,
    required this.borderRadius,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    final path = Path();
    final rect = Rect.fromLTWH(0, 0, size.width, size.height);
    path.addRRect(borderRadius.toRRect(rect));

    final pathMetrics = path.computeMetrics();
    for (final pathMetric in pathMetrics) {
      double distance = 0.0;
      while (distance < pathMetric.length) {
        final segment = pathMetric.extractPath(distance, distance + dashWidth);
        canvas.drawPath(segment, paint);
        distance += dashWidth + dashSpace;
      }
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

class PostAdUploadImagesScreen extends StatefulWidget {
  const PostAdUploadImagesScreen({super.key});

  @override
  State<PostAdUploadImagesScreen> createState() =>
      _PostAdUploadImagesScreenState();
}

class _ImageItem {
  const _ImageItem({required this.id, required this.path});
  final int id;
  final String path;
}

class _PostAdUploadImagesScreenState extends State<PostAdUploadImagesScreen> {
  final List<_ImageItem> _selectedImages = [];
  static const int maxImages = 6;
  int _nextImageId = 0;

  final List<String> _sampleImages = [
    'assets/images/ad1.jpg',
    'assets/images/ad2.jpg',
    'assets/images/ad3.jpg',
    'assets/images/ad4.jpg',
    'assets/images/ad5.jpg',
    'assets/images/ad6.jpg',
  ];

  Future<void> _pickImages() async {
    setState(() {
      if (_selectedImages.length < maxImages) {
        final String path =
            _sampleImages[_selectedImages.length % _sampleImages.length];
        _selectedImages.add(
          _ImageItem(id: _nextImageId++, path: path),
        );
      }
    });
  }

  void _removeImage(int index) {
    setState(() {
      _selectedImages.removeAt(index);
    });
  }

  void _proceedToNext() {
    context.pushNamed(AppRouteNames.dashboardPostAdForm,
        extra: _selectedImages.map((item) => item.path).toList());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.grayF9,
      appBar: CustomAppBar(
        title: 'Post Ad',
        backgroundColor: AppColors.white,
      ),
      body: Padding(
        padding: EdgeInsets.all(4.w),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildUploadSection(),
                    SizedBox(height: 2.h),
                    _buildUploadDetails(),
                    SizedBox(height: 4.h),
                    _buildImageGrid(),
                  ],
                ),
              ),
            ),
            _buildBottomSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildUploadSection() {
    return GestureDetector(
      onTap: _pickImages,
      child: DottedBorder(
        color: Colors.grey.withValues(alpha: 0.5),
        strokeWidth: 2,
        dashWidth: 5,
        dashSpace: 3,
        borderRadius: BorderRadius.circular(30),
        child: SizedBox(
          width: double.infinity,
          height: 12.h,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  'Upload Images',
                  style: AppTypography.bodySmall.copyWith(
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF222222).withValues(alpha: 0.72),
                  ),
                ),
              ),
              SizedBox(height: 2.h),
              SvgPicture.asset(
                'assets/icons/upload.svg',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUploadDetails() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(15),
          ),
          child: Text(
            '${_selectedImages.length} images added',
            style: AppTypography.bodySmall.copyWith(
              fontSize: 11.sp,
            ),
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(15),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 4,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.blueGray374957,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              SizedBox(width: 6),
              Flexible(
                child: Text(
                  'Drag images to arrange',
                  style: AppTypography.bodySmall.copyWith(
                    fontSize: 11.sp,
                  ),
                ),
              ),
            ],
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(15),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 4,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.blueGray374957,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              SizedBox(width: 6),
              Flexible(
                child: Text(
                  'Tap image twice to delete',
                  style: AppTypography.bodySmall.copyWith(
                    fontSize: 11.sp,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildImageGrid() {
    if (_selectedImages.isEmpty) {
      return SizedBox.shrink();
    }

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1,
      ),
      itemCount: _selectedImages.length,
      itemBuilder: (context, index) {
        final _ImageItem item = _selectedImages[index];
        return KeyedSubtree(
          key: ValueKey('grid-${item.id}'),
          child: _buildFluidDraggableImageTile(index, item),
        );
      },
    );
  }

  Widget _buildFluidDraggableImageTile(int index, _ImageItem item) {
    return Draggable<int>(
      key: ValueKey('draggable-${item.id}'),
      data: item.id,
      feedback: Material(
        color: Colors.transparent,
        child: Transform.scale(
          scale: 1.1,
          child: Container(
            width: 25.w,
            height: 25.w,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.4),
                  blurRadius: 12,
                  offset: Offset(0, 6),
                ),
              ],
            ),
            clipBehavior: Clip.antiAlias,
            child: Image.asset(
              item.path,
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
      childWhenDragging: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.transparent,
        ),
      ),
      child: DragTarget<int>(
        onWillAccept: (data) {
          return data != null && data != item.id;
        },
        onAccept: (data) {
          final int fromIndex = _selectedImages
              .indexWhere((element) => element.id == data);
          if (fromIndex == -1) return;

          setState(() {
            final _ImageItem moved = _selectedImages.removeAt(fromIndex);
            int toIndex = index;
            if (fromIndex < index) {
              toIndex = index - 1;
            }
            if (toIndex < 0) toIndex = 0;
            if (toIndex > _selectedImages.length) {
              toIndex = _selectedImages.length;
            }
            _selectedImages.insert(toIndex, moved);
          });
        },
        builder: (context, candidateData, rejectedData) {
          return AnimatedContainer(
            duration: Duration(milliseconds: 200),
            curve: Curves.easeInOut,
            child: _buildImageTile(index, item),
          );
        },
      ),
    );
  }

  Widget _buildImageTile(int index, _ImageItem item) {
    return GestureDetector(
      onDoubleTap: () => _removeImage(index),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: AppColors.gray8B959E.withValues(alpha: 0.2),
          ),
        ),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          children: [
            Image.asset(
              item.path,
              width: double.infinity,
              height: double.infinity,
              fit: BoxFit.cover,
            ),
            Positioned(
              top: 4,
              right: 4,
              child: GestureDetector(
                onTap: () => _removeImage(index),
                child: Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.6),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.close,
                    color: Colors.white,
                    size: 16,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomSection() {
    return Column(
      children: [
        SizedBox(height: 2.h),
        CustomButton.filled(
          backgroundColor: AppColors.white,
          label: 'Next',
          isPrimary: true,
          onPressed: _proceedToNext,
        ),
        SizedBox(height: 2.h),
      ],
    );
  }
}
