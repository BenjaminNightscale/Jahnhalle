import 'package:flutter/material.dart';

class ProgressStepper extends StatelessWidget {
  final int currentStep;

  const ProgressStepper({required this.currentStep, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60.0,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            height: 2.0,
            margin: const EdgeInsets.symmetric(horizontal: 16.0),
            child: LinearProgressIndicator(
              value: _getProgressValue(),
              backgroundColor: Theme.of(context).colorScheme.secondary,
              valueColor: AlwaysStoppedAnimation<Color>(
                Theme.of(context).colorScheme.primary,
              ),
            ),
          ),
          Positioned.fill(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildStepColumn(context, "1", "Menü", isCompleted: currentStep >= 1),
                _buildStepColumn(context, "2", "Einkaufswagen", isCompleted: currentStep >= 2),
                _buildStepColumn(context, "3", "Bezahlung", isCompleted: currentStep >= 3),
              ],
            ),
          ),
        ],
      ),
    );
  }

  double _getProgressValue() {
    switch (currentStep) {
      case 1:
        return 0.2;
      case 2:
        return 0.5;
      case 3:
        return 0.8;
      default:
        return 0.0;
    }
  }

  Widget _buildStepColumn(BuildContext context, String number, String label, {required bool isCompleted}) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.all(6.0),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isCompleted ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.background,
            border: Border.all(color: Theme.of(context).colorScheme.primary),
          ),
          child: Text(
            number,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: isCompleted ? Theme.of(context).colorScheme.onPrimary : Theme.of(context).colorScheme.primary,
                ),
          ),
        ),
        const SizedBox(height: 4.0),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }
}
