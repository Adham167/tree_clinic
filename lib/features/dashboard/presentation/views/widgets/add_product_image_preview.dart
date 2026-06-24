import 'package:flutter/material.dart';
import 'package:tree_clinic/core/localization/localization_extensions.dart';

class AddProductImagePreview extends StatelessWidget {
  const AddProductImagePreview({super.key, required this.url});

  final String url;

  @override
  Widget build(BuildContext context) {
    if (url.isEmpty) {
      return const AddProductImagePlaceholder();
    }

    final uri = Uri.tryParse(url);
    final canPreview =
        uri != null &&
        uri.host.isNotEmpty &&
        (uri.scheme == 'http' || uri.scheme == 'https');

    return AspectRatio(
      aspectRatio: 16 / 9,
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.green.withValues(alpha: 0.35)),
        ),
        clipBehavior: Clip.antiAlias,
        child: canPreview
            ? Image.network(
                url,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Center(
                  child: Text(context.tr('Image preview is not available')),
                ),
              )
            : const AddProductImagePlaceholder(),
      ),
    );
  }
}

class AddProductImagePlaceholder extends StatelessWidget {
  const AddProductImagePlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 16 / 9,
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.green.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.green.withValues(alpha: 0.25)),
        ),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.image_outlined, color: Colors.green, size: 36),
              const SizedBox(height: 8),
              Text(context.tr('No image URL selected')),
            ],
          ),
        ),
      ),
    );
  }
}