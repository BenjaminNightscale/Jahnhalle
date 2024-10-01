import 'package:flutter/material.dart';
import 'package:jahnhalle/services/database/cart.dart';
import 'package:provider/provider.dart';

class Footer extends StatelessWidget {
  final String buttonText;
  final String? link;
  final bool showTotal;
  final double? tipAmount;
  final VoidCallback? onPress;

  Footer(
      {required this.buttonText,
      this.link,
      this.onPress,
      this.tipAmount,
      this.showTotal = true});

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);

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
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Visibility(
                visible: showTotal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Baseline(
                          baselineType: TextBaseline.alphabetic,
                          baseline: 20, // Adjust this value to align correctly
                          child: Text(
                            'TOTAL',
                            style: Theme.of(context)
                                .textTheme
                                .displayMedium
                                ?.copyWith(
                                  color:
                                      Theme.of(context).colorScheme.onSurface,
                                ),
                          ),
                        ),
                        const SizedBox(width: 5),
                        Baseline(
                          baselineType: TextBaseline.alphabetic,
                          baseline: 20, // Adjust this value to align correctly
                          child: Text(
                            'inkl. MwSt.',
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall
                                ?.copyWith(
                                  color:
                                      Theme.of(context).colorScheme.onSurface,
                                ),
                          ),
                        ),
                      ],
                    ),
                    Baseline(
                      baselineType: TextBaseline.alphabetic,
                      baseline: 20, // Adjust this value to align correctly
                      child: Text(
                        tipAmount != null
                            ? "${(tipAmount! + cart.subtotal).toStringAsFixed(2)} €"
                            : '${cart.subtotal.toStringAsFixed(2)} €',
                        style: Theme.of(context)
                            .textTheme
                            .displayMedium
                            ?.copyWith(
                              color: Theme.of(context).colorScheme.onPrimary,
                            ),
                      ),
                    ),
                  ],
                ),
              ),
              Visibility(
                  visible: showTotal == false,
                  child: const SizedBox(height: 10)),
              const SizedBox(height: 10),
              SafeArea(
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
                        style: Theme.of(context)
                            .textTheme
                            .displaySmall
                            ?.copyWith(
                                color: Theme.of(context).colorScheme.onPrimary,
                                fontSize: 15,
                                fontWeight: FontWeight.w800),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 5),
            ],
          ),
        ),
      ],
    );
  }
}
