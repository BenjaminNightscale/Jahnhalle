import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:jahnhalle/components/app%20bar/cart_app_bar.dart';
import 'package:jahnhalle/services/database/cart.dart';
import 'package:jahnhalle/components/footer/footer.dart';
import 'package:jahnhalle/main.dart';
import 'package:jahnhalle/services/model/checkout_cart_model.dart';
import 'package:jahnhalle/pages/order/payment_screen.dart';
import 'package:jahnhalle/components/themes/colors.dart';
import 'package:provider/provider.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CartAppBar(),
      body: Consumer<Cart>(builder: (context, value, _) {
        return Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: value.items.length,
                itemBuilder: (context, index) {
                  var item = value.items[index];
                  return Container(
                    width: dimensions.width * 0.45,
                    padding: EdgeInsets.all(dimensions.width * 0.03),
                    margin: const EdgeInsets.symmetric(
                        horizontal: 20.0, vertical: 10.0),
                    decoration: BoxDecoration(
                      border: Border.all(
                          color: Theme.of(context).colorScheme.onSurface,
                          width: 2.0),
                      color: scaffoldBackgroundColor,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.name.toUpperCase(),
                          style: const TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                              fontSize: 17),
                        ),
                        Text(
                          item.ingredients.join(', '),
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "${item.price.toStringAsFixed(2)}€",
                              style: const TextStyle(
                                  color: Colors.black, fontSize: 18),
                            ),
                            Row(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    value.decreaseQuantity(item);
                                  },
                                  child: Container(
                                    padding: EdgeInsets.all(
                                        dimensions.width * 0.0001),
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onSurface,
                                          width: 2.0),
                                      color: scaffoldBackgroundColor,
                                    ),
                                    child: const Center(
                                        child: Icon(
                                      Icons.remove,
                                      size: 20,
                                    )),
                                  ),
                                ),
                                SizedBox(
                                  width: dimensions.width * 0.03,
                                ),
                                Text(
                                  "${item.quantity}",
                                  style: const TextStyle(
                                      color: Colors.black, fontSize: 18),
                                ),
                                SizedBox(
                                  width: dimensions.width * 0.03,
                                ),
                                GestureDetector(
                                  onTap: () {
                                    value.increaseQuantity(item);
                                  },
                                  child: Container(
                                    padding: EdgeInsets.all(
                                        dimensions.width * 0.0001),
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onSurface,
                                          width: 2.0),
                                      color: scaffoldBackgroundColor,
                                    ),
                                    child: const Center(
                                        child: Icon(
                                      Icons.add,
                                      size: 20,
                                    )),
                                  ),
                                ),
                              ],
                            )
                          ],
                        )
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        );
      }),
      bottomNavigationBar: _buildFooter(context),
    );
  }

  Widget _buildFooter(BuildContext context) {
    return Consumer<Cart>(
      builder: (context, cart, child) {
        return cart.items.isNotEmpty
            ? Footer(
                buttonText: 'BEZAHLEN'.toUpperCase(),
                onPress: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const PaymentScreen(),
                  ));
                },
              )
            : const SizedBox.shrink();
      },
    );
  }
}
