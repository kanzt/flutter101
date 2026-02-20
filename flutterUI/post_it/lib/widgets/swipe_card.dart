import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

enum SwipeDirection { left, right, down }

class SwipeCard extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;
  final ValueChanged<SwipeDirection>? onSwipeComplete;
  final bool isFrontCard;

  const SwipeCard({
    super.key,
    required this.child,
    this.onTap,
    this.onSwipeComplete,
    this.isFrontCard = true,
  });

  @override
  State<SwipeCard> createState() => _SwipeCardState();
}

class _SwipeCardState extends State<SwipeCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  Offset _dragOffset = Offset.zero;
  bool _isDragging = false;
  bool _isFlying = false;

  static const double _swipeThreshold = 100.0;
  static const double _maxRotation = 0.4; // radians

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  double get _rotationAngle {
    if (!_isDragging && !_isFlying) return 0;
    final screenW = MediaQuery.of(context).size.width;
    return (_dragOffset.dx / screenW) * _maxRotation;
  }

  double get _swipeProgress {
    return (_dragOffset.dx.abs() / _swipeThreshold).clamp(0.0, 1.0);
  }

  void _onPanStart(DragStartDetails details) {
    if (_isFlying) return;
    setState(() => _isDragging = true);
  }

  void _onPanUpdate(DragUpdateDetails details) {
    if (_isFlying) return;
    setState(() {
      _dragOffset += details.delta;
    });
  }

  void _onPanEnd(DragEndDetails details) {
    if (_isFlying) return;

    final velocity = details.velocity.pixelsPerSecond;
    final isSwipeRight =
        _dragOffset.dx > _swipeThreshold || velocity.dx > 800;
    final isSwipeLeft =
        _dragOffset.dx < -_swipeThreshold || velocity.dx < -800;
    final isSwipeDown =
        _dragOffset.dy > _swipeThreshold || velocity.dy > 800;

    if (isSwipeRight) {
      _flyOff(SwipeDirection.right);
    } else if (isSwipeLeft) {
      _flyOff(SwipeDirection.left);
    } else if (isSwipeDown) {
      _flyOff(SwipeDirection.down);
    } else {
      _snapBack();
    }
  }

  void _flyOff(SwipeDirection direction) {
    HapticFeedback.mediumImpact();
    _isFlying = true;

    final screenSize = MediaQuery.of(context).size;
    late Offset targetOffset;

    switch (direction) {
      case SwipeDirection.right:
        targetOffset = Offset(screenSize.width * 1.5, _dragOffset.dy);
        break;
      case SwipeDirection.left:
        targetOffset = Offset(-screenSize.width * 1.5, _dragOffset.dy);
        break;
      case SwipeDirection.down:
        targetOffset = Offset(_dragOffset.dx, screenSize.height * 1.5);
        break;
    }

    final startOffset = _dragOffset;
    final animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeIn,
    );

    animation.addListener(() {
      setState(() {
        _dragOffset = Offset.lerp(startOffset, targetOffset, animation.value)!;
      });
    });

    _controller.forward(from: 0).then((_) {
      widget.onSwipeComplete?.call(direction);
    });
  }

  void _snapBack() {
    _isDragging = false;
    final startOffset = _dragOffset;
    final animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.elasticOut,
    );

    animation.addListener(() {
      setState(() {
        _dragOffset =
            Offset.lerp(startOffset, Offset.zero, animation.value)!;
      });
    });

    _controller.forward(from: 0).then((_) {
      setState(() {
        _dragOffset = Offset.zero;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.isFrontCard) {
      return widget.child;
    }

    return GestureDetector(
      onTap: widget.onTap,
      onPanStart: _onPanStart,
      onPanUpdate: _onPanUpdate,
      onPanEnd: _onPanEnd,
      child: Transform.translate(
        offset: _dragOffset,
        child: Transform.rotate(
          angle: _rotationAngle,
          child: Stack(
            children: [
              widget.child,
              // Swipe direction indicators
              if (_isDragging && _dragOffset.dx > 20)
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(
                        color: Colors.greenAccent
                            .withValues(alpha: _swipeProgress * 0.8),
                        width: 3,
                      ),
                    ),
                    child: Center(
                      child: Opacity(
                        opacity: _swipeProgress,
                        child: Transform.rotate(
                          angle: -0.3,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10),
                            decoration: BoxDecoration(
                              border: Border.all(
                                  color: Colors.greenAccent, width: 3),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Text(
                              'VIEWED',
                              style: TextStyle(
                                color: Colors.greenAccent,
                                fontSize: 32,
                                fontWeight: FontWeight.w900,
                                letterSpacing: 4,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              if (_isDragging && _dragOffset.dx < -20)
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(
                        color: Colors.redAccent
                            .withValues(alpha: _swipeProgress * 0.8),
                        width: 3,
                      ),
                    ),
                    child: Center(
                      child: Opacity(
                        opacity: _swipeProgress,
                        child: Transform.rotate(
                          angle: 0.3,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10),
                            decoration: BoxDecoration(
                              border:
                                  Border.all(color: Colors.redAccent, width: 3),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Text(
                              'SKIP',
                              style: TextStyle(
                                color: Colors.redAccent,
                                fontSize: 32,
                                fontWeight: FontWeight.w900,
                                letterSpacing: 4,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
