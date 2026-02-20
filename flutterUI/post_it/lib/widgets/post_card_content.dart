import 'package:flutter/material.dart';
import '../models/post_model.dart';
import '../theme/app_colors.dart';
import '../widgets/glass_container.dart';
import 'package:cached_network_image/cached_network_image.dart';

class PostCardContent extends StatelessWidget {
  final Post post;
  final bool showSwipeHint;

  const PostCardContent({
    super.key,
    required this.post,
    this.showSwipeHint = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.4),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Background
          _buildBackground(),

          // Dark overlay gradient
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withValues(alpha: 0.3),
                  Colors.transparent,
                  Colors.transparent,
                  Colors.black.withValues(alpha: 0.7),
                ],
                stops: const [0.0, 0.3, 0.6, 1.0],
              ),
            ),
          ),

          // Top info
          Positioned(
            top: 16,
            left: 16,
            right: 16,
            child: _buildTopInfo(context),
          ),

          // Text content (centered for text-only, bottom for media)
          if (post.textContent != null)
            post.type == PostType.text
                ? Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 32),
                      child: Text(
                        post.textContent!,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.w800,
                          height: 1.3,
                          letterSpacing: -0.5,
                          shadows: [
                            Shadow(
                              blurRadius: 20,
                              color: Colors.black54,
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                : Positioned(
                    bottom: 80,
                    left: 20,
                    right: 20,
                    child: Text(
                      post.textContent!,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        height: 1.3,
                        shadows: [
                          Shadow(
                            blurRadius: 20,
                            color: Colors.black54,
                          ),
                        ],
                      ),
                    ),
                  ),

          // Bottom overlay
          Positioned(
            bottom: 16,
            left: 16,
            right: 16,
            child: _buildBottomOverlay(context),
          ),
        ],
      ),
    );
  }

  Widget _buildBackground() {
    switch (post.type) {
      case PostType.image:
        return CachedNetworkImage(
          imageUrl: post.mediaUrl!,
          fit: BoxFit.cover,
          placeholder: (context, url) => Container(
            color: AppColors.surfaceLight,
            child: const Center(
              child: CircularProgressIndicator(
                color: AppColors.accent,
                strokeWidth: 2,
              ),
            ),
          ),
          errorWidget: (context, url, error) => Container(
            color: AppColors.surfaceLight,
            child: const Icon(Icons.broken_image, color: AppColors.textTertiary),
          ),
        );
      case PostType.video:
        // Video placeholder for now
        return Container(
          color: AppColors.surface,
          child: const Center(
            child: Icon(
              Icons.play_circle_outline,
              size: 64,
              color: AppColors.textSecondary,
            ),
          ),
        );
      case PostType.text:
        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                post.gradientStart ?? AppColors.postGradients[0][0],
                post.gradientEnd ?? AppColors.postGradients[0][1],
              ],
            ),
          ),
        );
    }
  }

  Widget _buildTopInfo(BuildContext context) {
    return Row(
      children: [
        // Avatar
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white, width: 2),
            image: DecorationImage(
              image: CachedNetworkImageProvider(post.authorAvatar),
              fit: BoxFit.cover,
            ),
          ),
        ),
        const SizedBox(width: 10),
        // Username & time
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                post.authorName,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  shadows: [Shadow(blurRadius: 10, color: Colors.black54)],
                ),
              ),
              Text(
                post.timeAgo,
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.7),
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
        // One view badge
        GlassContainer(
          blur: 10,
          opacity: 0.15,
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          borderRadius: BorderRadius.circular(20),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.visibility, color: AppColors.accent, size: 14),
              const SizedBox(width: 4),
              const Text(
                '1 View',
                style: TextStyle(
                  color: AppColors.accent,
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBottomOverlay(BuildContext context) {
    if (!showSwipeHint) return const SizedBox.shrink();

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.swipe,
          color: Colors.white.withValues(alpha: 0.5),
          size: 18,
        ),
        const SizedBox(width: 6),
        Text(
          'Swipe to interact',
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.5),
            fontSize: 13,
            fontWeight: FontWeight.w500,
            letterSpacing: 0.5,
          ),
        ),
      ],
    );
  }
}
