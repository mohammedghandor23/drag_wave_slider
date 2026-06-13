import 'package:flutter/material.dart';
import 'wave_clipper.dart';

/// A customizable drag slider with wave animation effect.
///
/// This widget provides a slide-to-action interface with an animated wave trail
/// that follows the slider thumb. It supports both LTR and RTL directions.
class DragWaveSlider extends StatefulWidget {
  /// The text displayed in the slider when not dragging.
  /// Ignored if [textWidget] is provided.
  final String? text;

  /// A custom widget to display as the slider label.
  /// Takes priority over [text].
  final Widget? textWidget;

  /// The color of the slider thumb and wave animation.
  final Color sliderColor;

  /// An optional gradient for the thumb background.
  /// Takes priority over [sliderColor] for the thumb fill.
  final Gradient? thumbGradient;

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

  /// The threshold (0.0 to 1.0) at which the [onSlideComplete] callback is triggered.
  final double slideThreshold;

  /// Callback when the slider is dragged to completion.
  final VoidCallback onSlideComplete;

  /// Called continuously as the user drags, with the current progress (0.0–1.0).
  final ValueChanged<double>? onSlideChange;

  /// Optional icon to display in the slider thumb.
  /// Ignored if [thumbWidget] is provided.
  final IconData? thumbIcon;

  /// Optional icon color for the thumb icon.
  final Color? thumbIconColor;

  /// A fully custom widget to use as the thumb.
  /// Takes priority over [thumbIcon].
  final Widget? thumbWidget;

  /// Whether the slider resets to the start after [onSlideComplete] fires.
  /// Defaults to true.
  final bool resetOnComplete;

  /// Whether the slider accepts user interaction.
  /// When false, the thumb is greyed out and dragging is disabled.
  final bool enabled;

  const DragWaveSlider({
    super.key,
    this.text,
    this.textWidget,
    required this.onSlideComplete,
    this.onSlideChange,
    this.sliderColor = Colors.blue,
    this.thumbGradient,
    this.backgroundColor = Colors.grey,
    this.textColor = Colors.white,
    this.height = 60,
    this.waveAmplitude = 3.0,
    this.waveDuration = const Duration(milliseconds: 1500),
    this.slideThreshold = 0.9,
    this.thumbIcon,
    this.thumbIconColor,
    this.thumbWidget,
    this.resetOnComplete = true,
    this.enabled = true,
  }) : assert(
          text != null || textWidget != null,
          'Provide either text or textWidget',
        );

  @override
  State<DragWaveSlider> createState() => _DragWaveSliderState();
}

class _DragWaveSliderState extends State<DragWaveSlider>
    with TickerProviderStateMixin {
  double _sliderValue = 0;
  late AnimationController _waveController;

  Color get _effectiveSliderColor =>
      widget.enabled ? widget.sliderColor : Colors.grey.shade400;

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

  void _onDragUpdate(DragUpdateDetails details, double maxSlide, bool isRtl) {
    if (!widget.enabled) return;
    setState(() {
      if (isRtl) {
        _sliderValue -= details.delta.dx / maxSlide;
      } else {
        _sliderValue += details.delta.dx / maxSlide;
      }
      _sliderValue = _sliderValue.clamp(0.0, 1.0);
    });
    widget.onSlideChange?.call(_sliderValue);
    if (_sliderValue >= widget.slideThreshold) {
      widget.onSlideComplete();
      if (widget.resetOnComplete) {
        setState(() => _sliderValue = 0);
        widget.onSlideChange?.call(0);
      }
    }
  }

  void _onDragEnd(DragEndDetails details) {
    if (!widget.enabled) return;
    if (_sliderValue < widget.slideThreshold) {
      setState(() => _sliderValue = 0);
      widget.onSlideChange?.call(0);
    }
  }

  Widget _buildThumb(double thumbSize) {
    if (widget.thumbWidget != null) {
      return SizedBox(
        width: thumbSize,
        height: thumbSize,
        child: widget.thumbWidget,
      );
    }

    final isRtl = Directionality.of(context) == TextDirection.rtl;
    final effectiveGradient = widget.enabled
        ? (widget.thumbGradient ??
            LinearGradient(
              colors: [
                widget.sliderColor,
                widget.sliderColor,
              ],
            ))
        : LinearGradient(
            colors: [Colors.grey.shade400, Colors.grey.shade400],
          );

    return Container(
      width: thumbSize,
      height: thumbSize,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: effectiveGradient,
        boxShadow: widget.enabled
            ? [
                BoxShadow(
                  color: widget.sliderColor.withValues(alpha: 0.4),
                  blurRadius: 12,
                  spreadRadius: 2,
                ),
              ]
            : null,
      ),
      child: Icon(
        widget.thumbIcon ?? (isRtl ? Icons.arrow_right : Icons.arrow_right),
        color: widget.thumbIconColor ?? Colors.white,
        size: thumbSize * 0.55,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isRtl = Directionality.of(context) == TextDirection.rtl;

    return Container(
      height: widget.height,
      padding: EdgeInsets.all(widget.height * 0.1),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(widget.height / 2),
        color: widget.backgroundColor.withValues(alpha: 0.15),
        border: Border.all(
          color: _effectiveSliderColor.withValues(alpha: 0.3),
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
                    final trailWidth =
                        _sliderValue * maxSlide + thumbSize / 2;
                    return ClipPath(
                      clipper: WaveClipper(
                        animValue: _waveController.value,
                        waveAmp: widget.waveAmplitude,
                        isRtl: isRtl,
                      ),
                      child: Container(
                        width: trailWidth,
                        height: thumbSize,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment(
                                -5.0 + 2.0 * _waveController.value, 0),
                            end: Alignment(
                                1.0 + 2.0 * _waveController.value, 0),
                            colors: [
                              _effectiveSliderColor.withValues(alpha: 0.1),
                              _effectiveSliderColor.withValues(alpha: 0.35),
                              _effectiveSliderColor.withValues(alpha: 0.15),
                              _effectiveSliderColor.withValues(alpha: 0.4),
                              _effectiveSliderColor.withValues(alpha: 0.1),
                            ],
                            stops: const [0.0, 0.25, 0.5, 0.75, 1.0],
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: _effectiveSliderColor.withValues(alpha: 0.2),
                              blurRadius: 10,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              Center(
                child: widget.textWidget ??
                    Text(
                      widget.text!,
                      style: TextStyle(
                        color: widget.enabled
                            ? widget.textColor.withValues(alpha: 0.7)
                            : Colors.grey.shade400,
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
                  onHorizontalDragUpdate: (details) =>
                      _onDragUpdate(details, maxSlide, isRtl),
                  onHorizontalDragEnd: _onDragEnd,
                  child: _buildThumb(thumbSize),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
