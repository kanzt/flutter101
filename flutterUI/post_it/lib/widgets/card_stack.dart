import 'package:flutter/material.dart';
import '../models/post_model.dart';
import '../theme/app_colors.dart';
import 'swipe_card.dart';
import 'post_card_content.dart';

class CardStack extends StatelessWidget {
  final List<Post> posts;
  final ValueChanged<SwipeDirection>? onSwipeComplete;
  final ValueChanged<Post>? onTap;

  const CardStack({
    super.key,
    required this.posts,
    this.onSwipeComplete,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    if (posts.isEmpty) {
      return _buildEmptyState(context);
    }

    // Show max 3 cards in the stack
    final visibleCards = posts.take(3).toList().reversed.toList();

    return Stack(
      children: [
        for (int i = 0; i < visibleCards.length; i++)
          _buildCard(context, visibleCards[i], i, visibleCards.length),
      ],
    );
  }

  Widget _buildCard(
      BuildContext context, Post post, int index, int totalVisible) {
    final isFront = index == totalVisible - 1;
    final stackIndex = totalVisible - 1 - index;

    // Scale and offset for back cards
    final scale = 1.0 - (stackIndex * 0.05);
    final yOffset = stackIndex * 16.0;

    return Positioned.fill(
      child: Transform(
        alignment: Alignment.center,
        transform: Matrix4.identity()
          ..setEntry(1, 3, yOffset)
          ..setEntry(0, 0, scale)
          ..setEntry(1, 1, scale)
          ..setEntry(2, 2, scale),
        child: SwipeCard(
          isFrontCard: isFront,
          onTap: isFront ? () => onTap?.call(post) : null,
          onSwipeComplete: isFront ? onSwipeComplete : null,
          child: PostCardContent(
            post: post,
            showSwipeHint: isFront,
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.surfaceLight,
              border: Border.all(
                color: AppColors.glassBorder,
                width: 1,
              ),
            ),
            child: const Icon(
              Icons.auto_awesome,
              size: 44,
              color: AppColors.accent,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'All caught up!',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            'No more posts to view.\nFollow more people to see their posts.',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.textTertiary,
                  height: 1.5,
                ),
          ),
        ],
      ),
    );
  }
}
