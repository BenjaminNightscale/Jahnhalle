import 'package:flutter/material.dart';
import 'package:jahnhalle/components/cart/cart.dart';
import 'package:provider/provider.dart';

class TipSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 16.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        border: Border.all(color: Theme.of(context).colorScheme.outline),
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'TIP',
            style: Theme.of(context).textTheme.displayMedium,
          ),
          Text(
            'Staff receive 100% of the tip',
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _tipButton(context, cart, '5%', 5.0),
              _tipButton(context, cart, '10%', 10.0),
              _tipButton(context, cart, '15%', 15.0, isPopular: true),
              _tipButton(context, cart, '20%', 20.0),
            ],
          ),
        ],
      ),
    );
  }

  Widget _tipButton(
      BuildContext context, Cart cart, String label, double percentage,
      {bool isPopular = false}) {
    bool isSelected = cart.tipPercentage == percentage;

    return Column(
      children: [
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            foregroundColor: isSelected
                ? Theme.of(context).colorScheme.onPrimary
                : Theme.of(context).colorScheme.onSecondary,
            backgroundColor: isSelected
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).colorScheme.secondary,
            elevation: isSelected ? 5 : 0,
            padding:
                const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
          onPressed: () {
            cart.setTipPercentage(percentage);
          },
          child: Text(label, style: Theme.of(context).textTheme.labelSmall),
        ),

      ],
    );
  }
}
