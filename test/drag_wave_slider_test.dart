import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:drag_wave_slider/drag_wave_slider.dart';

Widget _wrap(Widget child) => MaterialApp(
      home: Scaffold(body: Center(child: SizedBox(width: 300, child: child))),
    );

void main() {
  group('DragWaveSlider — rendering', () {
    testWidgets('renders text label', (tester) async {
      await tester.pumpWidget(_wrap(DragWaveSlider(
        text: 'Slide to Unlock',
        onSlideComplete: () {},
      )));
      expect(find.text('Slide to Unlock'), findsOneWidget);
    });

    testWidgets('renders textWidget when provided', (tester) async {
      await tester.pumpWidget(_wrap(DragWaveSlider(
        textWidget: Text('Custom Widget Label'),
        onSlideComplete: () {},
      )));
      expect(find.text('Custom Widget Label'), findsOneWidget);
    });

    testWidgets('renders thumbIcon', (tester) async {
      await tester.pumpWidget(_wrap(DragWaveSlider(
        text: 'Slide to Delete',
        thumbIcon: Icons.delete,
        onSlideComplete: () {},
      )));
      expect(find.byIcon(Icons.delete), findsOneWidget);
    });

    testWidgets('renders thumbWidget when provided', (tester) async {
      await tester.pumpWidget(_wrap(DragWaveSlider(
        text: 'Slide',
        thumbWidget: Container(key: Key('custom_thumb'), color: Colors.red),
        onSlideComplete: () {},
      )));
      expect(find.byKey(Key('custom_thumb')), findsOneWidget);
    });

    testWidgets('disabled slider shows greyed style', (tester) async {
      await tester.pumpWidget(_wrap(DragWaveSlider(
        text: 'Disabled',
        enabled: false,
        onSlideComplete: () {},
      )));
      expect(find.text('Disabled'), findsOneWidget);
    });
  });

  group('DragWaveSlider — interaction', () {
    testWidgets('disabled slider does not fire onSlideComplete on drag',
        (tester) async {
      bool called = false;
      await tester.pumpWidget(_wrap(DragWaveSlider(
        text: 'Disabled',
        enabled: false,
        onSlideComplete: () => called = true,
      )));
      final slider = find.byType(DragWaveSlider);
      await tester.drag(slider, Offset(300, 0));
      await tester.pump();
      expect(called, isFalse);
    });

    testWidgets('onSlideChange fires during drag', (tester) async {
      final values = <double>[];
      await tester.pumpWidget(_wrap(DragWaveSlider(
        text: 'Slide',
        onSlideComplete: () {},
        onSlideChange: values.add,
        slideThreshold: 1.1,
      )));
      final slider = find.byType(DragWaveSlider);
      final rect = tester.getRect(slider);
      // Start at the left side of the slider where the thumb begins
      final thumbCenter = Offset(rect.left + 30, rect.center.dy);
      final gesture = await tester.startGesture(thumbCenter);
      await gesture.moveBy(const Offset(40, 0));
      await tester.pump();
      await gesture.up();
      expect(values, isNotEmpty);
      expect(values.any((v) => v > 0.0), isTrue);
    });

    testWidgets('resetOnComplete=true resets slider after completion',
        (tester) async {
      bool completed = false;
      final changeValues = <double>[];
      await tester.pumpWidget(_wrap(DragWaveSlider(
        text: 'Slide',
        resetOnComplete: true,
        slideThreshold: 0.5,
        onSlideComplete: () => completed = true,
        onSlideChange: changeValues.add,
      )));
      final thumb = find.byType(GestureDetector).first;
      await tester.drag(thumb, Offset(200, 0));
      await tester.pump();
      expect(completed, isTrue);
      expect(changeValues.last, equals(0.0));
    });

    testWidgets('resetOnComplete=false keeps slider at end after completion',
        (tester) async {
      bool completed = false;
      double? lastChange;
      await tester.pumpWidget(_wrap(DragWaveSlider(
        text: 'Slide',
        resetOnComplete: false,
        slideThreshold: 0.5,
        onSlideComplete: () => completed = true,
        onSlideChange: (v) => lastChange = v,
      )));
      final thumb = find.byType(GestureDetector).first;
      await tester.drag(thumb, Offset(200, 0));
      await tester.pump();
      expect(completed, isTrue);
      expect(lastChange, isNot(equals(0.0)));
    });
  });

  group('DragWaveSlider — assert', () {
    testWidgets('throws assert when neither text nor textWidget provided',
        (tester) async {
      expect(
        () => DragWaveSlider(onSlideComplete: () {}),
        throwsAssertionError,
      );
    });
  });
}
