import 'package:flutter/material.dart';

class ModrenStat extends StatelessWidget {
  const ModrenStat({
    super.key,
    required this.icon,
    required this.iconColor,
    required this.bgColor,
    required this.label,
    required this.amount,
  });

  final IconData icon;
  final Color iconColor;
  final Color bgColor;
  final String label;
  final String amount;

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: bgColor,
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: iconColor, size: 18),
        ),
        const SizedBox(width: 12),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  color: isDarkMode ? Colors.grey.shade400 : Colors.grey.shade500,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                amount,
                style: TextStyle(
                  color: isDarkMode ? const Color(0xFFF5F5F7) : const Color(0xFF1A1D1E),
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  fontFamily: 'Roboto',
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        )
      ],
    );
  }
}