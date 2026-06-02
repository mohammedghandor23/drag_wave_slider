import 'dart:math';
import 'package:flutter/material.dart';

/// A customizable drag slider with wave animation effect.
/// 
/// This widget provides a slide-to-action interface with an animated wave trail
/// that follows the slider thumb. It supports both LTR and RTL directions.
class DragWaveSlider extends StatefulWidget {
  /// The text displayed in the slider when not dragging.
  final String text;
  
  /// The color of the slider thumb and wave animation.
  final Color sliderColor;
  
  /// The background color of the slider track.
  final Color backgroundColor;
  
  /// The color of the text.
  final Color textColor;
  
  /// The height of the slider.
  final double height;
  
  /// The amplitude of the wave animation.
  final double waveAmplitude;
  
  /// The duration of the wave animation cycle.
  final Duration waveDuration;
  
  /// The threshold (0.0 to 1.0) at which the onSlideComplete callback is triggered.
  final double slideThreshold;
  
  /// Callback when the slider is dragged to completion.
  final VoidCallback onSlideComplete;
  
  /// Optional icon to display in the slider thumb.
  final IconData? thumbIcon;
  
  /// Optional icon color for the thumb icon.
  final Color? thumbIconColor;

  const DragWaveSlider({
    super.key,
    required this.text,
    required this.onSlideComplete,
    this.sliderColor = Colors.blue,
    this.backgroundColor = Colors.grey,
    this.textColor = Colors.white,
    this.height = 60,
    this.waveAmplitude = 3.0,
    this.waveDuration = const Duration(milliseconds: 1500),
    this.slideThreshold = 0.9,
    this.thumbIcon,
    this.thumbIconColor,
  });

  @override
  State<DragWaveSlider> createState() => _DragWaveSliderState();
}

