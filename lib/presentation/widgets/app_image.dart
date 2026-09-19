import 'package:flutter/material.dart';
import '../../core/theme.dart';

/// A robust image rendering widget that seamlessly handles both local asset paths
/// (e.g. `assets/images/paris.jpg`) and remote network URLs (e.g. `https://...`),
/// with built-in loading and error fallback states.
class AppImage extends StatelessWidget {
  final String? imagePath;
  final double? width;
  final double? height;
  final BoxFit fit;
  final BorderRadius? borderRadius;
  final Widget? fallback;

  const AppImage({
    super.key,
    required this.imagePath,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.borderRadius,
    this.fallback,
  });

  bool get _isNetwork =>
      imagePath != null &&
      (imagePath!.startsWith('http://') || imagePath!.startsWith('https://'));

  bool get _isAsset =>
      imagePath != null &&
      (imagePath!.startsWith('assets/') || !imagePath!.contains('://'));

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    Widget placeholder() {
      if (fallback != null) return fallback!;
      return Container(
        width: width,
        height: height,
        color: isDark ? AppColors.surfaceTile2 : AppColors.canvasParchment,
        child: const Center(
          child: Icon(Icons.travel_explore, size: 36, color: AppColors.hairline),
        ),
      );
    }

    if (imagePath == null || imagePath!.trim().isEmpty) {
      return _wrapRadius(placeholder());
    }

    Widget imageWidget;

    if (_isNetwork) {
      imageWidget = Image.network(
        imagePath!,
        width: width,
        height: height,
        fit: fit,
        errorBuilder: (context, error, stackTrace) => placeholder(),
        loadingBuilder: (context, child, progress) {
          if (progress == null) return child;
          return Container(
            width: width,
            height: height,
            color: isDark ? AppColors.surfaceTile2 : AppColors.canvasParchment,
            child: const Center(
              child: SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            ),
          );
        },
      );
    } else if (_isAsset) {
      imageWidget = Image.asset(
        imagePath!,
        width: width,
        height: height,
        fit: fit,
        errorBuilder: (context, error, stackTrace) => placeholder(),
      );
    } else {
      imageWidget = placeholder();
    }

    return _wrapRadius(imageWidget);
  }

  Widget _wrapRadius(Widget child) {
    if (borderRadius != null) {
      return ClipRRect(borderRadius: borderRadius!, child: child);
    }
    return child;
  }
}
