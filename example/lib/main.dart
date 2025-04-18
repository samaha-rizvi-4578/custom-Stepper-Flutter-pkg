import 'package:flutter/material.dart';
// import '../../package:lib/custom_stepper.dart';
// import '../../lib/custom_stepper.dart;

import 'package:custom_stepper/custom_stepper.dart';

void main() => runApp(const MyApp());

class MyApp extends StatefulWidget {
  const MyApp({super.key});
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int _currentStep = 0;

  @override
  Widget build(BuildContext context) {
    final steps = ['Start', 'Upload', 'Review', 'Submit'];

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Custom Stepper Demo')),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomStepper(
              currentStep: _currentStep,
              steps: steps,
              onStepTapped: (index) {
                setState(() {
                  _currentStep = index;
                });
              },
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _currentStep = (_currentStep + 1) % steps.length;
                });
              },
              child: const Text('Next Step'),
            ),
          ],
        ),
      ),
    );
  }
}
