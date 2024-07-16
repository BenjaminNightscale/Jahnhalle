import 'package:flutter/material.dart';
import 'package:jahnhalle/components/cart/cart.dart';
import 'package:jahnhalle/services/database/drink.dart';
import 'package:provider/provider.dart';

class DrinkItem extends StatelessWidget {
  final Drink drink;

  const DrinkItem({required this.drink, super.key});

  @override
  Widget build(BuildContext context) {
    bool isOutOfStock = drink.quantity <= 0;

    return InkWell(
      onTap: () {
        if (!isOutOfStock) {
          Provider.of<Cart>(context, listen: false).addItem(drink);
        }
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 0.0),
        padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 15.0),
        decoration: BoxDecoration(
          color: isOutOfStock
              ? Theme.of(context).colorScheme.surface.withOpacity(0.5)
              : Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: IntrinsicHeight(
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      drink.name.toUpperCase(),
                      style:
                          Theme.of(context).textTheme.displayMedium?.copyWith(
                                color: isOutOfStock
                                    ? Colors.grey
                                    : Theme.of(context).colorScheme.onSurface,
                              ),
                    ),
                    SizedBox(height: 8.0), // Add vertical space
                    Wrap(
                      spacing: 4.0,
                      runSpacing: 4.0,
                      children: drink.ingredients.map((ingredient) {
                        return Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              ingredient,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(
                                    color: isOutOfStock
                                        ? Colors.grey
                                        : Theme.of(context)
                                            .colorScheme
                                            .onSurface,
                                  ),
                            ),
                            if (ingredient != drink.ingredients.last)
                              Container(
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 4.0),
                                padding: const EdgeInsets.all(4.0),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: isOutOfStock
                                        ? Colors.grey
                                        : Theme.of(context)
                                            .colorScheme
                                            .onSurface,
                                  ),
                                  borderRadius: BorderRadius.circular(4.0),
                                ),
                                child: Text(
                                  '+',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.copyWith(
                                        color: isOutOfStock
                                            ? Colors.grey
                                            : Theme.of(context)
                                                .colorScheme
                                                .onSurface,
                                      ),
                                ),
                              ),
                          ],
                        );
                      }).toList(),
                    ),
                    SizedBox(height: 8.0), // Add vertical space
                    Text(
                      '${drink.price.toStringAsFixed(2)} €',
                      style:
                          Theme.of(context).textTheme.displayMedium?.copyWith(
                                color: isOutOfStock
                                    ? Colors.grey
                                    : Theme.of(context).colorScheme.onSurface,
                              ),
                    ),
                    if (isOutOfStock)
                      const Text(
                        'Out of Stock',
                        style: TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                  ],
                ),
              ),
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: isOutOfStock ? Colors.grey : Colors.black,
                    width: 2.0,
                  ),
                  color: isOutOfStock
                      ? Theme.of(context).colorScheme.surface.withOpacity(0.5)
                      : Colors.transparent,
                ),
                child: Center(
                  child: Icon(
                    Icons.add,
                    size: 20, // Adjust the size as needed
                    color: isOutOfStock
                        ? Colors.grey
                        : Theme.of(context).colorScheme.onSurface,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
