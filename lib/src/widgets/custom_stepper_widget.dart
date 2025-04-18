import 'package:flutter/material.dart';

class DottedLine extends StatelessWidget {
  final Color color;
  final double height;
  final double dashWidth;
  final double dashSpacing;

  const DottedLine({
    super.key,
    required this.color,
    this.height = 2,
    this.dashWidth = 4,
    this.dashSpacing = 4,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final dashCount =
            (constraints.maxWidth / (dashWidth + dashSpacing)).floor();
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(dashCount, (_) {
            return SizedBox(
              width: dashWidth,
              height: height,
              child: DecoratedBox(
                decoration: BoxDecoration(color: color),
              ),
            );
          }),
        );
      },
    );
  }
}

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
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          //  100% Animated Progress Bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: TweenAnimationBuilder<double>(
              tween: Tween<double>(begin: 0, end: 1),
              duration: const Duration(milliseconds: 800),
              builder: (context, value, child) => ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: LinearProgressIndicator(
                  value: value,
                  minHeight: 8,
                  color: completedColor,
                  backgroundColor: inactiveColor,
                ),
              ),
            ),
          ),

          const SizedBox(height: 32),

          //  Celebration with Fade Transition
          AnimatedOpacity(
            opacity: 1,
            duration: const Duration(milliseconds: 600),
            child: Column(
              children: [
                Icon(Icons.celebration_rounded,
                    color: completedColor, size: 60),
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
            ),
          ),
        ],
      );
    }

    //  Stepper UI (default)
    final progress = (currentStep + 1) / steps.length;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // PROGRESS BAR
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: TweenAnimationBuilder<double>(
              tween: Tween<double>(begin: 0, end: progress),
              duration: const Duration(milliseconds: 700),
              curve: Curves.easeInOut,
              builder: (context, value, child) {
                return LinearProgressIndicator(
                  value: value,
                  minHeight: 8,
                  color: completedColor,
                  backgroundColor: inactiveColor,
                );
              },
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
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4.0),
                  child: DottedLine(
                    color: isLineCompleted
                        ? completedColor
                        : inactiveColor,
                  ),
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
                        duration: const Duration(milliseconds: 700),
                        curve: Curves.easeInOut,
                        width: isActive ? 48 : 40,
                        height: isActive ? 48 : 40,
                        decoration: BoxDecoration(
                          color: isStepCompleted
                              ? completedColor
                              : isActive
                                  ? activeColor
                                  : inactiveColor,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: isActive ? inactiveColor : isStepCompleted ? completedColor : inactiveColor,
                            width: 2,
                          ),
                          boxShadow: isActive
                              ? [
                                  BoxShadow(
                                    color: activeColor,
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
                      )),
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
