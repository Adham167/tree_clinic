
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:tree_clinic/core/localization/localization_extensions.dart';

class ImageHeader extends StatelessWidget {
  const ImageHeader({required this.imagePath});

  final String imagePath;

  @override
  Widget build(BuildContext context) {
    final file = File(imagePath);

    return AspectRatio(
      aspectRatio: 4 / 3,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Stack(
          fit: StackFit.expand,
          children: [
            if (file.existsSync())
              Image.file(file, fit: BoxFit.cover)
            else
              Container(
                color: Colors.green.withValues(alpha: 0.08),
                child: const Center(
                  child: Icon(Icons.image_outlined, size: 56),
                ),
              ),
            Positioned(
              left: 12,
              right: 12,
              bottom: 12,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.55),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.eco, color: Colors.white),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        context.tr('Uploaded leaf image'),
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
