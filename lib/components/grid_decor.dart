import 'dart:ui' show ImageFilter;

import 'package:f1/utils/theme.dart';
import 'package:flutter/material.dart';

/// Elementos decorativos del sistema "Grid Dynamic" (ver DESIGN.md):
/// rejilla de telemetría, línea diagonal cinética, punto pulsante
/// "EN VIVO" y panel de cristal (glassmorphism HUD).

/// Rejilla técnica de 16px usada como fondo de visualizaciones
/// ("Telemetry Visuals ... grid-patterned background (16px grid lines)").
class GridBackgroundPainter extends CustomPainter {
  final double spacing;
  final Color color;
  final double alpha;

  const GridBackgroundPainter({
    this.spacing = 16,
    this.color = GridColors.outlineVariant,
    this.alpha = 0.35,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color.withValues(alpha: alpha)
      ..strokeWidth = 1;
    for (double x = 0; x <= size.width; x += spacing) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (double y = 0; y <= size.height; y += spacing) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant GridBackgroundPainter oldDelegate) =>
      oldDelegate.spacing != spacing ||
      oldDelegate.color != color ||
      oldDelegate.alpha != alpha;
}

/// Línea diagonal ascendente: energía cinética ("Kinetic Energy:
/// diagonal lines ... to simulate velocity").
class DiagonalAccent extends StatelessWidget {
  final Color color;
  final double thickness;
  final double width;

  const DiagonalAccent({
    super.key,
    this.color = GridColors.lime,
    this.thickness = 2,
    this.width = 120,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(width, thickness * 2),
      painter: _DiagonalAccentPainter(color, thickness),
    );
  }
}

class _DiagonalAccentPainter extends CustomPainter {
  final Color color;
  final double thickness;

  _DiagonalAccentPainter(this.color, this.thickness);

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawLine(
      Offset(0, size.height),
      Offset(size.width, 0),
      Paint()
        ..color = color
        ..strokeWidth = thickness
        ..strokeCap = StrokeCap.square,
    );
  }

  @override
  bool shouldRepaint(covariant _DiagonalAccentPainter oldDelegate) =>
      oldDelegate.color != color || oldDelegate.thickness != thickness;
}

/// Punto cuadrado pulsante para estados "EN VIVO" (Rosso Corsa,
/// ver DESIGN.md: Race Status Tokens). Esquinas rectas: sin curvas.
class LiveDot extends StatefulWidget {
  final double size;
  final Color color;

  const LiveDot({super.key, this.size = 8, this.color = GridColors.rossoCorsa});

  @override
  State<LiveDot> createState() => _LiveDotState();
}

class _LiveDotState extends State<LiveDot> with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 900),
  )..repeat(reverse: true);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
      child: Container(
        width: widget.size,
        height: widget.size,
        color: widget.color,
      ),
    );
  }
}

/// Panel de cristal HUD: relleno blanco al 10% + blur de 12px
/// ("Top Layer (Overlays): Glassmorphism with a 12px backdrop blur
/// and 10% opacity white fill").
class GlassContainer extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final BoxBorder? border;

  const GlassContainer({
    super.key,
    required this.child,
    this.padding = EdgeInsets.zero,
    this.border,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Container(
          padding: padding,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.10),
            border: border,
          ),
          child: child,
        ),
      ),
    );
  }
}
