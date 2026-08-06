import 'dart:math';
import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

class CosmicBackground extends StatefulWidget {
  final Widget child;

  const CosmicBackground({super.key, required this.child});

  @override
  State<CosmicBackground> createState() => _CosmicBackgroundState();
}

class _CosmicBackgroundState extends State<CosmicBackground>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final List<_Star> _stars;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20),
    )..repeat();
    final rng = Random(42);
    _stars = List.generate(60, (_) => _Star.random(rng));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: const BoxDecoration(
            gradient: RadialGradient(
              center: Alignment(0.3, -0.5),
              radius: 1.2,
              colors: [
                Color(0xFF0f0f1e),
                AppColors.background,
              ],
            ),
          ),
        ),
        AnimatedBuilder(
          animation: _controller,
          builder: (context, _) {
            return CustomPaint(
              painter: _StarfieldPainter(_stars, _controller.value),
              size: Size.infinite,
            );
          },
        ),
        widget.child,
      ],
    );
  }
}

class _Star {
  final double x;
  final double y;
  final double size;
  final double phaseOffset;

  const _Star(this.x, this.y, this.size, this.phaseOffset);

  factory _Star.random(Random rng) => _Star(
        rng.nextDouble(),
        rng.nextDouble(),
        rng.nextDouble() * 1.5 + 0.3,
        rng.nextDouble() * 2 * pi,
      );
}

class _StarfieldPainter extends CustomPainter {
  final List<_Star> stars;
  final double t;

  _StarfieldPainter(this.stars, this.t);

  @override
  void paint(Canvas canvas, Size size) {
    for (final star in stars) {
      final opacity = (sin(t * 2 * pi + star.phaseOffset) * 0.3 + 0.5)
          .clamp(0.1, 0.8);
      final paint = Paint()
        ..color = Colors.white.withValues(alpha: opacity)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 0.5);
      canvas.drawCircle(
        Offset(star.x * size.width, star.y * size.height),
        star.size,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(_StarfieldPainter old) => true;
}
