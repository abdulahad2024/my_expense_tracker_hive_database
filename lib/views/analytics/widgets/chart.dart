import 'package:flutter/material.dart';

import '../../../core/themes/color.dart';

class IncomeExpenseChartPainter extends CustomPainter {
  final double incomePercentage;
  final double expensePercentage;

  IncomeExpenseChartPainter({
    required this.incomePercentage,
    required this.expensePercentage,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;
    final rect = Rect.fromCircle(center: center, radius: radius);

    final paintIncome = Paint()
      ..color = primaryColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 20;

    final paintExpense = Paint()
      ..color = Colors.red.shade600
      ..style = PaintingStyle.stroke
      ..strokeWidth = 20;

    double startAngle = -1.5708;

    double sweepAngleIncome = (incomePercentage / 100) * 6.28319;
    canvas.drawArc(rect, startAngle, sweepAngleIncome, false, paintIncome);

    startAngle += sweepAngleIncome;
    double sweepAngleExpense = (expensePercentage / 100) * 6.28319;
    canvas.drawArc(rect, startAngle, sweepAngleExpense, false, paintExpense);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
