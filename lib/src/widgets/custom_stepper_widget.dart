import 'package:flutter/material.dart';

class CustomStepper extends StatelessWidget {
  final int currentStep;
  final List<String> steps;
  final Function(int)? onStepTapped;
  final Color activeColor;
  final Color completedColor;
  final Color inactiveColor;

  const CustomStepper({
    super.key,
    required this.currentStep,
    required this.steps,
    this.onStepTapped,
    this.activeColor = Colors.indigo,
    this.completedColor = Colors.green,
    this.inactiveColor = Colors.grey,
  });

  @override
  Widget build(BuildContext context) {
    final isCompleted = currentStep >= steps.length;

    if (isCompleted) {
      //  ALL STEPS DONE UI
      return Column(
        children: [
          const SizedBox(height: 24),
          Icon(Icons.celebration_rounded, color: completedColor, size: 60),
          const SizedBox(height: 16),
          Text(
            'All Steps Completed!',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: completedColor,
            ),
          ),
        ],
      );
    }

    // 🧱 NORMAL STEPPER UI
    final progress = (currentStep + 1) / steps.length;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // PROGRESS BAR
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 8,
              color: completedColor,
              backgroundColor: inactiveColor.withOpacity(0.3),
            ),
          ),
        ),
        const SizedBox(height: 24),

        // STEP INDICATORS WITH CONNECTORS
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(steps.length * 2 - 1, (i) {
            if (i.isOdd) {
              final beforeStep = i ~/ 2;
              final isLineCompleted = beforeStep < currentStep;

              return Expanded(
                child: Container(
                  height: 2,
                  color: isLineCompleted
                      ? completedColor
                      : inactiveColor.withOpacity(0.4),
                ),
              );
            } else {
              final index = i ~/ 2;
              final isActive = index == currentStep;
              final isStepCompleted = index < currentStep;

              return Column(
                children: [
                  GestureDetector(
                    onTap: () => onStepTapped?.call(index),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: isStepCompleted
                            ? completedColor
                            : isActive
                                ? activeColor
                                : inactiveColor,
                        shape: BoxShape.circle,
                        boxShadow: isActive
                            ? [
                                BoxShadow(
                                  color: activeColor.withOpacity(0.5),
                                  blurRadius: 8,
                                  spreadRadius: 2,
                                )
                              ]
                            : [],
                      ),
                      child: Center(
                        child: isStepCompleted
                            ? const Icon(Icons.check, color: Colors.white)
                            : Text(
                                '${index + 1}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    steps[index],
                    style: TextStyle(
                      color: isActive
                          ? activeColor
                          : isStepCompleted
                              ? completedColor
                              : inactiveColor,
                      fontWeight:
                          isActive ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                ],
              );
            }
          }),
        ),
      ],
    );
  }
}
