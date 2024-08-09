import 'package:flutter/material.dart';
import 'package:jahnhalle/components/cart/cart.dart';
import 'package:jahnhalle/components/cart/render_drinks_cart.dart';
import 'package:jahnhalle/services/database/drink.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';

class CartView extends StatelessWidget {
  final VoidCallback onProceedToCheckout;

  CartView({required this.onProceedToCheckout});

  Future<List<Drink>> fetchDrinks() async {
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('drinks').get();
    return querySnapshot.docs.map((doc) => Drink.fromFirestore(doc)).toList();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Drink>>(
      future: fetchDrinks(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return const Center(child: Text('Error fetching drinks'));
        }

        List<Drink> drinks = snapshot.data ?? [];

        return Consumer<Cart>(
          builder: (context, cart, child) {
            return Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        const SizedBox(height: 5),
                        // PickUp(),
                        Divider(color: Theme.of(context).colorScheme.outline),
                        ...cart.items
                            .map((drink) =>
                                RenderProduct(drink: drink, cart: cart))
                            .toList(),
                        Divider(color: Theme.of(context).colorScheme.outline),
                        Row(
                          children: [
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20.0, vertical: 5.0),
                                child: InkWell(
                                  onTap: () {
                                    Navigator.of(context)
                                        .pop(); // Go back to the previous page
                                  },
                                  child: Text(
                                    '+ Getränk hinzufügen',
                                    style: Theme.of(context)
                                        .textTheme
                                        .displayMedium
                                        ?.copyWith(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primary,
                                        ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Divider(color: Theme.of(context).colorScheme.outline),
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Oft zusammen gekauft',
                                  style:
                                      Theme.of(context).textTheme.displayLarge),
                              Text(
                                  'Basierend auf was andere kunden gekauft haben',
                                  style:
                                      Theme.of(context).textTheme.bodyMedium),
                              const SizedBox(height: 10),
                              Container(
                                height: 200,
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: drinks.length,
                                  itemBuilder: (context, index) =>
                                      RenderDrink(drink: drinks[index]),
                                ),
                              ),
                            ],
                          ),
                        ),
                        // SummaryArea(),
                        Divider(color: Theme.of(context).colorScheme.outline),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}

class RenderDrink extends StatelessWidget {
  final Drink drink;

  RenderDrink({required this.drink});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10),
      width: 125,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 125,
            height: 125,
            color: Theme.of(context)
                .colorScheme
                .background, // Default to background color
            child: Image.asset(
              'assets/placeholder_image.png', // Always use the placeholder image
              width: 125,
              height: 125,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 10),
          Flexible(
            child: Text(
              drink.name,
              style: Theme.of(context).textTheme.displaySmall,
              overflow: TextOverflow.ellipsis, // Prevent overflow
            ),
          ),
          Text(
            '${drink.price.toStringAsFixed(2)}€',
            style: Theme.of(context).textTheme.displayMedium,
          ),
          Flexible(
            child: Text(
              drink.ingredients.join(', '),
              style: Theme.of(context).textTheme.bodyMedium,
              overflow: TextOverflow.ellipsis, // Prevent overflow
            ),
          ),
        ],
      ),
    );
  }
}
