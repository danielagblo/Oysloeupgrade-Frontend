import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:oysloe_mobile/core/themes/theme.dart';
import 'package:oysloe_mobile/core/themes/typo.dart';
import 'package:oysloe_mobile/features/dashboard/domain/entities/category_entity.dart';
import 'package:oysloe_mobile/features/dashboard/domain/entities/subcategory_entity.dart';
import 'package:oysloe_mobile/features/dashboard/domain/entities/location_entity.dart';
import 'package:oysloe_mobile/features/dashboard/presentation/bloc/categories/categories_cubit.dart';
import 'package:oysloe_mobile/features/dashboard/presentation/bloc/categories/categories_state.dart';
import 'package:oysloe_mobile/features/dashboard/presentation/bloc/subcategories/subcategories_cubit.dart';
import 'package:oysloe_mobile/features/dashboard/presentation/bloc/subcategories/subcategories_state.dart';
import 'package:oysloe_mobile/features/dashboard/presentation/bloc/locations/locations_cubit.dart';
import 'package:oysloe_mobile/features/dashboard/presentation/bloc/locations/locations_state.dart';
import 'package:oysloe_mobile/features/dashboard/presentation/widgets/multi_page_bottom_sheet.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class AdInput extends StatefulWidget {
  const AdInput({
    super.key,
    this.controller,
    this.hintText,
    this.labelText,
    this.width,
    this.prefixText,
    this.suffixText,
    this.keyboardType,
    this.textInputAction,
    this.maxLines = 1,
    this.maxLength,
    this.readOnly = false,
    this.enabled = true,
    this.obscureText = false,
    this.onChanged,
    this.onTap,
    this.validator,
    this.inputFormatters,
    this.suffixIcon,
    this.prefixIcon,
  });

  final TextEditingController? controller;
  final String? hintText;
  final String? labelText;
  final double? width;
  final String? prefixText;
  final String? suffixText;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final int? maxLines;
  final int? maxLength;
  final bool readOnly;
  final bool enabled;
  final bool obscureText;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onTap;
  final String? Function(String?)? validator;
  final List<TextInputFormatter>? inputFormatters;
  final Widget? suffixIcon;
  final Widget? prefixIcon;

  @override
  State<AdInput> createState() => _AdInputState();
}

class _AdInputState extends State<AdInput> {
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    Widget textField = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.labelText != null) ...[
          Text(
            widget.labelText!,
            style: AppTypography.bodySmall.copyWith(
              color: isDark ? AppColors.white : AppColors.blueGray374957,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
        ],
        TextFormField(
          controller: widget.controller,
          focusNode: _focusNode,
          keyboardType: widget.keyboardType,
          textInputAction: widget.textInputAction,
          maxLines: widget.maxLines,
          maxLength: widget.maxLength,
          readOnly: widget.readOnly,
          enabled: widget.enabled,
          obscureText: widget.obscureText,
          onChanged: widget.onChanged,
          onTap: widget.onTap,
          validator: widget.validator,
          inputFormatters: widget.inputFormatters,
          style: AppTypography.body.copyWith(
            color: isDark ? AppColors.white : AppColors.blueGray374957,
          ),
          decoration: InputDecoration(
            hintText: widget.hintText,
            hintStyle: AppTypography.body
                .copyWith(color: AppColors.gray8B959E, fontSize: 15.sp),
            prefixText: widget.prefixText,
            suffixText: widget.suffixText,
            prefixIcon: widget.prefixIcon,
            suffixIcon: widget.suffixIcon,
            filled: true,
            fillColor: isDark ? AppColors.blueGray374957 : AppColors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(
                color: isDark ? AppColors.blueGray374957 : AppColors.grayD9,
                width: 1,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(
                color: isDark ? AppColors.blueGray374957 : AppColors.grayD9,
                width: 1,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(
                color: AppColors.blueGray374957.withValues(alpha: 0.5),
                width: 1.5,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(
                color: AppColors.redFF6B6B,
                width: 1,
              ),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(
                color: AppColors.redFF6B6B,
                width: 1.5,
              ),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 14,
            ),
            counterText: '',
          ),
        ),
      ],
    );

    if (widget.width != null) {
      return SizedBox(width: widget.width, child: textField);
    }

    return textField;
  }
}

class AdDropdown<T> extends StatelessWidget {
  const AdDropdown({
    super.key,
    required this.items,
    required this.onChanged,
    this.value,
    this.hintText,
    this.labelText,
    this.width,
    this.validator,
    this.enabled = true,
    this.compact = false,
    this.prefixIcon,
  });

