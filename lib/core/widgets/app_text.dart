// lib/core/widgets/app_text.dart
import 'package:flutter/material.dart';

/// Custom text style variants that match the app's typography system
enum CustomTextVariant {
  // Display styles
  displayLarge,
  displayMedium,
  displaySmall,

  // Headline styles
  headlineLarge,
  headlineMedium,
  headlineSmall,

  // Body styles
  bodyLarge,
  bodyMedium,
  bodySmall,

  // Label styles
  labelLarge,
  labelMedium,
  labelSmall,

  // Title styles
  titleLarge,
  titleMedium,
  titleSmall,
}

/// Custom text widget that follows the app's design system.
/// All colors come from Theme — works automatically in light & dark mode.
class CustomText extends StatelessWidget {
  const CustomText(
      this.text, {
        super.key,
        this.variant = CustomTextVariant.bodyMedium,
        this.color,
        this.fontSize,
        this.fontWeight,
        this.letterSpacing,
        this.height,
        this.textAlign,
        this.maxLines,
        this.overflow,
        this.softWrap,
        this.fontFamily,
        this.decoration,
        this.decorationColor,
        this.decorationStyle,
        this.decorationThickness,
      });

  final String text;
  final CustomTextVariant variant;
  final Color? color;
  final double? fontSize;
  final FontWeight? fontWeight;
  final double? letterSpacing;
  final double? height;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;
  final bool? softWrap;
  final String? fontFamily;
  final TextDecoration? decoration;
  final Color? decorationColor;
  final TextDecorationStyle? decorationStyle;
  final double? decorationThickness;

