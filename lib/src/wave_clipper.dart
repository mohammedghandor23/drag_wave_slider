import 'dart:math';
import 'package:flutter/material.dart';

class WaveClipper extends CustomClipper<Path> {
  final double animValue;
  final double waveAmp;
  final bool isRtl;

  WaveClipper({
    required this.animValue,
    this.waveAmp = 4.0,
    this.isRtl = false,
  });

  @override
  Path getClip(Size size) {
    final path = Path();
    final waveLength = size.width * 0.4;
    final phase = animValue * 2 * pi;
    final r = size.height / 2;

    if (isRtl) {
      path.moveTo(size.width, r);
      path.arcToPoint(
        Offset(size.width - r, 0),
        radius: Radius.circular(r),
        clockwise: true,
      );

      double x = size.width - r;
      while (x >= 0) {
        final next = (x - 20).clamp(0.0, size.width - r);
        final ramp = ((size.width - r - x) / (size.width - r)).clamp(0.0, 1.0);
        final nextRamp = ((size.width - r - next) / (size.width - r)).clamp(0.0, 1.0);
        final amp = waveAmp * ramp;
        final nextAmp = waveAmp * nextRamp;
        final cx = (x + next) / 2;
        final cy = nextAmp *
            sin(((size.width - cx) / waveLength) * 2 * pi + phase) +
            nextAmp;
        path.quadraticBezierTo(cx, cy, next,
            amp * sin(((size.width - next) / waveLength) * 2 * pi + phase) + amp);
        if (next == 0) break;
        x = next;
      }

      x = 0;
      while (x <= size.width - r) {
        final next = (x + 20).clamp(0.0, size.width - r);
        final ramp = ((size.width - r - x) / (size.width - r)).clamp(0.0, 1.0);
        final nextRamp = ((size.width - r - next) / (size.width - r)).clamp(0.0, 1.0);
        final amp = waveAmp * ramp;
        final nextAmp = waveAmp * nextRamp;
        final cx = (x + next) / 2;
        final cy = size.height -
            nextAmp *
                sin(((size.width - cx) / waveLength) * 2 * pi + phase + pi) -
            nextAmp;
        path.quadraticBezierTo(cx, cy, next,
            size.height -
                amp *
                    sin(((size.width - next) / waveLength) * 2 * pi +
                        phase +
                        pi) -
                amp);
        if (next >= size.width - r) break;
        x = next;
      }

      path.arcToPoint(
        Offset(size.width, r),
        radius: Radius.circular(r),
        clockwise: true,
      );
    } else {
      path.moveTo(0, r);
      path.arcToPoint(
        Offset(r, 0),
        radius: Radius.circular(r),
        clockwise: false,
      );

      double x = r;
      while (x <= size.width) {
        final next = (x + 20).clamp(r, size.width);
        final nextRamp = ((next - r) / (size.width - r)).clamp(0.0, 1.0);
        final nextAmp = waveAmp * nextRamp;
        final cx = (x + next) / 2;
        final cy =
            nextAmp * sin((cx / waveLength) * 2 * pi + phase) + nextAmp;
        path.quadraticBezierTo(cx, cy, next,
            nextAmp * sin((next / waveLength) * 2 * pi + phase) + nextAmp);
        if (next >= size.width) break;
        x = next;
      }

      x = size.width;
      while (x >= r) {
        final next = (x - 20).clamp(r, size.width);
        final nextRamp = ((next - r) / (size.width - r)).clamp(0.0, 1.0);
        final nextAmp = waveAmp * nextRamp;
        final cx = (x + next) / 2;
        final cy = size.height -
            nextAmp * sin((cx / waveLength) * 2 * pi + phase + pi) -
            nextAmp;
        path.quadraticBezierTo(cx, cy, next,
            size.height -
                nextAmp *
                    sin((next / waveLength) * 2 * pi + phase + pi) -
                nextAmp);
        if (next <= r) break;
        x = next;
      }

      path.arcToPoint(
        Offset(0, r),
        radius: Radius.circular(r),
        clockwise: false,
      );
    }

    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant WaveClipper oldClipper) {
    return oldClipper.animValue != animValue ||
        oldClipper.waveAmp != waveAmp ||
        oldClipper.isRtl != isRtl;
  }
}
