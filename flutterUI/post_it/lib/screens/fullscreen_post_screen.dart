import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/post_model.dart';
import '../services/app_state.dart';
import '../theme/app_colors.dart';
import '../widgets/glass_container.dart';
import '../widgets/post_card_content.dart';
import '../widgets/viewed_overlay.dart';

class FullscreenPostScreen extends ConsumerStatefulWidget {
  final Post post;
  final bool isOwnerView;

  /// All owner posts for scrolling (only used when [isOwnerView] is true).
  final List<Post> ownerPosts;

  /// Initial index in [ownerPosts] to start from.
  final int initialIndex;

  const FullscreenPostScreen({
    super.key,
    required this.post,
    this.isOwnerView = false,
    this.ownerPosts = const [],
    this.initialIndex = 0,
  });

  @override
  ConsumerState<FullscreenPostScreen> createState() =>
      _FullscreenPostScreenState();
}

class _FullscreenPostScreenState extends ConsumerState<FullscreenPostScreen>
    with SingleTickerProviderStateMixin {
  bool _showViewedOverlay = false;
  bool _hasMarkedViewed = false;
  late AnimationController _fadeController;
  late PageController _pageController;
  late int _currentPage;

  @override
  void initState() {
    super.initState();
    _currentPage = widget.initialIndex;
    _pageController = PageController(initialPage: widget.initialIndex);
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    // Show viewed overlay after a short delay (only for non-owner)
    if (!widget.isOwnerView) {
      Future.delayed(const Duration(milliseconds: 600), () {
        if (mounted) {
          setState(() => _showViewedOverlay = true);
        }
      });
    }
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  void _dismiss() {
    if (!widget.isOwnerView && !_hasMarkedViewed) {
      _hasMarkedViewed = true;
      ref.read(feedPostsProvider.notifier).markAsViewed(widget.post.id);
    }
    Navigator.of(context).pop();
  }

  Post get _currentPost {
    if (widget.isOwnerView && widget.ownerPosts.isNotEmpty) {
      return widget.ownerPosts[_currentPage];
    }
    return widget.post;
  }

  @override
  Widget build(BuildContext context) {
    // Owner view: vertical PageView scrolling through all posts
    if (widget.isOwnerView && widget.ownerPosts.isNotEmpty) {
      return Scaffold(
        backgroundColor: AppColors.background,
        body: Stack(
          children: [
            PageView.builder(
              controller: _pageController,
              scrollDirection: Axis.vertical,
              itemCount: widget.ownerPosts.length,
              onPageChanged: (index) => setState(() => _currentPage = index),
              itemBuilder: (context, index) {
                return _buildOwnerPostPage(widget.ownerPosts[index]);
              },
            ),

            // Close button
            _buildCloseButton(),

            // View count
            _buildViewCountBadge(_currentPost),

            // Page indicator
            Positioned(
              right: 16,
              top: 0,
              bottom: 0,
              child: Center(
                child: _buildPageIndicator(),
              ),
            ),

            // Scroll hint at bottom
            Positioned(
              bottom: MediaQuery.of(context).padding.bottom + 20,
              left: 0,
              right: 0,
              child: Center(
                child: AnimatedOpacity(
                  opacity:
                      _currentPage < widget.ownerPosts.length - 1 ? 1.0 : 0.0,
                  duration: const Duration(milliseconds: 200),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.keyboard_arrow_down_rounded,
                        color: Colors.white.withValues(alpha: 0.5),
                        size: 28,
                      ),
                      Text(
                        'Scroll for next post',
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.5),
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }

    // Non-owner view: single post with swipe-down dismiss
    return Scaffold(
      backgroundColor: AppColors.background,
      body: GestureDetector(
        onVerticalDragEnd: (details) {
          if (details.velocity.pixelsPerSecond.dy > 300) {
            _dismiss();
          }
        },
        child: Stack(
          fit: StackFit.expand,
          children: [
            Hero(
              tag: 'post_${widget.post.id}',
              child: PostCardContent(
                post: widget.post,
                showSwipeHint: false,
              ),
            ),
            _buildCloseButton(),
            Positioned(
              bottom: MediaQuery.of(context).padding.bottom + 20,
              left: 0,
              right: 0,
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.keyboard_arrow_down_rounded,
                      color: Colors.white.withValues(alpha: 0.4),
                      size: 28,
                    ),
                    Text(
                      'Swipe down to dismiss',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.4),
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if (_showViewedOverlay)
              Center(
                child: ViewedOverlay(onComplete: () {}),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildOwnerPostPage(Post post) {
    return PostCardContent(
      post: post,
      showSwipeHint: false,
    );
  }

  Widget _buildCloseButton() {
    return Positioned(
      top: MediaQuery.of(context).padding.top + 12,
      right: 16,
      child: GestureDetector(
        onTap: _dismiss,
        child: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: Colors.black.withValues(alpha: 0.5),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.close,
            color: Colors.white,
            size: 20,
          ),
        ),
      ),
    );
  }

  Widget _buildViewCountBadge(Post post) {
    if (!widget.isOwnerView) return const SizedBox.shrink();
    final viewCount = post.viewedByUserIds.length;

    return Positioned(
      top: MediaQuery.of(context).padding.top + 16,
      left: 16,
      child: GlassContainer(
        blur: 15,
        opacity: 0.2,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        borderRadius: BorderRadius.circular(20),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.visibility_rounded,
              color: AppColors.accent,
              size: 18,
            ),
            const SizedBox(width: 8),
            Text(
              '$viewCount ${viewCount == 1 ? 'view' : 'views'}',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPageIndicator() {
    if (!widget.isOwnerView || widget.ownerPosts.length <= 1) {
      return const SizedBox.shrink();
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(widget.ownerPosts.length, (index) {
        final isActive = index == _currentPage;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: isActive ? 4 : 4,
          height: isActive ? 20 : 8,
          margin: const EdgeInsets.symmetric(vertical: 3),
          decoration: BoxDecoration(
            color: isActive
                ? AppColors.accent
                : Colors.white.withValues(alpha: 0.3),
            borderRadius: BorderRadius.circular(4),
          ),
        );
      }),
    );
  }
}
