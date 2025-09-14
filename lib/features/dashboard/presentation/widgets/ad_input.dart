import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:oysloe_mobile/core/themes/theme.dart';
import 'package:oysloe_mobile/core/themes/typo.dart';
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
            initialValue: value,
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

  final ValueChanged<String?> onChanged;
  final String? value;
  final String? hintText;
  final String? labelText;
  final double? width;
  final String? Function(String?)? validator;
  final bool enabled;

  static const List<Map<String, String>> categories = [
    {'id': 'electronics', 'name': 'Electronics', 'icon': 'electronics.png'},
    {'id': 'fashion', 'name': 'Fashion', 'icon': 'fashion.png'},
    {'id': 'furniture', 'name': 'Furniture', 'icon': 'furniture.png'},
    {'id': 'vehicle', 'name': 'Vehicle', 'icon': 'vehicle.png'},
    {'id': 'property', 'name': 'Property', 'icon': 'property.png'},
    {'id': 'services', 'name': 'Services', 'icon': 'services.png'},
    {'id': 'cosmetics', 'name': 'Cosmetics', 'icon': 'cosmetics.png'},
    {'id': 'grocery', 'name': 'Grocery', 'icon': 'grocery.png'},
    {'id': 'games', 'name': 'Games', 'icon': 'games.png'},
    {'id': 'industrial', 'name': 'Industrial', 'icon': 'industrial.png'},
  ];

  @override
  Widget build(BuildContext context) {
    return AdDropdown<String>(
      value: value,
      onChanged: onChanged,
      hintText: hintText ?? 'Select product Category',
      labelText: labelText,
      width: width,
      validator: validator,
      enabled: enabled,
      items: categories.map((category) {
        return DropdownMenuItem<String>(
          value: category['id'],
          child: Row(
            children: [
              Image.asset(
                'assets/images/${category['icon']}',
                width: 24,
                height: 24,
                errorBuilder: (context, error, stackTrace) {
                  return Icon(
                    Icons.category,
                    size: 24,
                    color: AppColors.gray8B959E,
                  );
                },
              ),
              const SizedBox(width: 12),
              Text(category['name']!),
            ],
          ),
        );
      }).toList(),
    );
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

  final ValueChanged<String?> onChanged;
  final String? value;
  final String? hintText;
  final String? labelText;
  final double? width;
  final String? Function(String?)? validator;
  final bool enabled;

  static const List<String> locations = [
    'Home Spintex',
    'Shop Accra',
    'Shop East Legon',
    'Shop Kumasi',
    'Tema',
    'Takoradi',
    'Ashanti Region',
    'Western Region',
    'Central Region',
    'Greater Accra',
  ];

  @override
  Widget build(BuildContext context) {
    return AdDropdown<String>(
      value: value,
      onChanged: onChanged,
      hintText: hintText ?? 'Ad Area Location',
      labelText: labelText,
      width: width,
      validator: validator,
      enabled: enabled,
      items: locations.map((location) {
        return DropdownMenuItem<String>(
          value: location,
          child: Text(location),
        );
      }).toList(),
    );
  }
}
