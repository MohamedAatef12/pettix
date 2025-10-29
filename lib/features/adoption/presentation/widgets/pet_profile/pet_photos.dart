import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class PetGallery extends StatelessWidget {
  const PetGallery({super.key});

  @override
  Widget build(BuildContext context) {
    // Example image URLs
    final images = [
      'https://images.unsplash.com/photo-1517423440428-a5a00ad493e8?auto=format&fit=crop&w=800&q=80',
      'https://images.unsplash.com/photo-1518717758536-85ae29035b6d?auto=format&fit=crop&w=800&q=80',
      'https://images.unsplash.com/photo-1507149833265-60c372daea22?auto=format&fit=crop&w=800&q=80',
      'https://images.unsplash.com/photo-1500534623283-312aade485b7?auto=format&fit=crop&w=800&q=80',
      'https://images.unsplash.com/photo-1525253086316-d0c936c814f8?auto=format&fit=crop&w=800&q=80',
      'https://images.unsplash.com/photo-1500534623283-312aade485b7?auto=format&fit=crop&w=800&q=80',
      'https://images.unsplash.com/photo-1517423440428-a5a00ad493e8?auto=format&fit=crop&w=800&q=80',
    ];

    final total = images.length;
    final remaining = total > 5 ? total - 5 : 0;

    // Case 1: Only 1–4 images (grid)
    if (total <= 4) {
      return GridView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        padding: const EdgeInsets.all(8),
        itemCount: total,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 8,
          crossAxisSpacing: 8,
        ),
        itemBuilder: (context, index) {
          final image = images[index];
          return GestureDetector(
            onTap: () => _openImage(context, image),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(image, fit: BoxFit.cover),
            ),
          );
        },
      );
    }

    // Case 2: 5 or more images
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
      child: Column(
        children: [
          // Large top image
          GestureDetector(
            onTap: () => _openImage(context, images[0]),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.network(
                images[0],
                fit: BoxFit.cover,
                height: 320.h,
                width: double.infinity,
              ),
            ),
          ),
          const SizedBox(height: 8),

          // 4 small images below
          MasonryGridView.count(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            crossAxisCount: 4,
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
            itemCount: 4,
            itemBuilder: (context, index) {
              final image = images[index + 1];
              final isLast = index == 3 && remaining > 0;

              return GestureDetector(
                onTap:
                    () =>
                        isLast
                            ? _openGallery(context, images)
                            : _openImage(context, image),
                child: Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(
                        image,
                        fit: BoxFit.cover,
                        height: 120.h,
                        width: double.infinity,
                      ),
                    ),
                    if (isLast)
                      Container(
                        height: 120.h,
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.45),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          '+$remaining',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  // 🖼 Open a single image fullscreen
  void _openImage(BuildContext context, String image) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => _FullImageView(imageUrl: image)),
    );
  }

  // 🗂 Open full gallery view
  void _openGallery(BuildContext context, List<String> images) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => _FullGalleryView(images: images)),
    );
  }
}

// -------------------------------
// 🖼 Fullscreen image view
// -------------------------------
class _FullImageView extends StatelessWidget {
  final String imageUrl;
  const _FullImageView({required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(backgroundColor: Colors.transparent),
      body: Center(child: InteractiveViewer(child: Image.network(imageUrl))),
    );
  }
}

// -------------------------------
// 🗂 Full gallery grid view
// -------------------------------
class _FullGalleryView extends StatelessWidget {
  final List<String> images;
  const _FullGalleryView({required this.images});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Gallery')),
      body: GridView.builder(
        padding: const EdgeInsets.all(8),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          mainAxisSpacing: 8,
          crossAxisSpacing: 8,
        ),
        itemCount: images.length,
        itemBuilder:
            (context, index) => GestureDetector(
              onTap:
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => _FullImageView(imageUrl: images[index]),
                    ),
                  ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(images[index], fit: BoxFit.cover),
              ),
            ),
      ),
    );
  }
}
