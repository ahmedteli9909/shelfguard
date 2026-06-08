import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

class CupertinoDropdownField<T> extends StatefulWidget {
  final String label;
  final String hintText;
  final T? value;
  final List<T> items;
  final String Function(T) itemToString;
  final ValueChanged<T> onChanged;

  const CupertinoDropdownField({
    super.key,
    required this.label,
    required this.hintText,
    required this.value,
    required this.items,
    required this.itemToString,
    required this.onChanged,
  });

  @override
  State<CupertinoDropdownField<T>> createState() =>
      _CupertinoDropdownFieldState<T>();
}

class _CupertinoDropdownFieldState<T> extends State<CupertinoDropdownField<T>> {
  final LayerLink _layerLink = LayerLink();
  final GlobalKey<_DropdownOverlayContentState> _overlayContentKey =
      GlobalKey<_DropdownOverlayContentState>();
  OverlayEntry? _overlayEntry;
  bool _isOpen = false;

  void _toggleDropdown() {
    if (_isOpen) {
      _closeDropdown();
    } else {
      _openDropdown();
    }
  }

  void _openDropdown() {
    setState(() {
      _isOpen = true;
    });
    _overlayEntry = _createOverlayEntry();
    Overlay.of(context).insert(_overlayEntry!);
  }

  void _closeDropdown() {
    if (!_isOpen || !mounted) return;
    setState(() {
      _isOpen = false;
    });

    if (_overlayContentKey.currentState != null) {
      _overlayContentKey.currentState!.animateOut(() {
        _overlayEntry?.remove();
        _overlayEntry = null;
      });
    } else {
      _overlayEntry?.remove();
      _overlayEntry = null;
    }
  }

  OverlayEntry _createOverlayEntry() {
    RenderBox renderBox = context.findRenderObject() as RenderBox;
    Size size = renderBox.size;
    final position = renderBox.localToGlobal(Offset.zero);
    final screenHeight = MediaQuery.of(context).size.height;
    final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;

    // Fixed item height in list overlay
    const double itemHeight = 40.0;
    final double menuHeight = (widget.items.length * itemHeight).clamp(
      40.0,
      200.0,
    );

    // Calculate space below the dropdown (safety pad of 75px for bottom buttons/margins)
    final double spaceBelow =
        screenHeight - position.dy - size.height - keyboardHeight - 75;
    final bool showAbove = spaceBelow < menuHeight;

    // Use Flutter anchors instead of size calculation to position menu exactly touching the border
    final targetAnchor = showAbove ? Alignment.topLeft : Alignment.bottomLeft;
    final followerAnchor = showAbove ? Alignment.bottomLeft : Alignment.topLeft;
    final offset = showAbove ? const Offset(0, -2) : const Offset(0, 2);
    final animationAlignment = showAbove
        ? Alignment.bottomCenter
        : Alignment.topCenter;

    return OverlayEntry(
      builder: (context) => Stack(
        children: [
          // Transparent detector barrier to close menu on click outside
          Positioned.fill(
            child: GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: _closeDropdown,
            ),
          ),
          CompositedTransformFollower(
            link: _layerLink,
            showWhenUnlinked: false,
            targetAnchor: targetAnchor,
            followerAnchor: followerAnchor,
            offset: offset,
            child: Material(
              color: Colors.transparent,
              child: _DropdownOverlayContent(
                key: _overlayContentKey,
                alignment: animationAlignment,
                child: Container(
                  width: size.width,
                  constraints: BoxConstraints(maxHeight: menuHeight),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: AppColors.borderLight,
                      width: 1.0,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.06),
                        offset: const Offset(0, 4),
                        blurRadius: 16,
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: ListView.builder(
                      padding: EdgeInsets.zero,
                      shrinkWrap: true,
                      itemCount: widget.items.length,
                      itemBuilder: (context, index) {
                        final item = widget.items[index];
                        final isSelected = widget.value == item;

                        return _DropdownItemTile(
                          text: widget.itemToString(item),
                          isSelected: isSelected,
                          onTap: () {
                            widget.onChanged(item);
                            _closeDropdown();
                          },
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _closeDropdown();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: const TextStyle(
            fontFamily: 'Mulish',
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: AppColors.darkText, // Audited Neutral/200 label color
            height: 1.5, // 18px line height / 12px size
          ),
        ),
        const SizedBox(height: 4), // Audited 4px vertical gap
        CompositedTransformTarget(
          link: _layerLink,
          child: GestureDetector(
            onTap: _toggleDropdown,
            child: Container(
              height: 46, // Audited 46px height
              padding: const EdgeInsets.symmetric(
                horizontal: 12,
              ), // Audited 12px horizontal padding
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: _isOpen
                      ? AppColors.primary
                      : AppColors.borderLightFigma, // Audited border colors
                  width: _isOpen ? 1.2 : 1.0,
                ),
                boxShadow: const [
                  BoxShadow(
                    color: AppColors
                        .cardShadowColor, // Audited 5% opacity card shadow
                    offset: Offset(0, 1),
                    blurRadius: 2,
                    spreadRadius: 0,
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      widget.value != null
                          ? widget.itemToString(widget.value as T)
                          : widget.hintText,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontFamily: 'Mulish',
                        fontSize: 14,
                        color: widget.value != null
                            ? AppColors
                                  .darkText // Active Neutral/200
                            : AppColors
                                  .textHint, // Hint Neutral/200 with 65% opacity
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Icon(
                    Icons.keyboard_arrow_down_rounded,
                    color: _isOpen ? AppColors.primary : AppColors.textHint,
                    size: 18,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _DropdownItemTile extends StatefulWidget {
  final String text;
  final bool isSelected;
  final VoidCallback onTap;

  const _DropdownItemTile({
    required this.text,
    required this.isSelected,
    required this.onTap,
  });

  @override
  State<_DropdownItemTile> createState() => _DropdownItemTileState();
}

class _DropdownItemTileState extends State<_DropdownItemTile> {
  bool _isHighlighted = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _isHighlighted = true),
      onTapUp: (_) => setState(() => _isHighlighted = false),
      onTapCancel: () => setState(() => _isHighlighted = false),
      onTap: widget.onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        height: 40, // Match list height estimate
        color: widget.isSelected
            ? AppColors.primary.withValues(alpha: 0.05)
            : (_isHighlighted ? const Color(0xFFF1F3F6) : Colors.transparent),
        alignment: Alignment.centerLeft,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                widget.text,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontFamily: 'Mulish',
                  fontSize: 13.5,
                  color: widget.isSelected
                      ? AppColors.primary
                      : AppColors.textPrimary,
                  fontWeight: widget.isSelected
                      ? FontWeight.w700
                      : FontWeight.w500,
                ),
              ),
            ),
            if (widget.isSelected)
              const Icon(
                Icons.check_rounded,
                color: AppColors.primary,
                size: 16,
              ),
          ],
        ),
      ),
    );
  }
}

class _DropdownOverlayContent extends StatefulWidget {
  final Widget child;
  final Alignment alignment;

  const _DropdownOverlayContent({
    super.key,
    required this.child,
    required this.alignment,
  });

  @override
  State<_DropdownOverlayContent> createState() =>
      _DropdownOverlayContentState();
}

class _DropdownOverlayContentState extends State<_DropdownOverlayContent>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 180),
    );
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
    _scaleAnimation = Tween<double>(
      begin: 0.96,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void animateOut(VoidCallback onFinished) {
    _controller.reverse().then((_) => onFinished());
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: ScaleTransition(
        scale: _scaleAnimation,
        alignment: widget.alignment,
        child: widget.child,
      ),
    );
  }
}