  final List<DropdownMenuItem<T>> items;
  final ValueChanged<T?> onChanged;
  final T? value;
  final String? hintText;
  final String? labelText;
  final double? width;
  final String? Function(T?)? validator;
  final bool enabled;
  final bool compact;
  final Widget? prefixIcon;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    Widget dropdown = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (labelText != null) ...[
          Text(
            labelText!,
            style: AppTypography.bodySmall.copyWith(
              color: isDark ? AppColors.white : AppColors.blueGray374957,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
        ],
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(compact ? 12 : 16),
            border: Border.all(
              color: isDark ? AppColors.blueGray374957 : AppColors.grayD9,
              width: 1,
            ),
            color: isDark ? AppColors.blueGray374957 : AppColors.white,
          ),
          child: DropdownButtonFormField<T>(
            // initialValue: value,
            items: items,
            onChanged: enabled ? onChanged : null,
            validator: validator,
            style: AppTypography.body.copyWith(
              color: isDark ? AppColors.white : AppColors.blueGray374957,
              fontSize: 15.sp,
            ),
            dropdownColor: isDark ? AppColors.blueGray374957 : AppColors.white,
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle: AppTypography.body.copyWith(
                color: AppColors.gray8B959E,
                fontSize: 15.sp,
              ),
              prefixIcon: prefixIcon,
              filled: false,
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
              errorBorder: InputBorder.none,
              focusedErrorBorder: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(
                horizontal: 14,
                vertical: compact ? 1.3.h : 10,
              ),
            ),
            icon: Padding(
              padding: const EdgeInsets.only(right: 14),
              child: Container(
                width: 16,
                height: 16,
                decoration: BoxDecoration(
                  color: isDark
                      ? AppColors.blueGray374957.withValues(alpha: 0.3)
                      : AppColors.grayD9.withValues(alpha: 0.5),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.keyboard_arrow_down,
                  size: 16,
                  color: isDark ? AppColors.white : AppColors.blueGray374957,
                ),
              ),
            ),
          ),
        ),
      ],
    );

    if (width != null) {
      return SizedBox(width: width, child: dropdown);
    }

    return dropdown;
  }
}

class AdEditableDropdown extends StatefulWidget {
  const AdEditableDropdown({
    super.key,
    required this.controller,
    required this.items,
    this.labelText,
    this.hintText,
    this.width,
    this.validator,
    this.enabled = true,
    this.onChanged,
    this.keyboardType,
  });

  final TextEditingController controller;
  final List<String> items;
  final String? labelText;
  final String? hintText;
  final double? width;
  final String? Function(String?)? validator;
  final bool enabled;
  final ValueChanged<String?>? onChanged;
  final TextInputType? keyboardType;

  @override
  State<AdEditableDropdown> createState() => _AdEditableDropdownState();
}

