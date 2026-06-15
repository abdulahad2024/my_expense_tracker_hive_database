import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';

class CustomToast {


  static void showSuccess(String message) {
    BotToast.showCustomText(
      duration: const Duration(seconds: 3),
      toastBuilder: (cancelFunc) => _buildToastWidget(
        message: message,
        backgroundColor: const Color(0xFFE8F5E9),
        borderColor: Colors.green.shade600,
        icon: Icons.check_circle,
        iconColor: Colors.green.shade600,
        textColor: Colors.green.shade900,
      ),
    );
  }

  static void showError(String message) {
    BotToast.showCustomText(
      duration: const Duration(seconds: 3),
      toastBuilder: (cancelFunc) => _buildToastWidget(
        message: message,
        backgroundColor: const Color(0xFFFFEBEE),
        borderColor: Colors.red.shade600,
        icon: Icons.error_rounded,
        iconColor: Colors.red.shade600,
        textColor: Colors.red.shade900,
      ),
    );
  }

  static Widget _buildToastWidget({
    required String message,
    required Color backgroundColor,
    required Color borderColor,
    required IconData icon,
    required Color iconColor,
    required Color textColor,
  }) {
    return Card(
      elevation: 4,
      shadowColor: Colors.black12,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: borderColor, width: 1),
      ),
      color: backgroundColor,
      margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 50),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: iconColor, size: 24),
            const SizedBox(width: 12),
            Flexible(
              child: Text(
                message,
                style: TextStyle(
                  color: textColor,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}