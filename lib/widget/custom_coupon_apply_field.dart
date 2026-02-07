import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/app_color.dart';
import '../../core/app_textstyle.dart';
import 'form_widgets/app_textfield.dart';

class CustomCouponApplyField extends StatefulWidget {
  final TextEditingController controller;
  final String label;
  final String hintText;
  final VoidCallback onApply;
  final bool isLoading;
  final bool isApplied;

  const CustomCouponApplyField({
    super.key,
    required this.controller,
    required this.onApply,
    this.label = "Coupon Code",
    this.hintText = "Enter coupon code",
    this.isLoading = false,
    this.isApplied = false,
  });

  @override
  State<CustomCouponApplyField> createState() =>
      _CustomCouponApplyFieldState();
}

class _CustomCouponApplyFieldState extends State<CustomCouponApplyField> {
  bool _showApply = false;

  @override
  void initState() {
    super.initState();
    _showApply = widget.controller.text.trim().isNotEmpty;
  }

  @override
  void didUpdateWidget(covariant CustomCouponApplyField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.controller.text.trim().isNotEmpty != _showApply) {
      _showApply = widget.controller.text.trim().isNotEmpty;
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomTextfield(
      label: widget.label,
      hintText: widget.hintText,
      controller: widget.controller,
      onChanged: (value) {
        final shouldShow = value.trim().isNotEmpty;
        if (shouldShow != _showApply) {
          setState(() => _showApply = shouldShow);
        }
      },
      suffixIcon: _showApply
          ? Padding(
        padding: const EdgeInsets.only(right: 6),
        child: widget.isApplied
            ? Icon(Icons.check_circle, color: Colors.green)
            : TextButton(
          onPressed: widget.isLoading ? null : widget.onApply,
          child: widget.isLoading
              ? const SizedBox(
            height: 18,
            width: 18,
            child: CircularProgressIndicator(strokeWidth: 2),
          )
              : Text(
            "APPLY",
            style: AppTextStyle.title(
              color: AppColors.appColor,
            ),
          ),
        ),
      )
          : null,
    );
  }
}
