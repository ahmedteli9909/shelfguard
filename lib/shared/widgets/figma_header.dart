import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import 'figma_back_button.dart';

class FigmaHeader extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final Widget? titleWidget;
  final VoidCallback? onBackPressed;
  final List<Widget>? actions;

  const FigmaHeader({
    super.key,
    this.title,
    this.titleWidget,
    this.onBackPressed,
    this.actions,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: preferredSize.height,
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // 1. Back button if callback provided
          if (onBackPressed != null) ...[
            FigmaBackButton(onPressed: onBackPressed!),
            const SizedBox(width: 12), // Item spacing: 12px from Figma
          ],

          // 2. Title text or custom title widget
          Expanded(
            child:
                titleWidget ??
                (title != null
                    ? Text(
                        title!,
                        style: const TextStyle(
                          fontFamily: 'Mulish',
                          fontSize: 18,
                          fontWeight: FontWeight.w700, // Bold
                          color: AppColors.darkText, // Charcoal/black (#0E100F)
                          height: 1.33, // 24px line-height for 18px size
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      )
                    : const SizedBox.shrink()),
          ),

          // 3. Right-side actions (if any)
          if (actions != null) ...actions!,
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(52.0); // Frame height: 52px
}
