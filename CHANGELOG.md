## 0.1.0

* Added `onSlideChange(double value)` — real-time drag progress callback (0.0–1.0)
* Added `resetOnComplete` flag — control whether thumb snaps back after completion
* Added `enabled` flag — disable slider interaction with greyed-out visual state
* Added `thumbWidget` — pass any custom Widget as the thumb
* Added `textWidget` — pass any custom Widget as the slider label
* Added `thumbGradient` — gradient fill for the thumb instead of flat color
* Refactored into `src/` files (`wave_clipper.dart`, `drag_wave_slider_widget.dart`)
* Fixed `shouldReclip` bug — now correctly responds to `waveAmp` and `isRtl` changes
* Replaced deprecated `withOpacity` with `withValues(alpha:)` throughout
* Improved wave rendering performance using `quadraticBezierTo` instead of per-pixel `lineTo` loops
* Added comprehensive widget tests

## 0.0.1

* Initial release
* Drag slider with animated wave trail effect
* Full customization support (colors, text, height, wave parameters)
* RTL support
* Custom icon support
* Zero external dependencies
