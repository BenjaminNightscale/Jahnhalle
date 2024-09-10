import 'package:flutter/material.dart';
import 'package:jahnhalle/components/cart/cart.dart';
import 'package:jahnhalle/components/app%20bar/cart_app_bar.dart';
import 'package:jahnhalle/components/footer/footer.dart';
import 'package:provider/provider.dart';

class OverviewPage extends StatelessWidget {
  const OverviewPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CartAppBar(),
      body: Column(
        children: [
          Expanded(
            child: Consumer<Cart>(
              builder: (context, cart, child) {
                if (cart.items.isEmpty) {
                  return const Center(
                    child: Text('Your cart is empty'),
                  );
                } else {
                  return ListView.builder(
                    itemCount: cart.items.length,
                    itemBuilder: (context, index) {
                      final drink = cart.items[index];
                      return ListTile(
                        title: Text(drink.name),
                      );
                    },
                  );
                }
              },
            ),
          ),
          Footer(
            buttonText: 'BEZAHLEN',
            onPress: () {
              // Handle the button press here
            },
          ),
        ],
      ),
    );
  }
}
