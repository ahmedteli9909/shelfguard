import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/theme/app_colors.dart';

class OtpInputRow extends StatefulWidget {
  final ValueChanged<String>? onChanged;

  const OtpInputRow({super.key, this.onChanged});

  @override
  State<OtpInputRow> createState() => OtpInputRowState();
}

class OtpInputRowState extends State<OtpInputRow> {
  static const int _otpLength = 6;
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  void clear() {
    _controller.clear();
    if (mounted) {
      _focusNode.requestFocus();
    }
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    // Auto-focus the field on startup
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _focusNode.requestFocus();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  Widget _buildOtpField(int index) {
    final code = _controller.text;
    final isFocused = _focusNode.hasFocus && code.length == index;
    // Handle focus on the last box if completely filled
    final isLastBoxActive =
        _focusNode.hasFocus &&
        code.length == _otpLength &&
        index == _otpLength - 1;

    final hasValue = code.length > index;
    final char = hasValue ? code[index] : "";

    return Container(
      width: 48,
      height: 56,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: isFocused ? Colors.white : const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: (isFocused || isLastBoxActive)
              ? AppColors.primary
              : (hasValue
                    ? AppColors.primary.withValues(alpha: 0.3)
                    : const Color(0xFFE2E8F0)),
          width: (isFocused || isLastBoxActive) ? 1.5 : 1.2,
        ),
        boxShadow: (isFocused || isLastBoxActive)
            ? [
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: 0.08),
                  offset: const Offset(0, 4),
                  blurRadius: 8,
                ),
              ]
            : [],
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          if (hasValue)
            Center(
              child: Text(
                char,
                style: const TextStyle(
                  fontFamily: 'Mulish',
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                  height:
                      1.0, // Force text baseline perfectly in vertical center
                ),
              ),
            )
          else if (isFocused)
            const Center(child: _BlinkingCursor()),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _focusNode.requestFocus();
      },
      behavior: HitTestBehavior.opaque,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Row of visually perfect center-aligned boxes
          Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(_otpLength, (index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    child: _buildOtpField(index),
                  );
                }),
              )
              .animate()
              .fadeIn(duration: 400.ms, delay: 150.ms)
              .slideY(begin: 0.1, end: 0),

          // Completely hidden text field overlaid on top to capture input
          Positioned.fill(
            child: Opacity(
              opacity: 0.0,
              child: TextField(
                controller: _controller,
                focusNode: _focusNode,
                keyboardType: TextInputType.number,
                maxLength: _otpLength,
                showCursor: false,
                enableInteractiveSelection: false, // Prevent copy/paste handles
                autocorrect: false,
                enableSuggestions: false,
                decoration: const InputDecoration(
                  counterText: '',
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  contentPadding: EdgeInsets.zero,
                ),
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                onChanged: (value) {
                  widget.onChanged?.call(value);
                  setState(() {});
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _BlinkingCursor extends StatefulWidget {
  const _BlinkingCursor();

  @override
  State<_BlinkingCursor> createState() => _BlinkingCursorState();
}

class _BlinkingCursorState extends State<_BlinkingCursor>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _controller,
      child: Container(width: 1.5, height: 18, color: AppColors.primary),
    );
  }
}
