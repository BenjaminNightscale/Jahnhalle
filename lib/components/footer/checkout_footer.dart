import 'package:flutter/material.dart';

class CheckoutFooter extends StatelessWidget {
  final String buttonText;
  final String? link;
  final VoidCallback? onPress;

  CheckoutFooter({required this.buttonText, this.link, this.onPress});

  @override
  Widget build(BuildContext context) {
    void _navigate() {
      if (link != null) {
        Navigator.pushNamed(context, link!);
      } else if (onPress != null) {
        onPress!();
      }
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          height: 2, // Height of the black line
          color: Colors.black, // Color of the black line
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: SafeArea(
            child: GestureDetector(
              onTap: _navigate,
              child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  border: Border.all(
                    color: Theme.of(context).colorScheme.onSurface,
                    width: 2,
                  ),
                ),
                padding: const EdgeInsets.all(10),
                alignment: Alignment.center,
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  transitionBuilder:
                      (Widget child, Animation<double> animation) {
                    return FadeTransition(child: child, opacity: animation);
                  },
                  child: Text(
                    buttonText,
                    key: ValueKey<String>(buttonText),
                    style: Theme.of(context).textTheme.displaySmall?.copyWith(
                          color: Theme.of(context).colorScheme.onPrimary,
                        ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