  TextStyle _getBaseStyle(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    switch (variant) {
      case CustomTextVariant.displayLarge:   return textTheme.displayLarge!;
      case CustomTextVariant.displayMedium:  return textTheme.displayMedium!;
      case CustomTextVariant.displaySmall:   return textTheme.displaySmall!;
      case CustomTextVariant.headlineLarge:  return textTheme.headlineLarge!;
      case CustomTextVariant.headlineMedium: return textTheme.headlineMedium!;
      case CustomTextVariant.headlineSmall:  return textTheme.headlineSmall!;
      case CustomTextVariant.bodyLarge:      return textTheme.bodyLarge!;
      case CustomTextVariant.bodyMedium:     return textTheme.bodyMedium!;
      case CustomTextVariant.bodySmall:      return textTheme.bodySmall!;
      case CustomTextVariant.labelLarge:     return textTheme.labelLarge!;
      case CustomTextVariant.labelMedium:    return textTheme.labelMedium!;
      case CustomTextVariant.labelSmall:     return textTheme.labelSmall!;
      case CustomTextVariant.titleLarge:     return textTheme.titleLarge!;
      case CustomTextVariant.titleMedium:    return textTheme.titleMedium!;
      case CustomTextVariant.titleSmall:     return textTheme.titleSmall!;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
      softWrap: softWrap,
      style: _getBaseStyle(context).copyWith(
        // color comes from textTheme by default (adapts light/dark).
        // If a color override is passed, it is applied on top.
        color: color,
        fontSize: fontSize,
        fontWeight: fontWeight,
        letterSpacing: letterSpacing,
        height: height,
        fontFamily: fontFamily,
        decoration: decoration,
        decorationColor: decorationColor,
        decorationStyle: decorationStyle,
        decorationThickness: decorationThickness,
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// CONVENIENCE WIDGETS  —  all use colorScheme, no AppColors import
// ─────────────────────────────────────────────────────────────

/// Renders text in colorScheme.primary
class PrimaryText extends StatelessWidget {
  const PrimaryText(
      this.text, {
        super.key,
        this.variant = CustomTextVariant.bodyMedium,
        this.textAlign,
        this.maxLines,
        this.overflow,
      });

  final String text;
  final CustomTextVariant variant;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;

  @override
  Widget build(BuildContext context) {
    return CustomText(
      text,
      variant: variant,
      // ✅ reads primary from current theme (light or dark)
      color: Theme.of(context).colorScheme.primary,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
    );
  }
}

/// Renders text in colorScheme.error
class ErrorText extends StatelessWidget {
  const ErrorText(
      this.text, {
        super.key,
        this.variant = CustomTextVariant.bodySmall,
        this.textAlign,
        this.maxLines,
        this.overflow,
      });

  final String text;
  final CustomTextVariant variant;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;

  @override
  Widget build(BuildContext context) {
    return CustomText(
      text,
      variant: variant,
      // ✅ reads error from current theme
      color: Theme.of(context).colorScheme.error,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
    );
  }
}

/// Renders text in a green success color (not in Material colorScheme by default,
/// so we keep it as a fixed color — same in light & dark).
class SuccessText extends StatelessWidget {
  const SuccessText(
      this.text, {
        super.key,
        this.variant = CustomTextVariant.bodySmall,
        this.textAlign,
        this.maxLines,
        this.overflow,
      });

  final String text;
  final CustomTextVariant variant;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;

  // Fixed success green — visible on both light and dark backgrounds
  static const Color _successLight = Color(0xFF00A86B);
  static const Color _successDark  = Color(0xFF5FD9A8);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return CustomText(
      text,
      variant: variant,
      color: isDark ? _successDark : _successLight,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
    );
  }
}

/// Renders text in colorScheme.onSurfaceVariant (secondary/muted tone)
class SecondaryText extends StatelessWidget {
  const SecondaryText(
      this.text, {
        super.key,
        this.variant = CustomTextVariant.bodySmall,
        this.textAlign,
        this.maxLines,
        this.overflow,
      });

  final String text;
  final CustomTextVariant variant;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;

  @override
  Widget build(BuildContext context) {
    return CustomText(
      text,
      variant: variant,
      // ✅ reads onSurfaceVariant from current theme
      color: Theme.of(context).colorScheme.onSurfaceVariant,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
    );
  }
}

/// Renders text in colorScheme.onSurface with optional color override
class ColoredText extends StatelessWidget {
  const ColoredText(
      this.text, {
        super.key,
        this.color,
        this.variant = CustomTextVariant.bodyMedium,
        this.textAlign,
        this.maxLines,
        this.overflow,
      });

  final String text;
  final Color? color;
  final CustomTextVariant variant;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;

  @override
  Widget build(BuildContext context) {
    return CustomText(
      text,
      variant: variant,
      color: color,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
    );
  }
}

// ─────────────────────────────────────────────────────────────
// STRING EXTENSIONS  —  unchanged, they pass no color so
// the textTheme default (which is theme-aware) is used.
// ─────────────────────────────────────────────────────────────
extension CustomTextExtension on String {
  CustomText get displayLarge  => CustomText(this, variant: CustomTextVariant.displayLarge);
  CustomText get displayMedium => CustomText(this, variant: CustomTextVariant.displayMedium);
  CustomText get displaySmall  => CustomText(this, variant: CustomTextVariant.displaySmall);

  CustomText get headlineLarge  => CustomText(this, variant: CustomTextVariant.headlineLarge);
  CustomText get headlineMedium => CustomText(this, variant: CustomTextVariant.headlineMedium);
  CustomText get headlineSmall  => CustomText(this, variant: CustomTextVariant.headlineSmall);

  CustomText get bodyLarge  => CustomText(this, variant: CustomTextVariant.bodyLarge);
  CustomText get bodyMedium => CustomText(this, variant: CustomTextVariant.bodyMedium);
  CustomText get bodySmall  => CustomText(this, variant: CustomTextVariant.bodySmall);

  CustomText get labelLarge  => CustomText(this, variant: CustomTextVariant.labelLarge);
  CustomText get labelMedium => CustomText(this, variant: CustomTextVariant.labelMedium);
  CustomText get labelSmall  => CustomText(this, variant: CustomTextVariant.labelSmall);

  CustomText get titleLarge  => CustomText(this, variant: CustomTextVariant.titleLarge);
  CustomText get titleMedium => CustomText(this, variant: CustomTextVariant.titleMedium);
  CustomText get titleSmall  => CustomText(this, variant: CustomTextVariant.titleSmall);

  CustomText withColor(Color color)       => CustomText(this, color: color);
  CustomText withSize(double size)        => CustomText(this, fontSize: size);
  CustomText withWeight(FontWeight weight) => CustomText(this, fontWeight: weight);
}