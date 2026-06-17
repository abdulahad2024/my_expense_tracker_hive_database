import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String title;
  final VoidCallback onTap;
  final Color? backgroundColor;
  final Color textColor;
  final bool isLoading;
  final IconData? icon;
  final double borderRadius;

  const CustomButton({
    super.key,
    required this.title,
    required this.onTap,
    this.backgroundColor,
    this.textColor = Colors.white,
    this.isLoading = false,
    this.icon,
    this.borderRadius = 16.0, // টেক্সট ফিল্ডের সাথে মিল রেখে ১৬ কর্নার রাউন্ডেড
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    // যদি কাস্টম কালার না দেওয়া হয়, তবে অ্যাপের প্রাইমারি কালার (গ্রিন) নিবে
    final effectiveBackgroundColor = backgroundColor ?? theme.colorScheme.primary;

    return Container(
      width: double.infinity, // বাটনটি যেন ফুল উইথ (Width) পায়
      height: 56,            // স্ট্যান্ডার্ড এবং প্রিমিয়াম টাচ হাইট
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: [
          BoxShadow(
            color: effectiveBackgroundColor.withOpacity(0.25),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Material(
        color: effectiveBackgroundColor,
        borderRadius: BorderRadius.circular(borderRadius),
        child: InkWell(
          borderRadius: BorderRadius.circular(borderRadius),
          onTap: isLoading ? null : onTap, // লোড হওয়ার সময় ক্লিক অফ থাকবে
          child: Center(
            child: isLoading
                ? const SizedBox(
              height: 24,
              width: 24,
              child: CircularProgressIndicator(
                color: Colors.white,
                strokeWidth: 2.5,
              ),
            )
                : Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (icon != null) ...[
                  Icon(icon, color: textColor, size: 22),
                  const SizedBox(width: 8),
                ],
                Text(
                  title,
                  style: TextStyle(
                    color: textColor,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}