class _AdEditableDropdownState extends State<AdEditableDropdown> {
  OverlayEntry? _overlayEntry;
  final LayerLink _layerLink = LayerLink();
  bool _isDropdownOpen = false;
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      if (!_focusNode.hasFocus && _isDropdownOpen) {
        _closeDropdown();
      }
    });
  }

  @override
  void dispose() {
    _closeDropdown();
    _focusNode.dispose();
    super.dispose();
  }

  void _toggleDropdown() {
    if (_isDropdownOpen) {
      _closeDropdown();
    } else {
      _openDropdown();
    }
  }

  void _openDropdown() {
    if (_isDropdownOpen) return;

    _overlayEntry = _createOverlayEntry();
    Overlay.of(context).insert(_overlayEntry!);
    setState(() {
      _isDropdownOpen = true;
    });
  }

  void _closeDropdown() {
    if (!_isDropdownOpen) return;

    _overlayEntry?.remove();
    _overlayEntry = null;
    setState(() {
      _isDropdownOpen = false;
    });
  }

  OverlayEntry _createOverlayEntry() {
    RenderBox renderBox = context.findRenderObject() as RenderBox;
    Size size = renderBox.size;

    return OverlayEntry(
      builder: (context) => Positioned(
        width: size.width,
        child: CompositedTransformFollower(
          link: _layerLink,
          showWhenUnlinked: false,
          offset: Offset(0.0, size.height + 4),
          child: Material(
            elevation: 4.0,
            borderRadius: BorderRadius.circular(12),
            child: Container(
              constraints: BoxConstraints(
                maxHeight: 200,
              ),
              decoration: BoxDecoration(
                color: Theme.of(context).brightness == Brightness.dark
                    ? AppColors.blueGray374957
                    : AppColors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? AppColors.blueGray374957
                      : AppColors.grayD9,
                  width: 1,
                ),
              ),
              child: ListView.builder(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                itemCount: widget.items.length,
                itemBuilder: (context, index) {
                  final item = widget.items[index];
                  return InkWell(
                    onTap: () {
                      widget.controller.text = item;
                      widget.onChanged?.call(item);
                      _closeDropdown();
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        border: index < widget.items.length - 1
                            ? Border(
                                bottom: BorderSide(
                                  color: Theme.of(context).brightness ==
                                          Brightness.dark
                                      ? AppColors.blueGray374957
                                          .withValues(alpha: 0.3)
                                      : AppColors.grayD9.withValues(alpha: 0.5),
                                  width: 0.5,
                                ),
                              )
                            : null,
                      ),
                      child: Text(
                        item,
                        style: AppTypography.body.copyWith(
                          color: Theme.of(context).brightness == Brightness.dark
                              ? AppColors.white
                              : AppColors.blueGray374957,
                          fontSize: 15.sp,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    Widget field = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.labelText != null) ...[
          Text(
            widget.labelText!,
            style: AppTypography.bodySmall.copyWith(
              color: isDark ? AppColors.white : AppColors.blueGray374957,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
        ],
        CompositedTransformTarget(
          link: _layerLink,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isDark ? AppColors.blueGray374957 : AppColors.grayD9,
                width: 1,
              ),
              color: isDark ? AppColors.blueGray374957 : AppColors.white,
            ),
            child: widget.validator != null
                ? TextFormField(
                    controller: widget.controller,
                    focusNode: _focusNode,
                    enabled: widget.enabled,
                    validator: widget.validator,
                    keyboardType: widget.keyboardType,
                    onChanged: widget.onChanged,
                    textAlignVertical: TextAlignVertical.center,
                    style: AppTypography.body.copyWith(
                      color:
                          isDark ? AppColors.white : AppColors.blueGray374957,
                      fontSize: 15.sp,
                    ),
                    decoration: InputDecoration(
                      hintText: widget.hintText,
                      hintStyle: AppTypography.body.copyWith(
                        color: AppColors.gray8B959E,
                        fontSize: 15.sp,
                      ),
                      filled: false,
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      errorBorder: InputBorder.none,
                      focusedErrorBorder: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 10,
                      ),
                      suffixIcon: GestureDetector(
                        onTap: widget.enabled ? _toggleDropdown : null,
                        child: UnconstrainedBox(
                          child: Padding(
                            padding: const EdgeInsets.only(right: 14),
                            child: Container(
                              width: 16,
                              height: 16,
                              decoration: BoxDecoration(
                                color: isDark
                                    ? AppColors.blueGray374957
                                        .withValues(alpha: 0.3)
                                    : AppColors.grayD9.withValues(alpha: 0.5),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                _isDropdownOpen
                                    ? Icons.keyboard_arrow_up
                                    : Icons.keyboard_arrow_down,
                                size: 16,
                                color: isDark
                                    ? AppColors.white
                                    : AppColors.blueGray374957,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  )
                : TextField(
                    controller: widget.controller,
                    focusNode: _focusNode,
                    enabled: widget.enabled,
                    keyboardType: widget.keyboardType,
                    onChanged: widget.onChanged,
                    textAlignVertical: TextAlignVertical.center,
                    style: AppTypography.body.copyWith(
                      color:
                          isDark ? AppColors.white : AppColors.blueGray374957,
                      fontSize: 15.sp,
                    ),
                    decoration: InputDecoration(
                      hintText: widget.hintText,
                      hintStyle: AppTypography.body.copyWith(
                        color: AppColors.gray8B959E,
                        fontSize: 15.sp,
                      ),
                      filled: false,
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      errorBorder: InputBorder.none,
                      focusedErrorBorder: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 10,
                      ),
                      suffixIcon: GestureDetector(
                        onTap: widget.enabled ? _toggleDropdown : null,
                        child: UnconstrainedBox(
                          child: Container(
                            width: 16,
                            height: 16,
                            decoration: BoxDecoration(
                              color: isDark
                                  ? AppColors.blueGray374957
                                      .withValues(alpha: 0.3)
                                  : AppColors.grayD9.withValues(alpha: 0.5),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              _isDropdownOpen
                                  ? Icons.keyboard_arrow_up
                                  : Icons.keyboard_arrow_down,
                              size: 16,
                              color: isDark
                                  ? AppColors.white
                                  : AppColors.blueGray374957,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
          ),
        ),
      ],
    );

    if (widget.width != null) {
      return SizedBox(width: widget.width, child: field);
    }

    return field;
  }
}

class CategorySelection extends Equatable {
  const CategorySelection({
    required this.categoryId,
    required this.label,
    this.subcategoryId,
  });

  final int categoryId;
  final int? subcategoryId;
  final String label;

  @override
  List<Object?> get props => <Object?>[categoryId, subcategoryId, label];
}

class AdCategoryDropdown extends StatelessWidget {
  const AdCategoryDropdown({
    super.key,
    required this.onChanged,
    this.value,
    this.hintText,
    this.labelText,
    this.width,
    this.validator,
    this.enabled = true,
  });

  final ValueChanged<CategorySelection?> onChanged;
  final CategorySelection? value;
  final String? hintText;
  final String? labelText;
  final double? width;
  final String? Function(CategorySelection?)? validator;
  final bool enabled;

  Future<CategorySelection?> _openCategorySheet(
    BuildContext context,
    CategoriesState categoriesState,
  ) async {
    if (!enabled) return null;
    if (!categoriesState.hasData) {
      await context.read<CategoriesCubit>().fetch(forceRefresh: true);
      if (!context.mounted) return null;
      return null;
    }

    final SubcategoriesCubit subcategoriesCubit =
        context.read<SubcategoriesCubit>();

    // Ensure subcategories are loaded so the sheet can render children immediately.
    await subcategoriesCubit
        .prefetchForCategories(categoriesState.categories.map((c) => c.id));

    if (!context.mounted) return null;

    final SubcategoriesState subcategoriesState =
        subcategoriesCubit.state;

    final sections = _buildSections(
      categoriesState.categories,
      subcategoriesState.cache,
    );

    if (sections.isEmpty) return null;

    final CategorySelection? selected = await showMultiPageBottomSheet<
        CategorySelection>(
      context: context,
      rootPage: MultiPageSheetPage<CategorySelection>(
        title: labelText ?? 'Product Category',
        sections: sections,
      ),
    );

    return selected;
  }

  List<MultiPageSheetSection<CategorySelection>> _buildSections(
    List<CategoryEntity> categories,
    Map<int, List<SubcategoryEntity>> subcategories,
  ) {
    if (categories.isEmpty) return const <MultiPageSheetSection<CategorySelection>>[];

    final List<MultiPageSheetItem<CategorySelection>> items =
        categories.map((CategoryEntity category) {
      final List<SubcategoryEntity> children =
          subcategories[category.id] ?? const <SubcategoryEntity>[];

      if (children.isEmpty) {
        return MultiPageSheetItem<CategorySelection>(
          label: category.name,
          value: CategorySelection(
            categoryId: category.id,
            label: category.name,
          ),
        );
      }

      return MultiPageSheetItem<CategorySelection>(
        label: category.name,
        childBuilder: () => MultiPageSheetPage<CategorySelection>(
          title: category.name,
          sections: [
            MultiPageSheetSection<CategorySelection>(
              items: children
                  .map(
                    (SubcategoryEntity subcategory) =>
                        MultiPageSheetItem<CategorySelection>(
                      label: subcategory.name,
                      value: CategorySelection(
                        categoryId: category.id,
                        subcategoryId: subcategory.id,
                        label: subcategory.name,
                      ),
                    ),
                  )
                  .toList(),
            ),
          ],
        ),
      );
    }).toList();

    return <MultiPageSheetSection<CategorySelection>>[
      MultiPageSheetSection<CategorySelection>(
        items: items,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    Widget formField = BlocBuilder<CategoriesCubit, CategoriesState>(
      builder: (context, categoriesState) {
        final isDark = Theme.of(context).brightness == Brightness.dark;
        final textColor = isDark ? AppColors.white : AppColors.blueGray374957;
        final bool isLoading =
            categoriesState.isLoading && !categoriesState.hasData;

        return FormField<CategorySelection>(
          initialValue: value,
          validator: validator,
          enabled: enabled,
          builder: (state) {
            if (value != state.value) {
              state.didChange(value);
            }
            final CategorySelection? selection = state.value;
            final String? effectiveLabel = selection?.label;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (labelText != null) ...[
                  Text(
                    labelText!,
                    style: AppTypography.bodySmall.copyWith(
                      color: textColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                ],
                GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: enabled
                      ? () async {
                          final CategorySelection? selected =
                              await _openCategorySheet(
                                  context, categoriesState);
                          if (selected != null) {
                            state.didChange(selected);
                            onChanged(selected);
                          }
                        }
                      : null,
                  child: Container(
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.blueGray374957 : AppColors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color:
                            isDark ? AppColors.blueGray374957 : AppColors.grayD9,
                        width: 1,
                      ),
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 14),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            effectiveLabel ??
                                (isLoading
                                    ? 'Loading categories...'
                                    : (hintText ?? 'Select product category')),
                            style: AppTypography.body.copyWith(
                              color: effectiveLabel == null
                                  ? AppColors.gray8B959E
                                  : textColor,
                              fontSize: 15.sp,
                            ),
                          ),
                        ),
                        if (isLoading)
                          SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                AppColors.blueGray374957,
                              ),
                            ),
                          )
                        else
                          Container(
                            width: 16,
                            height: 16,
                            decoration: BoxDecoration(
                              color: AppColors.grayD9.withValues(alpha: 0.5),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.keyboard_arrow_down,
                              size: 16,
                              color: AppColors.blueGray374957,
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
                if (state.hasError)
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      state.errorText ?? '',
                      style: AppTypography.bodySmall.copyWith(
                        color: AppColors.redFF6B6B,
                      ),
                    ),
                  ),
              ],
            );
          },
        );
      },
    );

    if (width != null) {
      return SizedBox(width: width, child: formField);
    }

    return formField;
  }
}

class AdLocationDropdown extends StatelessWidget {
  const AdLocationDropdown({
    super.key,
    required this.onChanged,
    this.value,
    this.hintText,
    this.labelText,
    this.width,
    this.validator,
    this.enabled = true,
  });

  final ValueChanged<LocationEntity?> onChanged;
  final LocationEntity? value;
  final String? hintText;
  final String? labelText;
  final double? width;
  final String? Function(LocationEntity?)? validator;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LocationsCubit, LocationsState>(
      builder: (context, state) {
        if (state.isLoading && !state.hasData) {
          return _buildStatusField(
            context,
            message: 'Loading locations...',
            trailing: SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: const AlwaysStoppedAnimation<Color>(
                  AppColors.blueGray374957,
                ),
              ),
            ),
          );
        }

        if (state.hasError && !state.hasData) {
          return _buildStatusField(
            context,
            message: state.message ?? 'Unable to load locations',
            onRetry: () => context.read<LocationsCubit>().fetch(forceRefresh: true),
          );
        }

        final List<LocationEntity> locations = state.locations;
        if (locations.isEmpty) {
          return _buildStatusField(
            context,
            message: 'No locations available',
            onRetry: () => context.read<LocationsCubit>().fetch(forceRefresh: true),
          );
        }

        return AdDropdown<LocationEntity>(
          value: value,
          onChanged: onChanged,
          hintText: hintText ?? 'Ad Area Location',
          labelText: labelText,
          width: width,
          validator: validator,
          enabled: enabled,
          items: locations
              .map(
                (LocationEntity location) =>
                    DropdownMenuItem<LocationEntity>(
                  value: location,
                  child: Text(location.displayName),
                ),
              )
              .toList(),
        );
      },
    );
  }

  Widget _buildStatusField(
    BuildContext context, {
    required String message,
    Widget? trailing,
    VoidCallback? onRetry,
  }) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    Widget field = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (labelText != null) ...[
          Text(
            labelText!,
            style: AppTypography.bodySmall.copyWith(
              color: isDark ? AppColors.white : AppColors.blueGray374957,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
        ],
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
          decoration: BoxDecoration(
            color: isDark ? AppColors.blueGray374957 : AppColors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isDark ? AppColors.blueGray374957 : AppColors.grayD9,
              width: 1,
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  message,
                  style: AppTypography.body.copyWith(
                    color: AppColors.gray8B959E,
                    fontSize: 15.sp,
                  ),
                ),
              ),
              if (trailing != null) ...[
                SizedBox(width: 8),
                trailing,
              ],
              if (onRetry != null) ...[
                SizedBox(width: 8),
                TextButton(
                  onPressed: onRetry,
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    foregroundColor: AppColors.blueGray374957,
                  ),
                  child: const Text('Retry'),
                ),
              ],
            ],
          ),
        ),
      ],
    );

    if (width != null) {
      return SizedBox(width: width, child: field);
    }

    return field;
  }
}
