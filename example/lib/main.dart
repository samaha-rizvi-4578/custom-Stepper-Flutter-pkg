import 'package:flutter/material.dart';
import 'package:custom_stepper/custom_stepper.dart';

void main() => runApp(const MyApp());

class MyApp extends StatefulWidget {
  const MyApp({super.key});
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int currentStep = 0;
  final steps = ['Start', 'Upload', 'Review', 'Submit', 'Extra', 'Check', 'Final', 'Done'];

  void _nextStep() {
    setState(() {
      currentStep = currentStep + 1;
    });
  }

  Widget _getStepContent(int step) {
    switch (step) {
      case 0:
        return const TextField(decoration: InputDecoration(labelText: 'Enter your name'));
      case 1:
        return ElevatedButton(onPressed: () {}, child: const Text('Upload File'));
      case 2:
        return const Text('Review your details here...');
      case 3:
        return const Text('Submit when ready.');
      case 4:
        return const TextField(decoration: InputDecoration(labelText: 'Extra Info'));
      case 5:
        return CheckboxListTile(
          title: const Text('Agree to terms'),
          value: true,
          onChanged: (_) {},
        );
      case 6:
        return const Text('Almost done...');
      case 7:
        return const Icon(Icons.check_circle, color: Colors.green, size: 64);
      default:
        return const SizedBox.shrink();
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Stepper Demo',
      home: Scaffold(
        appBar: AppBar(title: const Text('Custom Stepper UI')),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              CustomStepper(
                currentStep: currentStep,
                steps: steps,
                onStepTapped: (index) => setState(() => currentStep = index),

                // Custom color set
                colorSet: [Colors.pink, Colors.teal, Colors.black],
              ),
              const SizedBox(height: 30),

              ///  Step-specific content
              _getStepContent(currentStep),

              const SizedBox(height: 40),

              if (currentStep < steps.length)
                ElevatedButton(
                  onPressed: _nextStep,
                  child: const Text('Next'),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
