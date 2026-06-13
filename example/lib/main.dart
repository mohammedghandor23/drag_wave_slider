import 'package:flutter/material.dart';
import 'package:drag_wave_slider/drag_wave_slider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Drag Wave Slider Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  double _progress = 0.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Drag Wave Slider Demo'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _SectionLabel('Basic'),
            const SizedBox(height: 12),
            DragWaveSlider(
              text: 'Slide to Unlock',
              sliderColor: Colors.blue,
              backgroundColor: Colors.grey,
              textColor: Colors.white,
              onSlideComplete: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Unlocked!')),
                );
              },
            ),
            const SizedBox(height: 32),
            _SectionLabel('onSlideChange — live progress'),
            const SizedBox(height: 12),
            DragWaveSlider(
              text: 'Drag me',
              sliderColor: Colors.orange,
              backgroundColor: Colors.orange.shade100,
              textColor: Colors.orange.shade900,
              slideThreshold: 1.1,
              onSlideComplete: () {},
              onSlideChange: (v) => setState(() => _progress = v),
            ),
            const SizedBox(height: 8),
            LinearProgressIndicator(
              value: _progress,
              color: Colors.orange,
              backgroundColor: Colors.orange.shade100,
              minHeight: 6,
              borderRadius: BorderRadius.circular(4),
            ),
            const SizedBox(height: 4),
            Text(
              '${(_progress * 100).toStringAsFixed(1)}%',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.orange.shade800),
            ),
            const SizedBox(height: 32),
            _SectionLabel('resetOnComplete = false'),
            const SizedBox(height: 12),
            DragWaveSlider(
              text: 'Slide to Lock',
              sliderColor: Colors.indigo,
              backgroundColor: Colors.indigo.shade100,
              textColor: Colors.indigo.shade800,
              resetOnComplete: false,
              onSlideComplete: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Locked — thumb stays at end!')),
                );
              },
            ),
            const SizedBox(height: 32),
            _SectionLabel('enabled = false'),
            const SizedBox(height: 12),
            DragWaveSlider(
              text: 'Disabled Slider',
              enabled: false,
              onSlideComplete: () {},
            ),
            const SizedBox(height: 32),
            _SectionLabel('thumbGradient'),
            const SizedBox(height: 12),
            DragWaveSlider(
              text: 'Slide to Pay',
              sliderColor: Colors.teal,
              backgroundColor: Colors.teal.shade50,
              textColor: Colors.teal.shade800,
              thumbIcon: Icons.payment,
              thumbGradient: LinearGradient(
                colors: [Colors.teal, Colors.cyan.shade400],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              onSlideComplete: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Payment confirmed!')),
                );
              },
            ),
            const SizedBox(height: 32),
            _SectionLabel('textWidget'),
            const SizedBox(height: 12),
            DragWaveSlider(
              textWidget: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.lock_open, size: 16, color: Colors.green.shade700),
                  const SizedBox(width: 6),
                  Text(
                    'SLIDE TO UNLOCK',
                    style: TextStyle(
                      color: Colors.green.shade700,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.5,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
              sliderColor: Colors.green,
              backgroundColor: Colors.green.shade100,
              onSlideComplete: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Custom label unlocked!')),
                );
              },
            ),
            const SizedBox(height: 32),
            _SectionLabel('thumbWidget'),
            const SizedBox(height: 12),
            DragWaveSlider(
              text: 'Custom Thumb',
              sliderColor: Colors.deepPurple,
              backgroundColor: Colors.deepPurple.shade100,
              textColor: Colors.deepPurple.shade800,
              thumbWidget: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [Colors.deepPurple, Colors.pink.shade300],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.deepPurple.withValues(alpha: 0.4),
                      blurRadius: 12,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: const Icon(Icons.star, color: Colors.white, size: 22),
              ),
              onSlideComplete: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Custom thumb done!')),
                );
              },
            ),
            const SizedBox(height: 32),
            _SectionLabel('Custom Icon'),
            const SizedBox(height: 12),
            DragWaveSlider(
              text: 'Slide to Delete',
              sliderColor: Colors.red,
              backgroundColor: Colors.red.shade100,
              textColor: Colors.red.shade800,
              thumbIcon: Icons.delete,
              thumbIconColor: Colors.white,
              onSlideComplete: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Deleted!')),
                );
              },
            ),
            const SizedBox(height: 32),
            _SectionLabel('RTL'),
            const SizedBox(height: 12),
            Directionality(
              textDirection: TextDirection.rtl,
              child: DragWaveSlider(
                text: 'اسحب للفتح',
                sliderColor: Colors.purple,
                backgroundColor: Colors.purple.shade100,
                textColor: Colors.purple.shade800,
                onSlideComplete: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('تم الفتح!')),
                  );
                },
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String label;
  const _SectionLabel(this.label);

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
    );
  }
}
