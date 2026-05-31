// lib/core/widgets/app_text_filed.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// A fully theme-aware text form field.
/// Every color is derived from Theme.of(context).colorScheme —
/// works automatically in both light and dark mode.
class CustomTextFormField extends StatefulWidget {
  // Controller
  final TextEditingController? controller;
  final String? initialValue;

  // Validation
  final String? Function(String?)? validator;
  final Function(String)? onChanged;
  final Function(String)? onFieldSubmitted;
  final VoidCallback? onEditingComplete;

  // Labels and hints
  final String? labelText;
  final String? hintText;
  final String? helperText;
  final String? errorText;

  // Icons
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final Widget? prefix;
  final Widget? suffix;

  // Styling
  final bool obscureText;
  final bool enabled;
  final bool readOnly;
  final bool autofocus;
  final int? maxLines;
  final int? minLines;
  final int? maxLength;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final TextCapitalization textCapitalization;

  // Sizes
  final double? height;
  final double? width;

  // Optional color overrides (if null → colorScheme is used)
  final Color? fillColor;
  final Color? focusedBorderColor;
  final Color? enabledBorderColor;
  final Color? errorBorderColor;
  final Color? textColor;
  final Color? hintColor;
  final Color? labelColor;

  // Borders
  final double borderRadius;
  final double borderWidth;
  final EdgeInsetsGeometry? contentPadding;

  // Focus
  final FocusNode? focusNode;

  // Other
  final bool showCounter;
  final bool showClearButton;
  final bool autoValidate;
  final List<TextInputFormatter>? inputFormatters;

  const CustomTextFormField({
    super.key,
    this.controller,
    this.initialValue,
    this.validator,
    this.onChanged,
    this.onFieldSubmitted,
    this.onEditingComplete,
    this.labelText,
    this.hintText,
    this.helperText,
    this.errorText,
    this.prefixIcon,
    this.suffixIcon,
    this.prefix,
    this.suffix,
    this.obscureText = false,
    this.enabled = true,
    this.readOnly = false,
    this.autofocus = false,
    this.maxLines = 1,
    this.minLines,
    this.maxLength,
    this.keyboardType,
    this.textInputAction,
    this.textCapitalization = TextCapitalization.none,
    this.height,
    this.width,
    this.fillColor,
    this.focusedBorderColor,
    this.enabledBorderColor,
    this.errorBorderColor,
    this.textColor,
    this.hintColor,
    this.labelColor,
    this.borderRadius = 12,
    this.borderWidth = 1,
    this.contentPadding,
    this.focusNode,
    this.showCounter = false,
    this.showClearButton = false,
    this.autoValidate = false,
    this.inputFormatters,
  });

  @override
  State<CustomTextFormField> createState() => _CustomTextFormFieldState();
}

class _CustomTextFormFieldState extends State<CustomTextFormField> {
  late FocusNode _focusNode;
  bool _isFocused = false;
  bool _obscureText = false;

  @override
  void initState() {
    super.initState();
    _focusNode = widget.focusNode ?? FocusNode();
    _focusNode.addListener(_onFocusChange);
    _obscureText = widget.obscureText;
  }

  @override
  void dispose() {
    if (widget.focusNode == null) {
      _focusNode.dispose();
    } else {
      _focusNode.removeListener(_onFocusChange);
    }
    super.dispose();
  }

  void _onFocusChange() {
    setState(() => _isFocused = _focusNode.hasFocus);
  }

  void _clearText() {
    widget.controller?.clear();
    widget.onChanged?.call('');
    setState(() {});
  }

  // ── Color helpers — all fall back to colorScheme ──────────────

  Color _getBorderColor(ColorScheme cs) {
    if (!widget.enabled) return cs.outlineVariant;
    if (_focusNode.hasFocus) return widget.focusedBorderColor ?? cs.primary;
    final hasError = widget.errorText != null ||
        widget.validator?.call(widget.controller?.text) != null;
    if (hasError) return widget.errorBorderColor ?? cs.error;
    return widget.enabledBorderColor ?? cs.outlineVariant;
  }

  Color _getFillColor(ColorScheme cs) {
    if (!widget.enabled) return cs.surfaceContainerHighest;
    return widget.fillColor ?? cs.surfaceContainerLowest;
  }

  Color _iconColor(ColorScheme cs) =>
      _isFocused ? cs.primary : cs.outline;

  // ─────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final tt = theme.textTheme;

    final borderColor = _getBorderColor(cs);
    final fillColor  = _getFillColor(cs);

