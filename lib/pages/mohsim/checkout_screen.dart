import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:jahnhalle/components/app%20bar/cart_app_bar.dart';
import 'package:jahnhalle/components/cart/cart.dart';
import 'package:jahnhalle/main.dart';
import 'package:jahnhalle/pages/mohsim/model/checkout_cart_model.dart';
import 'package:jahnhalle/pages/mohsim/payment_screen.dart';
import 'package:jahnhalle/themes/colors.dart';
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
                    margin: EdgeInsets.all(dimensions.width * 0.03),
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
                          item.name,
                          style: const TextStyle(
                              color: Colors.black, fontWeight: FontWeight.w400),
                        ),
                        Text(
                          item.ingredients.join(","),
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "${item.price}€",
                              style: const TextStyle(color: Colors.black),
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
                                  width: dimensions.width * 0.02,
                                ),
                                Text(
                                  "${item.quantity}",
                                  style: const TextStyle(color: Colors.black),
                                ),
                                SizedBox(
                                  width: dimensions.width * 0.02,
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
            Container(
              width: dimensions.width,
              padding: EdgeInsets.all(dimensions.width * 0.05),
              // margin: EdgeInsets.all(dimensions.width * 0.03),
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                      color: Theme.of(context).colorScheme.onSurface,
                      width: 2.0),
                ),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Baseline(
                            baselineType: TextBaseline.alphabetic,
                            baseline:
                                20, // Adjust this value to align correctly
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
                            baseline:
                                20, // Adjust this value to align correctly
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
                          '${value.subtotal.toStringAsFixed(2)}€',
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
                  SizedBox(
                    height: dimensions.width * 0.01,
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const PaymentScreen(),
                      ));
                    },
                    child: Container(
                      padding: EdgeInsets.all(dimensions.width * 0.01),
                      decoration: BoxDecoration(
                        border: Border.all(
                            color: Theme.of(context).colorScheme.onSurface,
                            width: 2.0),
                        color: scaffoldBackgroundColor,
                      ),
                      child: const Center(
                        child: Text(
                          'BEZAHLEN',
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        );
      }),
    );
  }
}
