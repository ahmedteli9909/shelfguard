import 'package:flutter/material.dart';

class CupertinoPressable extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;
  final double pressScale;
  final double pressOpacity;
  final HitTestBehavior behavior;

  const CupertinoPressable({
    super.key,
    required this.child,
    required this.onTap,
    this.pressScale = 0.97,
    this.pressOpacity = 0.8,
    this.behavior = HitTestBehavior.deferToChild,
  });

  @override
  State<CupertinoPressable> createState() => _CupertinoPressableState();
}

class _CupertinoPressableState extends State<CupertinoPressable>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
      reverseDuration: const Duration(milliseconds: 100),
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: widget.pressScale,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));
    _opacityAnimation = Tween<double>(
      begin: 1.0,
      end: widget.pressOpacity,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool isEnabled = widget.onTap != null;

    return GestureDetector(
      behavior: widget.behavior,
      onTapDown: isEnabled ? (_) => _controller.forward() : null,
      onTapUp: isEnabled ? (_) => _controller.reverse() : null,
      onTapCancel: isEnabled ? () => _controller.reverse() : null,
      onTap: widget.onTap,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Opacity(opacity: _opacityAnimation.value, child: child),
          );
        },
        child: widget.child,
      ),
    );
  }
}
