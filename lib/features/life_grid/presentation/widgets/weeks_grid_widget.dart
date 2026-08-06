import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';

class WeeksGridWidget extends StatelessWidget {
  final int totalWeeks;
  final int weeksLived;

  const WeeksGridWidget({
    super.key,
    required this.totalWeeks,
    required this.weeksLived,
  });

  @override
  Widget build(BuildContext context) {
    // Показываем сетку по годам (52 недели в строке)
    final totalYears = (totalWeeks / 52).ceil();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('КАЖДАЯ КЛЕТКА — ОДНА НЕДЕЛЯ', style: AppTypography.labelLarge),
            Row(
              children: [
                Container(
                  width: 8, height: 8,
                  decoration: BoxDecoration(
                    color: AppColors.accentPurple,
                    borderRadius: BorderRadius.circular(1),
                  ),
                ),
                const SizedBox(width: 4),
                Text('Прожито', style: AppTypography.labelSmall),
                const SizedBox(width: 8),
                Container(
                  width: 8, height: 8,
                  decoration: BoxDecoration(
                    color: AppColors.borderSubtle,
                    borderRadius: BorderRadius.circular(1),
                  ),
                ),
                const SizedBox(width: 4),
                Text('Осталось', style: AppTypography.labelSmall),
              ],
            ),
          ],
        ),
        const SizedBox(height: 12),
        LayoutBuilder(
          builder: (context, constraints) {
            final cellSize = (constraints.maxWidth - 51 * 1.0) / 52;
            final size = cellSize.clamp(2.0, 6.0);
            final gap = size < 4 ? 0.5 : 1.0;

            return SizedBox(
              height: totalYears * (size + gap),
              child: CustomPaint(
                painter: _WeeksGridPainter(
                  totalWeeks: totalWeeks,
                  weeksLived: weeksLived,
                  cellSize: size,
                  gap: gap,
                ),
                size: Size(constraints.maxWidth, totalYears * (size + gap)),
              ),
            );
          },
        ),
      ],
    );
  }
}

class _WeeksGridPainter extends CustomPainter {
  final int totalWeeks;
  final int weeksLived;
  final double cellSize;
  final double gap;

  _WeeksGridPainter({
    required this.totalWeeks,
    required this.weeksLived,
    required this.cellSize,
    required this.gap,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final livedPaint = Paint()..color = AppColors.accentPurple;
    final remainingPaint = Paint()..color = AppColors.borderSubtle;

    for (int i = 0; i < totalWeeks; i++) {
      final col = i % 52;
      final row = i ~/ 52;
      final rect = RRect.fromRectAndRadius(
        Rect.fromLTWH(
          col * (cellSize + gap),
          row * (cellSize + gap),
          cellSize,
          cellSize,
        ),
        Radius.circular(cellSize * 0.2),
      );
      canvas.drawRRect(rect, i < weeksLived ? livedPaint : remainingPaint);
    }
  }

  @override
  bool shouldRepaint(_WeeksGridPainter old) =>
      old.weeksLived != weeksLived || old.totalWeeks != totalWeeks;
}
