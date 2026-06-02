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

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Drag Wave Slider Demo'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Basic Example',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              DragWaveSlider(
                text: 'Slide to Unlock',
                sliderColor: Colors.blue,
                backgroundColor: Colors.grey,
                textColor: Colors.white,
                onSlideComplete: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Slider completed!')),
                  );
                },
              ),
              const SizedBox(height: 40),
              const Text(
                'Custom Colors',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              DragWaveSlider(
                text: 'Slide to Confirm',
                sliderColor: Colors.green,
                backgroundColor: Colors.green.shade100,
                textColor: Colors.green.shade800,
                onSlideComplete: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Confirmed!')),
                  );
                },
              ),
              const SizedBox(height: 40),
              const Text(
                'With Custom Icon',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
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
              const SizedBox(height: 40),
              const Text(
                'RTL Support',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
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
            ],
          ),
        ),
      ),
    );
  }
}
