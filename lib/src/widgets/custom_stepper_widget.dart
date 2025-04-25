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
  final List<Color>? colorSet;

  const CustomStepper({
    super.key,
    required this.currentStep,
    required this.steps,
    this.onStepTapped,
    this.colorSet,
  });

  @override
  Widget build(BuildContext context) {
    // Default colors: [active, completed, inactive]
    final Color activeColor = colorSet?.elementAt(0) ?? Colors.indigo;
    final Color completedColor = colorSet?.elementAt(1) ?? Colors.green;
    final Color inactiveColor = colorSet?.elementAt(2) ?? Colors.grey;

    final isCompleted = currentStep >= steps.length;

    if (isCompleted) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
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

    final progress = (currentStep + 1) / steps.length;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
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
                    color: isLineCompleted ? completedColor : inactiveColor,
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
                      duration: const Duration(milliseconds: 500),
                      curve: Curves.easeInOut,
                      width: isActive ? 48 : (isStepCompleted ? 30 : 16),
                      height: isActive ? 48 : (isStepCompleted ? 30 : 16),
                      decoration: BoxDecoration(
                        color: isStepCompleted
                            ? completedColor
                            : isActive
                                ? activeColor
                                : inactiveColor,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: isActive
                              ? inactiveColor
                              : isStepCompleted
                                  ? completedColor
                                  : inactiveColor,
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
                            ? const Icon(Icons.check,
                                color: Colors.white, size: 18)
                            : Text(
                                '${index + 1}',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize:
                                      isActive ? 14 : (isStepCompleted ? 12 : 10),
                                ),
                              ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  isStepCompleted || isActive
                      ? AnimatedDefaultTextStyle(
                          duration: const Duration(milliseconds: 400),
                          style: TextStyle(
                            color: isActive
                                ? activeColor
                                : isStepCompleted
                                    ? completedColor
                                    : inactiveColor,
                            fontWeight: isActive
                                ? FontWeight.bold
                                : FontWeight.normal,
                            fontSize: 11,
                          ),
                          child: Text(
                            steps[index],
                            textAlign: TextAlign.center,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        )
                      : const Icon(Icons.circle, size: 6, color: Colors.grey),
                ],
              );
            }
          }),
        ),
      ],
    );
  }
}
