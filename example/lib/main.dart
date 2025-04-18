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
  final steps = ['Start', 'Upload', 'Review', 'Submit'];

  void _nextStep() {
    setState(() {
      currentStep = currentStep + 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Stepper Demo',
      home: Scaffold(
        appBar: AppBar(title: const Text('Custom Stepper UI')),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              CustomStepper(
                currentStep: currentStep,
                steps: steps,
                onStepTapped: (index) => setState(() => currentStep = index),
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: _nextStep,
                child: const Text('Next'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
