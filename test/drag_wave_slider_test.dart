import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:drag_wave_slider/drag_wave_slider.dart';

void main() {
  testWidgets('DragWaveSlider renders correctly', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: DragWaveSlider(
            text: 'Slide to Unlock',
            onSlideComplete: () {},
          ),
        ),
      ),
    );

    expect(find.text('Slide to Unlock'), findsOneWidget);
  });

  testWidgets('DragWaveSlider with custom icon', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: DragWaveSlider(
            text: 'Slide to Delete',
            thumbIcon: Icons.delete,
            onSlideComplete: () {},
          ),
        ),
      ),
    );

    expect(find.byIcon(Icons.delete), findsOneWidget);
  });
}
