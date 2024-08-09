import 'package:flutter/material.dart';
import 'package:jahnhalle/components/cart/cart.dart';
import 'package:jahnhalle/components/app%20bar/cart_app_bar.dart';
import 'package:jahnhalle/components/footer/checkout_footer.dart';
import 'package:jahnhalle/pages/overview_page.dart';
import 'package:provider/provider.dart';

class CheckoutPage extends StatelessWidget {
  const CheckoutPage({super.key});

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
          CheckoutFooter(
            buttonText: 'HAUPTMENÜ',
            onPress: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const OverviewPage()),
              );
            },
          ),
        ],
      ),
    );
  }
}