    return SizedBox(
      height: widget.height,
      width: widget.width,
      child: TextFormField(
        controller: widget.controller,
        initialValue: widget.initialValue,
        focusNode: _focusNode,
        validator: widget.autoValidate ? widget.validator : null,
        onChanged: widget.onChanged,
        onFieldSubmitted: widget.onFieldSubmitted,
        onEditingComplete: widget.onEditingComplete,
        obscureText: _obscureText,
        enabled: widget.enabled,
        readOnly: widget.readOnly,
        autofocus: widget.autofocus,
        maxLines: widget.maxLines,
        minLines: widget.minLines,
        maxLength: widget.maxLength,
        keyboardType: widget.keyboardType,
        textInputAction: widget.textInputAction,
        textCapitalization: widget.textCapitalization,
        inputFormatters: widget.inputFormatters,

        // ✅ Text color from colorScheme.onSurface
        style: tt.bodyMedium?.copyWith(
          color: widget.textColor ?? cs.onSurface,
        ),

        decoration: InputDecoration(
          labelText: widget.labelText,
          hintText: widget.hintText,
          helperText: widget.helperText,
          errorText: widget.errorText,

          // ✅ Prefix icon color from colorScheme
          prefixIcon: widget.prefixIcon != null
              ? Icon(widget.prefixIcon, color: _iconColor(cs), size: 20)
              : widget.prefix,

          suffixIcon: _buildSuffixIcon(cs),

          filled: true,
          // ✅ Fill color from colorScheme
          fillColor: fillColor,

          contentPadding: widget.contentPadding ??
              const EdgeInsets.symmetric(horizontal: 16, vertical: 16),

          counterText: widget.showCounter && widget.maxLength != null
              ? '${widget.controller?.text.length ?? 0}/${widget.maxLength}'
              : null,

          // All border colors from colorScheme
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(widget.borderRadius),
            borderSide: BorderSide(color: borderColor, width: widget.borderWidth),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(widget.borderRadius),
            borderSide: BorderSide(color: borderColor, width: widget.borderWidth),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(widget.borderRadius),
            borderSide: BorderSide(color: borderColor, width: 2),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(widget.borderRadius),
            borderSide: BorderSide(color: cs.error, width: widget.borderWidth),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(widget.borderRadius),
            borderSide: BorderSide(
              color: widget.errorBorderColor ?? cs.error,
              width: 2,
            ),
          ),

          // ✅ Label, hint, helper, error text colors all from colorScheme
          labelStyle: tt.labelMedium?.copyWith(
            color: widget.labelColor ??
                (_isFocused ? cs.primary : cs.outline),
          ),
          hintStyle: tt.bodyMedium?.copyWith(
            color: widget.hintColor ?? cs.outline,
          ),
          helperStyle: tt.bodySmall?.copyWith(
            color: cs.onSurfaceVariant,
          ),
          errorStyle: tt.bodySmall?.copyWith(
            color: cs.error,
          ),
        ),
      ),
    );
  }

  Widget? _buildSuffixIcon(ColorScheme cs) {
    final bool showClear = widget.showClearButton &&
        widget.controller != null &&
        widget.controller!.text.isNotEmpty &&
        !widget.readOnly;
    final bool isPassword = widget.obscureText;

    if (showClear || isPassword) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (showClear)
            IconButton(
              icon: const Icon(Icons.clear, size: 20),
              // ✅ outline from colorScheme
              color: cs.outline,
              onPressed: _clearText,
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(minWidth: 32),
            ),
          if (isPassword)
            IconButton(
              icon: Icon(
                _obscureText ? Icons.visibility_off : Icons.visibility,
                size: 20,
              ),
              // ✅ primary when focused, outline otherwise
              color: _iconColor(cs),
              onPressed: () => setState(() => _obscureText = !_obscureText),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(minWidth: 32),
            ),
          if (widget.suffixIcon != null)
            Padding(
              padding: const EdgeInsets.only(right: 12),
              child: Icon(widget.suffixIcon, color: _iconColor(cs), size: 20),
            ),
          if (widget.suffix != null) widget.suffix!,
        ],
      );
    }

    if (widget.suffixIcon != null) {
      return Icon(widget.suffixIcon, color: _iconColor(cs), size: 20);
    }

    return widget.suffix;
  }
}

// ─────────────────────────────────────────────────────────────
// Validation extensions — unchanged
// ─────────────────────────────────────────────────────────────
extension CustomTextFormFieldValidation on String? {
  String? get isRequired =>
      this == null || this!.isEmpty ? 'This field is required' : null;

  String? get isEmail {
    if (this == null || this!.isEmpty) return null;
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegex.hasMatch(this!) ? null : 'Enter a valid email address';
  }

  String? get isPhoneNumber {
    if (this == null || this!.isEmpty) return null;
    final phoneRegex = RegExp(r'^\+?[0-9]{10,15}$');
    return phoneRegex.hasMatch(this!) ? null : 'Enter a valid phone number';
  }

  String? minLength(int length) {
    if (this == null || this!.isEmpty) return null;
    return this!.length >= length
        ? null
        : 'Must be at least $length characters';
  }

  String? maxLength(int length) {
    if (this == null || this!.isEmpty) return null;
    return this!.length <= length
        ? null
        : 'Must not exceed $length characters';
  }
}