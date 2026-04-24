import 'package:flutter/material.dart';

/// Reusable image widget with proper error handling and fallback support
///
/// This widget displays images from local assets or network with:
/// - Automatic error handling
/// - Placeholder while loading
/// - Fallback to default image on error
/// - Support for different fit modes
/// - Optional border radius

class AppImageWidget extends StatelessWidget {
  /// Path to the image (can be asset or network URL)
  final String imagePath;

  /// Image fit mode (how to size the image)
  final BoxFit fit;

  /// Border radius for the image
  final BorderRadius? borderRadius;

  /// Height of the image container
  final double? height;

  /// Width of the image container
  final double? width;

  /// Color tint applied to image
  final Color? color;

  /// Blend mode for color application
  final BlendMode? colorBlendMode;

  /// Shadow elevation
  final double elevation;

  /// Placeholder widget while loading
  final Widget? placeholder;

  /// Error widget displayed when image fails to load
  final Widget? errorWidget;

  const AppImageWidget({
    super.key,
    required this.imagePath,
    this.fit = BoxFit.cover,
    this.borderRadius,
    this.height,
    this.width,
    this.color,
    this.colorBlendMode,
    this.elevation = 0.0,
    this.placeholder,
    this.errorWidget,
  });

  /// Default placeholder widget
  Widget _buildDefaultPlaceholder() {
    return Container(
      color: Colors.grey[300],
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.movie_outlined,
              size: 40,
              color: Colors.grey[600],
            ),
            const SizedBox(height: 8),
            Text(
              'Loading...',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Default error widget
  Widget _buildDefaultErrorWidget() {
    return Container(
      color: Colors.grey[200],
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.broken_image_outlined,
              size: 40,
              color: Colors.grey[600],
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                'Image Not Available',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Build image based on path type (asset or network)
  Widget _buildImageWidget() {
    if (imagePath.startsWith('http')) {
      // Network image
      return Image.network(
        imagePath,
        fit: fit,
        color: color,
        colorBlendMode: colorBlendMode,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return placeholder ?? _buildDefaultPlaceholder();
        },
        errorBuilder: (context, error, stackTrace) {
          debugPrint('Error loading network image: $imagePath');
          debugPrint('Error: $error');
          return errorWidget ?? _buildDefaultErrorWidget();
        },
      );
    } else if (imagePath.startsWith('assets/')) {
      // Asset image
      return Image.asset(
        imagePath,
        fit: fit,
        color: color,
        colorBlendMode: colorBlendMode,
        errorBuilder: (context, error, stackTrace) {
          debugPrint('Error loading asset image: $imagePath');
          debugPrint('Error: $error');
          return errorWidget ?? _buildDefaultErrorWidget();
        },
      );
    } else {
      // Invalid path
      return errorWidget ?? _buildDefaultErrorWidget();
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget imageWidget = _buildImageWidget();

    // Apply border radius if specified
    if (borderRadius != null) {
      imageWidget = ClipRRect(
        borderRadius: borderRadius!,
        child: imageWidget,
      );
    }

    // Apply sizing
    if (height != null || width != null) {
      imageWidget = SizedBox(
        height: height,
        width: width,
        child: imageWidget,
      );
    }

    // Apply shadow if elevation > 0
    if (elevation > 0) {
      imageWidget = Material(
        elevation: elevation,
        borderRadius: borderRadius,
        child: imageWidget,
      );
    }

    return imageWidget;
  }
}

/// Extension for easy image display
extension ImageExtension on String {
  /// Display image with AppImageWidget
  /// Usage: imagePath.displayAsImage(height: 200, width: 200)
  Widget displayAsImage({
    BoxFit fit = BoxFit.cover,
    BorderRadius? borderRadius,
    double? height,
    double? width,
  }) {
    return AppImageWidget(
      imagePath: this,
      fit: fit,
      borderRadius: borderRadius,
      height: height,
      width: width,
    );
  }
}

