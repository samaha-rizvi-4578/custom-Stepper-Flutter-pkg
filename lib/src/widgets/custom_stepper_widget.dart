import 'package:flutter/material.dart';

class CustomStepper extends StatelessWidget {
  final int currentStep;
  final List<String> steps;
  final Axis direction;
  final Function(int)? onStepTapped;
  final Color activeColor;
  final Color completedColor;
  final Color inactiveColor;

  const CustomStepper({
    super.key,
    required this.currentStep,
    required this.steps,
    this.direction = Axis.horizontal,
    this.onStepTapped,
    this.activeColor = Colors.blue,
    this.completedColor = Colors.green,
    this.inactiveColor = Colors.grey,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildProgressBar(),
        const SizedBox(height: 16),
        _buildStepper(),
      ],
    );
  }

  Widget _buildProgressBar() {
    double progress = (currentStep + 1) / steps.length;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: LinearProgressIndicator(
        value: progress,
        color: completedColor,
        backgroundColor: inactiveColor.withOpacity(0.3),
        minHeight: 8,
      ),
    );
  }

  Widget _buildStepper() {
    return Flex(
      direction: direction,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: List.generate(steps.length, (index) {
        final isActive = index == currentStep;
        final isCompleted = index < currentStep;
        final color = isCompleted
            ? completedColor
            : isActive
                ? activeColor
                : inactiveColor;

        return GestureDetector(
          onTap: () => onStepTapped?.call(index),
          child: Column(
            children: [
              CircleAvatar(
                backgroundColor: color,
                child: Text('${index + 1}'),
              ),
              const SizedBox(height: 4),
              Text(
                steps[index],
                style: TextStyle(
                  color: isActive ? activeColor : Colors.black,
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