class _DragWaveSliderState extends State<DragWaveSlider>
    with TickerProviderStateMixin {
  double _sliderValue = 0;
  late AnimationController _waveController;

  @override
  void initState() {
    super.initState();
    _waveController = AnimationController(
      vsync: this,
      duration: widget.waveDuration,
    )..repeat();
  }

  @override
  void dispose() {
    _waveController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isRtl = Directionality.of(context) == TextDirection.rtl;
    
    return Container(
      height: widget.height,
      padding: EdgeInsets.all(widget.height * 0.1),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(widget.height / 2),
        color: widget.backgroundColor.withOpacity(0.15),
        border: Border.all(
          color: widget.sliderColor.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final thumbSize = constraints.maxHeight;
          final maxSlide = constraints.maxWidth - thumbSize;
          
          return Stack(
            clipBehavior: Clip.none,
            alignment: isRtl ? Alignment.centerRight : Alignment.centerLeft,
            children: [
              if (_sliderValue > 0)
                AnimatedBuilder(
                  animation: _waveController,
                  builder: (context, child) {
                    final trailWidth = _sliderValue * maxSlide + thumbSize / 2;
                    return ClipPath(
                      clipper: _WaveClipper(
                        animValue: _waveController.value,
                        waveAmp: widget.waveAmplitude,
                        isRtl: isRtl,
                      ),
                      child: Container(
                        width: trailWidth,
                        height: thumbSize,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment(-5.0 + 2.0 * _waveController.value, 0),
                            end: Alignment(1.0 + 2.0 * _waveController.value, 0),
                            colors: [
                              widget.sliderColor.withOpacity(0.1),
                              widget.sliderColor.withOpacity(0.35),
                              widget.sliderColor.withOpacity(0.15),
                              widget.sliderColor.withOpacity(0.4),
                              widget.sliderColor.withOpacity(0.1),
                            ],
                            stops: const [0.0, 0.25, 0.5, 0.75, 1.0],
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: widget.sliderColor.withOpacity(0.2),
                              blurRadius: 10,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              Center(
                child: Text(
                  widget.text,
                  style: TextStyle(
                    color: widget.textColor.withOpacity(0.7),
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 2,
                  ),
                ),
              ),
              AnimatedPositioned(
                duration: Duration.zero,
                left: isRtl ? null : _sliderValue * maxSlide,
                right: isRtl ? _sliderValue * maxSlide : null,
                child: GestureDetector(
                  onHorizontalDragUpdate: (details) {
                    setState(() {
                      if (isRtl) {
                        _sliderValue -= details.delta.dx / maxSlide;
                      } else {
                        _sliderValue += details.delta.dx / maxSlide;
                      }
                      _sliderValue = _sliderValue.clamp(0.0, 1.0);
                    });
                    if (_sliderValue >= widget.slideThreshold) {
                      widget.onSlideComplete();
                    }
                  },
                  onHorizontalDragEnd: (details) {
                    if (_sliderValue < widget.slideThreshold) {
                      setState(() {
                        _sliderValue = 0;
                      });
                    }
                  },
                  child: Container(
                    width: thumbSize,
                    height: thumbSize,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: widget.sliderColor,
                      boxShadow: [
                        BoxShadow(
                          color: widget.sliderColor.withOpacity(0.4),
                          blurRadius: 12,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: widget.thumbIcon != null
                        ? Icon(
                            widget.thumbIcon,
                            color: widget.thumbIconColor ?? Colors.white,
                            size: thumbSize * 0.4,
                          )
                        : Icon(
                            isRtl ? Icons.arrow_back : Icons.arrow_forward,
                            color: widget.thumbIconColor ?? Colors.white,
                            size: thumbSize * 0.4,
                          ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _WaveClipper extends CustomClipper<Path> {
  final double animValue;
  final double waveAmp;
  final bool isRtl;

  _WaveClipper({required this.animValue, this.waveAmp = 4.0, this.isRtl = false});

  @override
  Path getClip(Size size) {
    final path = Path();
    final waveLength = size.width * 0.3;
    final phase = animValue * 2 * pi;
    final r = size.height / 2;

    if (isRtl) {
      // RTL: Start from right, draw towards left
      path.moveTo(size.width, r);
      path.arcToPoint(
        Offset(size.width - r, 0),
        radius: Radius.circular(r),
        clockwise: true,
      );

      for (double x = size.width - r; x >= 0; x--) {
        final ramp = ((size.width - r - x) / (size.width - r)).clamp(0.0, 1.0);
        final amp = waveAmp * ramp;
        final y = amp * sin(((size.width - x) / waveLength) * 2 * pi + phase) + amp;
        path.lineTo(x, y);
      }

      for (double x = 0; x <= size.width - r; x++) {
        final ramp = ((size.width - r - x) / (size.width - r)).clamp(0.0, 1.0);
        final amp = waveAmp * ramp;
        final y = size.height - amp * sin(((size.width - x) / waveLength) * 2 * pi + phase + pi) - amp;
        path.lineTo(x, y);
      }

      path.arcToPoint(
        Offset(size.width, r),
        radius: Radius.circular(r),
        clockwise: true,
      );
    } else {
      // LTR: Start from left, draw towards right
      path.moveTo(0, r);
      path.arcToPoint(
        Offset(r, 0),
        radius: Radius.circular(r),
        clockwise: false,
      );

      for (double x = r; x <= size.width; x++) {
        final ramp = ((x - r) / (size.width - r)).clamp(0.0, 1.0);
        final amp = waveAmp * ramp;
        final y = amp * sin((x / waveLength) * 2 * pi + phase) + amp;
        path.lineTo(x, y);
      }

      for (double x = size.width; x >= r; x--) {
        final ramp = ((x - r) / (size.width - r)).clamp(0.0, 1.0);
        final amp = waveAmp * ramp;
        final y = size.height - amp * sin((x / waveLength) * 2 * pi + phase + pi) - amp;
        path.lineTo(x, y);
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
  bool shouldReclip(covariant _WaveClipper oldClipper) {
    return oldClipper.animValue != animValue;
  }
}
