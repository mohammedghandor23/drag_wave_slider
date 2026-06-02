# Drag Wave Slider

A beautiful and customizable drag slider widget with animated wave trail effect for Flutter applications. Perfect for slide-to-action interactions like "slide to unlock", "slide to confirm", or any action that requires deliberate user input.

## Features

- **Animated Wave Trail**: Beautiful wave animation that follows the slider thumb
- **Fully Customizable**: Configure colors, text, height, wave amplitude, and animation duration
- **RTL Support**: Works seamlessly with right-to-left layouts
- **Custom Icons**: Add custom icons to the slider thumb
- **Smooth Animations**: Fluid animations with configurable thresholds
- **Zero Dependencies**: Only depends on Flutter SDK

## Installation

Add this to your package's `pubspec.yaml` file:

```yaml
dependencies:
  drag_wave_slider: ^0.0.1
```

## Usage

```dart
import 'package:drag_wave_slider/drag_wave_slider.dart';

// Basic usage
DragWaveSlider(
  text: 'Slide to Unlock',
  sliderColor: Colors.blue,
  backgroundColor: Colors.grey,
  textColor: Colors.white,
  onSlideComplete: () {
    // Handle slide completion
    print('Slider completed!');
  },
)

// With custom icon
DragWaveSlider(
  text: 'Slide to Delete',
  sliderColor: Colors.red,
  backgroundColor: Colors.red.shade100,
  textColor: Colors.red.shade800,
  thumbIcon: Icons.delete,
  thumbIconColor: Colors.white,
  onSlideComplete: () {
    // Handle deletion
  },
)

// RTL support
Directionality(
  textDirection: TextDirection.rtl,
  child: DragWaveSlider(
    text: 'اسحب للفتح',
    sliderColor: Colors.purple,
    onSlideComplete: () {
      // Handle completion
    },
  ),
)
```

## Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `text` | `String` | required | Text displayed in the slider |
| `onSlideComplete` | `VoidCallback` | required | Callback when slider reaches threshold |
| `sliderColor` | `Color` | `Colors.blue` | Color of slider thumb and wave |
| `backgroundColor` | `Color` | `Colors.grey` | Background color of slider track |
| `textColor` | `Color` | `Colors.white` | Color of the text |
| `height` | `double` | `60` | Height of the slider |
| `waveAmplitude` | `double` | `3.0` | Amplitude of wave animation |
| `waveDuration` | `Duration` | `1500ms` | Duration of wave animation cycle |
| `slideThreshold` | `double` | `0.9` | Threshold (0.0-1.0) to trigger callback |
| `thumbIcon` | `IconData?` | `null` | Optional custom icon for thumb |
| `thumbIconColor` | `Color?` | `null` | Color for thumb icon |

## Example

See the `/example` directory for a complete demo app showcasing various configurations.

## License

MIT License - see LICENSE file for details.

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.
