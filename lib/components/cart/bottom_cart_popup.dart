import 'package:flutter/material.dart';
import 'package:jahnhalle/components/cart/cart.dart';
import 'package:jahnhalle/pages/cart_page.dart';
import 'package:provider/provider.dart';

class BottomCartPopup extends StatelessWidget {
  const BottomCartPopup({super.key});

  @override
  Widget build(BuildContext context) {
    var cart = Provider.of<Cart>(context);
    int totalItems = cart.items.fold(0, (sum, item) => sum + item.quantity);

    return Container(
      color: Theme.of(context).colorScheme.surface,
      padding:
          const EdgeInsets.only(left: 10.0, right: 10.0, top: 5.0, bottom: 40),
      child: Row(
        children: [
          Expanded(
            child: _buildCartDetailsButton(context, cart, totalItems),
          ),
        ],
      ),
    );
  }

  Widget _buildCartDetailsButton(
      BuildContext context, Cart cart, int totalItems) {
    return ElevatedButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const CartPage()),
        );
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Theme.of(context).colorScheme.primary,
        padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 0.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.0),
              border: Border.all(
                  color: Theme.of(context).colorScheme.onPrimary,
                  width: 1.5), // Adding border
            ),
            child: Text(
              '$totalItems',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onPrimary,
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ),
          const SizedBox(width: 10),
          Text(
            'SHOW CART',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onPrimary,
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(width: 10),
          Text(
            '${cart.totalPrice.toStringAsFixed(2)} €',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onPrimary,
                  fontWeight: FontWeight.bold,
                ),
          ),
        ],
      ),
    );
  }
}
